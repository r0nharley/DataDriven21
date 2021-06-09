*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${ENVIRONMENT}  Stage
${ORG_SLUG}     livcor
${ORG_NAME}     Livcor
${APP_URL}      https://staging.rentlytics.com
${START_URL}    ${APP_URL}/${ORG_SLUG}
${BROWSER}      PhantomJS
${USERNAME}     RegressionTestAdmin@rentlytics.com
${PASSWORD}     %{PASSWORD}
${BADPASSWORD}  test

*** Test Cases ***


Rentlytics User Signin
    [Tags]  Signin/Forgot Password Test
    RentVal.Rentlytics User Signin Extended


Rentlytics Livcor Executive KPI Has Data
    [Tags]  Livcor Executive KPI Data Diff
    RentVal.Rentlytics Livcor Executive KPI Has Data


#Rentlytics Livcor Property Grouping Has Data
    #[Tags]  Livcor Property Grouping KPI Data Diff
    #RentVal.Rentlytics Livcor Property Grouping Has Data

Rentlytics Livcor Finances By Property KPI Has Data
    [Tags]  Livcor Finances By Property KPI Data Diff
    RentVal.Rentlytics Livcor Finances By Property KPI Has Data

Rentlytics Livcor Finances By Month Has Data
    [Tags]  Livcor Finances By Month KPI Data Diff
    RentVal.Rentlytics Livcor Finances By Month Has Data

Rentlytics Livcor Finance Trends Has Data
    [Tags]  Livcor Finances Trends KPI Data Diff
    RentVal.Rentlytics Livcor Finance Trends Has Data

Rentlytics Livcor Finance Utilities Has Data
    [Tags]  Livcor Finance Utilities KPI Data Diff
    RentVal.Rentlytics Livcor Finance Utilities Has Data

Rentlytics Livcor Finance Capex Has Data
    [Tags]  Livcor Finance Capex KPI Data Diff
    RentVal.Rentlytics Livcor Finance Capex Has Data

Rentlytics Livcor Operations Single Property Has Data
    [Tags]  Livcor Operations Single Property KPI Data Diff
    RentVal.Rentlytics Livcor Operations Single Property Has Data

Rentlytics Livcor Operations Occupancy Has Data
    [Tags]  Livcor Operations Occupancy KPI Data Diff
    RentVal.Rentlytics Livcor Operations Occupancy Has Data

Rentlytics Livcor Operations Delinquency Has Data
    [Tags]  Livcor Operations Delinquency KPI Data Diff
    RentVal.Rentlytics Livcor Operations Delinquency Has Data

Rentlytics Livcor Operations Rents Has Data
    [Tags]  Livcor Operations Rents KPI Data Diff
    RentVal.Rentlytics Livcor Operations Rents Has Data

Rentlytics Livcor Operations Leases Has Data
    [Tags]  Livcor Operations Leases KPI Data Diff
    RentVal.Rentlytics Operations Leases Has Data

Rentlytics Livcor Operations Future Occupancy Has Data
    [Tags]  Livcor Operations Future Occupancy KPI Data Diff
    RentVal.Rentlytics Livcor Operations Future Occupancy Has Data

Rentlytics Livcor Operations Rent per Sq Ft Has Data
    [Tags]  Livcor Operations Rent per Sq Ft KPI Data Diff
    RentVal.Rentlytics Livcor Operations Rent per Sq Ft Has Data

Rentlytics Livcor Marketing Overview Has Data
    [Tags]  Livcor Marketing Overview KPI Data Diff
    RentVal.Rentlytics Livcor Marketing Overview Has Data

Rentlytics Livcor Marketing Traffic Counts Has Data
    [Tags]  Livcor Marketing Traffic Counts KPI Data Diff
    RentVal.Rentlytics Livcor Marketing Traffic Counts Has Data

Rentlytics Livcor Marketing Conversion Funnel Has Data
    [Tags]  Livcor Marketing Conversion Funnel KPI Data Diff
    RentVal.Rentlytics Livcor Marketing Conversion Funnel Has Data

Rentlytics Livcor Marketing Leasing Results Has Data
    [Tags]  Livcor Marketing Leasing Results KPI Data Diff
    RentVal.Rentlytics Livcor Marketing Leasing Results Has Data

Rentlytics Livcor Cost Analysis Has Data
    [Tags]  Livcor Cost Analysis KPI Data Diff
    RentVal.Rentlytics Livcor Cost Analysis Has Data