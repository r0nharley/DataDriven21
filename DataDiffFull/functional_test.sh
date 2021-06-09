#!/bin/sh
set +x  # needed when using the binded credentials
virtualenv env
source env/bin/activate
pip install --upgrade setuptools
pip install -r requirements.txt

# Test has its own user, different from the one used on Prod and Staging
if [ $RL_ENV == 'Test' ]
then
    export ROBOT_ADMIN_USERNAME=$TEST_ADMIN_USERNAME
    export ROBOT_ADMIN_PASSWORD=$TEST_ADMIN_PASSWORD
else
    export ROBOT_ADMIN_USERNAME=$ADMIN_USERNAME
    export ROBOT_ADMIN_PASSWORD=$ADMIN_PASSWORD
fi

python automation/functional_tests.py -e $RL_ENV -o "$ORGANIZATIONS" -l $LOG_LEVEL

