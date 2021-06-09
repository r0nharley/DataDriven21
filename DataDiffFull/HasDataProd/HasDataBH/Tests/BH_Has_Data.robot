*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot
Resource   ${EXECDIR}/RegressionCentral/DeleteUser.robot

Test Setup  Begin Web Test
Test Teardown   End Web Test

#Test Timeout  20
#Test Teardown  run keyword if any tests failed  DeleteUserTest
*** Variables ***

${ENVIRONMENT}          Prod
${ORG_SLUG}             bh-management
${ORG_NAME}             BH
${APP_URL}              https://secure.rentlytics.com
${START_URL}            ${APP_URL}/${ORG_SLUG}
${START_URL_DB_ADMIN}   https://genesis.production.rentlytics.com
${BROWSER}              PhantomJS
${USERNAME}             RegressionTestAdmin@rentlytics.com
${NEWUSERNAME1}         RegressionTestWorker@rentlytics.com
${PASSWORD}             %{PASSWORD}
${BADPASSWORD}          test
${CHANGEPASSWORD1}      %{CHANGEPASSWORD1}
${CHANGEPASSWORD2}      %{CHANGEPASSWORD2}
${DeleteUserTeardown}   DeleteUserTest

*** Test Cases ***


#BI Create User
    #[Tags]  Create User in Django
    #RentVal.BI Create User

#BI Delete User
    #[Tags]  Delete User in Django
    #RentVal.BI Delete User

Extended User Signin Test
    [Tags]  Signin/Forgot Password Test
    RentVal.Rentlytics User Signin Extended

#BI Change Password
    #[Tags]  Change Password Test
    #RentVal.BI Change Password

BI Search Test
    [Tags]  Search Testing
    RentVal.BI Search Tests
    [teardown]  ${DeleteUserTeardown}

BI Filter Test
    [Tags]  Filter Testing
    RentVal.BI Filter Test
    [teardown]  ${DeleteUserTeardown}

My Pinboard Test
    [Tags]  My Pinboards Test
    RentVal.My Pinboard Test
    [teardown]  ${DeleteUserTeardown}

#My Pinboard Share Test
    #[Tags]  My Pinboards Share Test
    #RentVal.BI Share Test
    #[teardown]  ${DeleteUserTeardown}

Rentlytics BH Management Dashboard KPIs Have Data
    [Tags]  BH KPI Data Capture
    RentVal.Rentlytics BH Management Executive KPI Has Data
    #RentVal.Rentlytics BH Management Property Grouping Has Data
    RentVal.Rentlytics BH Management Finances By Property KPI Has Data
    RentVal.Rentlytics BH Management Finances By Month Has Data
    RentVal.Rentlytics BH Management Finance Trends Has Data
    RentVal.Rentlytics BH Management Finance Utilities Has Data
    RentVal.Rentlytics BH Management Finance Capex Has Data
    RentVal.Rentlytics BH Management Operations Single Property Has Data
    RentVal.Rentlytics BH Management Operations Occupancy Has Data
    RentVal.Rentlytics BH Management Operations Delinquency Has Data
    RentVal.Rentlytics BH Management Operations Rents Has Data
    RentVal.Rentlytics Operations Leases Has Data
    RentVal.Rentlytics BH Management Operations Future Occupancy Has Data
    RentVal.Rentlytics BH Management Operations Rent per Sq Ft Has Data
    RentVal.Rentlytics BH Management Marketing Overview Has Data
    RentVal.Rentlytics BH Management Marketing Traffic Counts Has Data
    RentVal.Rentlytics BH Management Marketing Conversion Funnel Has Data
    RentVal.Rentlytics BH Management Marketing Leasing Results Has Data
    RentVal.Rentlytics BH Management Cost Analysis Has Data
    RentVal.Rentlytics BH Management Asset Manager Custom KPI Has Data
