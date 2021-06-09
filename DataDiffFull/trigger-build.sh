#!/usr/bin/env bash

if [ "$1" != "--branch" ]
then
	echo "Usage: ./trigger-build.sh --branch {name-of-robot-framework-branch}"
	exit
fi


ROBOTFRAMEWORK_BRANCH="$2"
PAYLOAD="{'build_parameters': {'RUN_TESTS': '0', 'RUN_DEPLOYMENT': '1', 'ROBOTFRAMEWORK_BRANCH': '${ROBOTFRAMEWORK_BRANCH}'}}"
PAYLOAD=$(echo $PAYLOAD | tr "'" '"')
curl --header "Content-Type: application/json" \
    --data "${PAYLOAD}" \
    --request POST \
    https://circleci.com/api/v1/project/rentlytics/regression-test/tree/master?circle-token="${CIRCLE_TOKEN}"
