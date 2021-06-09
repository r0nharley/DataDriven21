#!/bin/sh
set +x  # needed when using the binded credentials
virtualenv env
source env/bin/activate
pip install --upgrade setuptools
pip install -r requirements.txt

export GITHUB_REPO=$(heroku config:get GITHUB_REPO -a rl-genesis-production)
export GIT_BRANCH_NAME=$SISENSE_BRANCH

# Test and Validation have their own user, different from the one used on Prod and Staging
environments=("Test" "Validation")
if [[ " ${environments[*]} " == *" ${RL_ENV} "* ]]; then
    export ROBOT_ADMIN_USERNAME=$TEST_ADMIN_USERNAME
    export ROBOT_ADMIN_PASSWORD=$TEST_ADMIN_PASSWORD
else
    export ROBOT_ADMIN_USERNAME=$ADMIN_USERNAME
    export ROBOT_ADMIN_PASSWORD=$ADMIN_PASSWORD
fi

python automation/mappings_generator.py -l $LOG_LEVEL -d "$DASHBOARDS_LIST" -t "$TOPICS_LIST" &&
python automation/data_extractors_generator.py -e $RL_ENV -o "$ORGANIZATIONS" -l $LOG_LEVEL &&
python automation/extract_all_data.py -e $RL_ENV -o "$ORGANIZATIONS" -l $LOG_LEVEL
python automation/compare_tests_generator.py --env1 $KNOWN_GOOD --env2 $RL_ENV -l $LOG_LEVEL &&
python automation/compare_all_data.py --env1 $KNOWN_GOOD --env2 $RL_ENV -l $LOG_LEVEL
