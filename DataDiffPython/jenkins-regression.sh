#!/bin/bash
set -e # exit immediately if any command or function fails
yell() { echo "$0: $*" >&2; }
finally() { yell "$*"; return 111; }
try() { "$@" || finally "cannot $*"; }

function scale_dyno() {
    DYNO_NAME=$1
    NUM_DYNOS=$2

    heroku scale "${DYNO_NAME}"="${NUM_DYNOS}" --app "$3" || true
}

function scale_dynos_down() {
    queues=( "celery_beat" "celery_slow_reports" "celery_low_mem" "celery_high_mem")
    echo "Scaling Dynos Down"
    for worker_type in "${queues[@]}"
    do
        scale_dyno "${worker_type}" 0 "$1"
    done

    scale_down_webhook=$(heroku config:get SCALE_DOWN_WEBHOOK -a "$1")
    curl -H "Content-type: application/json" -X POST "$scale_down_webhook"
}

function scale_dynos_up() {
    declare -A queue_env_vars
    queue_env_vars=( ["celery_slow_reports"]="CELERY_SLOW_REPORT_WORKER_NUM" ["celery_low_mem"]="CELERY_LOW_MEM_WORKER_NUM" ["celery_high_mem"]="CELERY_HIGH_MEM_WORKER_NUM")

    echo "Scaling Dynos UP"
    scale_dyno celery_beat 1 "$1"
    for worker_name in "${!queue_env_vars[@]}"
    do
        scale_dyno "${worker_name}" "$(heroku config:get "${queue_env_vars["$worker_name"]}" -a "$1")" "$1"
    done

    reset_dynos_webhook=$(heroku config:get RESET_DYNOS_WEBHOOK -a "$1")
    curl -H "Content-type: application/json" -X POST "$reset_dynos_webhook"
}

function transfer_reports() {
    if [ "${TEST_ENV_NAME}" == "integration" ]
    then
        COMMAND="aws s3 cp s3://integration-test-reports/wtwood.tgz wtwood.tgz"
        ssh -i "/var/lib/jenkins/.ssh/${TEST_ENV_NAME}ftp" "ec2-user@${TEST_ENV_NAME}.customers.rapidrents.net" "${COMMAND}"
        COMMAND="sudo tar -xzvf wtwood.tgz -C /home/wtwood/home/wtwood"
        ssh -i "/var/lib/jenkins/.ssh/${TEST_ENV_NAME}ftp" "ec2-user@${TEST_ENV_NAME}.customers.rapidrents.net" "${COMMAND}"
    else
        try rsync -av -e "ssh -i /var/lib/jenkins/.ssh/${TEST_ENV_NAME}ftp" --rsync-path="sudo rsync" --delete "HasDataTest/Reports/BH/" "ec2-user@${TEST_ENV_NAME}.customers.rapidrents.net:/home/bhmgmt/home/bhmgmt" || return 2
    fi
}

function process_reports() {
    try heroku run ./manage.py import_from_ftp -a "rl-genesis-${TEST_ENV_NAME}" --exit-code
    if [ "${TEST_ENV_NAME}" == "integration" ]
    then
        try python check_reports.py processed_reports "rl-genesis-${TEST_ENV_NAME}" 30 1357 || return 2
    else
        try python check_reports.py sleeping_reports "rl-genesis-${TEST_ENV_NAME}"  45 || return 1
        try heroku run ./manage.py assign_reportsets -a "rl-genesis-${TEST_ENV_NAME}" --exit-code
        try python check_reports.py processed_reports "rl-genesis-${TEST_ENV_NAME}" 45 || return 2
    fi
}

function main() {
    MAINTENANCE=$(heroku maintenance --app "rl-genesis-${TEST_ENV_NAME}")

    if [ "${MAINTENANCE}" == "on" ]
    then
        echo 'Someone else is doing maintenance.  Please only perform one maintenance operation at a time.'
        exit 255
    fi

    virtualenv env
    # shellcheck disable=SC1091
    source env/bin/activate
    pip install --upgrade setuptools
    pip install -r requirements.txt

    scale_dynos_down "rl-genesis-${TEST_ENV_NAME}"
    transfer_reports
    scale_dynos_up "rl-genesis-${TEST_ENV_NAME}"
    try heroku run -a "rl-genesis-${TEST_ENV_NAME}" --exit-code -- ./manage.py init_test_env
    process_reports
    scale_dynos_down "rl-genesis-${TEST_ENV_NAME}"
}

main
