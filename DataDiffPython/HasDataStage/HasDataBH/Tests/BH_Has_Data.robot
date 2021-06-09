*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot
Resource   ${EXECDIR}/RegressionCentral/DeleteUser.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${ENVIRONMENT}          Stage
${ORG_SLUG}             bh-management
${ORG_NAME}             BH
${APP_URL}              https://staging.rentlytics.com
${START_URL}            ${APP_URL}/${ORG_SLUG}
${START_URL_DB_ADMIN}   https://genesis.staging.rentlytics.com
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
#    [Tags]  Change Password Test
#    RentVal.BI Change Password

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

#BI Lease Data Exceptions Test
    #[Tags]  Lease Data Exceptions Test
    #RentVal.BI LeaseDataExcept Test

Rentlytics BH Management Executive KPI Has Data
    [Tags]  BH Management Executive KPI Data Diff
    RentVal.Rentlytics BH Management Executive KPI Has Data

#Rentlytics BH Management Property Grouping Has Data
    #[Tags]  BH Management Property Grouping KPI Data Diff
    #RentVal.Rentlytics BH Management Property Grouping Has Data

Rentlytics BH Management Finances By Property KPI Has Data
    [Tags]  BH Management Finances By Property KPI Data Diff
    RentVal.Rentlytics BH Management Finances By Property KPI Has Data

Rentlytics BH Management Finances By Month Has Data
    [Tags]  BH Management Finances By Month KPI Data Diff
    RentVal.Rentlytics BH Management Finances By Month Has Data

Rentlytics BH Management Finance Trends Has Data
    [Tags]  BH Management Finances Trends KPI Data Diff
    RentVal.Rentlytics BH Management Finance Trends Has Data

Rentlytics BH Management Finance Utilities Has Data
    [Tags]  BH Management Finance Utilities KPI Data Diff
    RentVal.Rentlytics BH Management Finance Utilities Has Data

Rentlytics BH Management Finance Capex Has Data
    [Tags]  BH Management Finance Capex KPI Data Diff
    RentVal.Rentlytics BH Management Finance Capex Has Data

Rentlytics BH Management Operations Single Property Has Data
    [Tags]  BH Management Operations Single Property KPI Data Diff
    RentVal.Rentlytics BH Management Operations Single Property Has Data

Rentlytics BH Management Operations Occupancy Has Data
    [Tags]  BH Management Operations Occupancy KPI Data Diff
    RentVal.Rentlytics BH Management Operations Occupancy Has Data

Rentlytics BH Management Operations Delinquency Has Data
    [Tags]  BH Management Delinquency KPI Data Diff
    RentVal.Rentlytics BH Management Operations Delinquency Has Data

Rentlytics BH Management Operations Rents Has Data
    [Tags]  BH Management Operations Rents KPI Data Diff
    RentVal.Rentlytics BH Management Operations Rents Has Data

Rentlytics BH Management Operations Leases Has Data
    [Tags]  BH Management Operations Leases KPI Data Diff
    RentVal.Rentlytics Operations Leases Has Data

Rentlytics BH Management Operations Future Occupancy Has Data
    [Tags]  BH Management Operations Future Occupancy KPI Data Diff
    RentVal.Rentlytics BH Management Operations Future Occupancy Has Data

Rentlytics BH Management Operations Rent per Sq Ft Has Data
    [Tags]  BH Management Operations Rent per Sq Ft KPI Data Diff
    RentVal.Rentlytics BH Management Operations Rent per Sq Ft Has Data

Rentlytics BH Management Marketing Overview Has Data
    [Tags]  BH Management Marketing Overview KPI Data Diff
    RentVal.Rentlytics BH Management Marketing Overview Has Data

Rentlytics BH Management Marketing Traffic Counts Has Data
    [Tags]  BH Management Marketing Traffic Counts KPI Data Diff
    RentVal.Rentlytics BH Management Marketing Traffic Counts Has Data

Rentlytics BH Management Marketing Conversion Funnel Has Data
    [Tags]  BH Management Marketing Conversion Funnel KPI Data Diff
    RentVal.Rentlytics BH Management Marketing Conversion Funnel Has Data

Rentlytics BH Management Marketing Leasing Results Has Data
    [Tags]  BH Management Marketing Leasing Results KPI Data Diff
    RentVal.Rentlytics BH Management Marketing Leasing Results Has Data

Rentlytics BH Management Cost Analysis Has Data
    [Tags]  BH Management Cost Analysis KPI Data Diff
    RentVal.Rentlytics BH Management Cost Analysis Has Data

Rentlytics BH Management Asset Manager Custom KPI Has Data
    [Tags]  BH Management Asset Manager Custom KPI Data Diff
    RentVal.Rentlytics BH Management Asset Manager Custom KPI Has Data