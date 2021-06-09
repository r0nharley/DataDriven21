*** Settings ***
Documentation  Rentlytics Functional Tests Suite

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource   ${EXECDIR}/RegressionCentral/DeleteUser.robot
Resource   ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource   ${EXECDIR}/RegressionCentral/SearchTest.robot
Resource   ${EXECDIR}/RegressionCentral/FilterTest.robot
Resource   ${EXECDIR}/RegressionCentral/MyPinboardTest.robot
Resource   ${EXECDIR}/RegressionCentral/GLEntriesTest.robot
Resource   ${EXECDIR}/RegressionCentral/HighlightFilterTest.robot
Resource   ${EXECDIR}/RegressionCentral/SharePinboardTest.robot
Resource   ${EXECDIR}/RegressionCentral/ChangePasswordTest.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test


*** Variables ***
${ORG_SLUG}             ${org_slug}
${APP_URL}              ${app_url}
${START_URL}            ${app_url}/${org_slug}
${START_URL_DB_ADMIN}   ${admin_url}
${BROWSER}              PhantomJS
${INCLUDE_SCREENSHOTS}  ${include_screenshots}
${REMOTE_URL} =   %{REMOTE_URL}
${DESIRED_CAPABILITIES} =  %{DESIRED_CAPABILITIES}


*** Test Cases ***
Create User Test
    Log To Console  Create User Test
    CreateUser.CreateUserTest

User Sign In/Out Test
    Log To Console  Sign In/Out and Forgot PW Test
    SignInTest.Signin Extended

BI Search Test
    Log To Console  Search Test
    SignInTest.Functional Sign In
    SearchTest.BISearchTesting

GL Entries Test
    Log to Console  GL Entries Test
    SignInTest.Functional Sign In
    GLEntriesTest.GLETest

BI Filter Test
    Log To Console  Filter Test
    SignInTest.Functional Sign In
    FilterTest.BIFilterTesting
    [Teardown]  FilterTest.BI Filter Test Teardown

Highlight Filter Test
    Log to Console  Highlight Filtering Test
    SignInTest.Functional Sign In
    HighlightFilterTest.HighlightFilter

Delete User Test
    Log To Console  Delete User Test
    DeleteUser.DeleteUserTest


*** Keywords ***
