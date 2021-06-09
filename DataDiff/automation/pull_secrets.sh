#!/bin/bash -e

HEROKU_TOKEN_PATH=~/.netrc

if [ ! -e $HEROKU_TOKEN_PATH ]; then
  heroku login
fi

pull-secret() {
  ENV_VAR_NAME=$1
  echo "Exporting $ENV_VAR_NAME"
  export $ENV_VAR_NAME=$(heroku config:get $ENV_VAR_NAME -a rl-genesis-staging)
}

pull-secret GITHUB_REPO
pull-secret GIT_BRANCH_NAME
pull-secret GITHUB_USERNAME
pull-secret GITHUB_PASSWORD
pull-secret ROBOT_ADMIN_USERNAME
pull-secret ROBOT_ADMIN_PASSWORD
pull-secret ROBOT_WORKER_CNG_PASSWORD
pull-secret ROBOT_WORKER_CNG_PASSWORD1
pull-secret ROBOT_WORKER_CNG_PASSWORD2
pull-secret ROBOT_WORKER_CNG_PASSWORD_USER
pull-secret ROBOT_WORKER_USERNAME
pull-secret ROBOT_WORKER_USERNAME2
pull-secret ROBOT_WORKER_PASSWORD
pull-secret ROBOT_WORKER_PASSWORD2
pull-secret MAILTRAP_API_TOKEN
pull-secret MAILTRAP_INBOX
