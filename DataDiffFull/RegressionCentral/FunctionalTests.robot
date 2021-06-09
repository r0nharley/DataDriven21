*** Settings ***
Documentation  Rentlytics Functional Tests Suite

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource   ${EXECDIR}/RegressionCentral/DeleteUser.robot
Resource   ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource   ${EXECDIR}/RegressionCentral/SearchTest.robot
Resource   ${EXECDIR}/RegressionCentral/HomepageTest.robot
Resource   ${EXECDIR}/RegressionCentral/FilterTest.robot
Resource   ${EXECDIR}/RegressionCentral/MyPinboardTest.robot
Resource   ${EXECDIR}/RegressionCentral/GLEntriesTest.robot
Resource   ${EXECDIR}/RegressionCentral/HighlightFilterTest.robot
Resource   ${EXECDIR}/RegressionCentral/SharePinboardTest.robot
Resource   ${EXECDIR}/RegressionCentral/ChangePasswordTest.robot
Resource   ${EXECDIR}/RegressionCentral/ExportToPDFTest.robot
Resource   ${EXECDIR}/RegressionCentral/SharePinboardTest.robot
Resource   ${EXECDIR}/RegressionCentral/SummaryDashboardsTest.robot
Resource   ${EXECDIR}/RegressionCentral/DrillInFiltering.robot
Resource   ${EXECDIR}/RegressionCentral/WidgetsLoad.robot
Library  Selenium2Library

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

HomePage Test
    Log to Console  Homepage Test
    HomepageTest.Homepage Test Suite
    
BI Filter Test
    Log To Console  Filter Test
    SignInTest.Functional Sign In
    FilterTest.BIFilterTesting
    [Teardown]  FilterTest.BI Filter Test Teardown

Highlight Filter Test
    Log to Console  Highlight Filtering Test
    SignInTest.Functional Sign In
    HighlightFilterTest.HighlightFilter
    
Summary Leasing Dashboard Test
    Log to Console  Summary Leasing Dashboard Test
    SignInTest.Functional Sign In
    SummaryDashboardsTest.Summary Dashboards Test
    
Drill In Filtering Test
    Log To Console  Drill In Filtering Test
    SignInTest.Functional Sign In
    DrillInFiltering.DrillInFilteringTest

My Pinboard Test
    Log To Console  My Pinboard Test
    SignInTest.Functional Sign In
    MyPinboardTest.My Pinboards Test
    [teardown]  MyPinboardTest.Pinboards Test Teardown

Confirm all Widgets Load Test
    Log To Console  Confirm all Widgets Load Test
    SignInTest.Functional Sign In
    WidgetsLoad.Confirm all Widgets Load

Share Pinboard Test
    Log to Console  Share Pinboard Test
    SharePinboardTest.Share Pinboard Test
    [teardown]  SharePinboardTest.Share Pinboard Test Teardown

Export to PDF Test
    [Setup]  Begin Web Test with HeadlessChrome
    Log to Console  Export to PDF Test
    SignInTest.Functional Sign In
    ExportToPDFTest.Export to PDF Test

Delete User Test
    Log To Console  Delete User Test
    DeleteUser.DeleteUserTest


*** Keywords ***
