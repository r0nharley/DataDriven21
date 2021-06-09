*** Settings ***

Documentation  Rentlytics regression test suite

Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/CommonV.robot
Resource  ${EXECDIR}/RegressionCentral/DataExtractors.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${ENVIRONMENT}  %env%
${ORG_SLUG}     %slug%
${ORG_NAME}     %name%
${APP_URL}      %app_url%
${START_URL}    ${APP_URL}/${ORG_SLUG}
${BROWSER}      PhantomJS
${USERNAME}     %{ROBOT_ADMIN_USERNAME}
${PASSWORD}     %{ROBOT_ADMIN_PASSWORD}

# List of sort items
#VARIABLES

*** Test Cases ***

Extract All Data
    SignInTest.Signin
#TEST_CASES
