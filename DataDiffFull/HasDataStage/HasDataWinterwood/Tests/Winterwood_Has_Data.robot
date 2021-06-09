*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${START_URL} =  https://staging.rentlytics.com/winterwood
${BROWSER} =  PhantomJS
${USERNAME} =  RegressionTestAdmin@rentlytics.com
${PASSWORD} =  %{PASSWORD}
${BADPASSWORD} =  test

*** Test Cases ***


Rentlytics User Signin
    [Tags]  Signin/Forgot Password Test
    RentVal.Rentlytics User Signin Extended

Rentlytics Winterwood Executive KPI Has Data
    [Tags]  Winterwood Executive KPI Data Diff
    RentVal.Rentlytics Winterwood Executive KPI Has Data

#Rentlytics Winterwood Property Grouping Has Data
#    [Tags]  Winterwood Property Grouping KPI Data Diff
#    RentVal.Rentlytics User Signin
#    RentVal.Rentlytics Winterwood Property Grouping Has Data

Rentlytics Winterwood Finances By Property KPI Has Data
    [Tags]  Winterwood Finances By Property KPI Data Diff
    RentVal.Rentlytics Winterwood Finances By Property KPI Has Data

Rentlytics Winterwood Finances By Month Has Data
    [Tags]  Winterwood Finances By Month KPI Data Diff
    RentVal.Rentlytics Winterwood Finances By Month Has Data

Rentlytics Winterwood Finance Trends Has Data
    [Tags]  Winterwood Finances Trends KPI Data Diff
    RentVal.Rentlytics Winterwood Finance Trends Has Data

Rentlytics Winterwood Finance Utilities Has Data
    [Tags]  Winterwood Finance Utilities KPI Data Diff
    RentVal.Rentlytics Winterwood Finance Utilities Has Data

Rentlytics Winterwood Finance Capex Has Data
    [Tags]  Winterwood Finance Capex KPI Data Diff
    RentVal.Rentlytics Winterwood Finance Capex Has Data

#Rentlytics Winterwood Operations Single Property Has Data
#    [Tags]  Winterwood Operations Single Property KPI Data Diff
#    RentVal.Rentlytics User Signin
#    RentVal.Rentlytics Winterwood Operations Single Property Has Data

Rentlytics Winterwood Operations Occupancy Has Data
    [Tags]  Winterwood Operations Occupancy KPI Data Diff
    RentVal.Rentlytics Winterwood Operations Occupancy Has Data

Rentlytics Winterwood Operations Delinquency Has Data
    [Tags]  Winterwood Delinquency KPI Data Diff
    RentVal.Rentlytics Winterwood Operations Delinquency Has Data

Rentlytics Winterwood Operations Rents Has Data
    [Tags]  Winterwood Operations Rents KPI Data Diff
    RentVal.Rentlytics Winterwood Operations Rents Has Data

Rentlytics Winterwood Operations Leases Has Data
    [Tags]  Winterwood Operations Leases KPI Data Diff
    RentVal.Rentlytics Winterwood Operations Leases Has Data

Rentlytics Winterwood Operations Future Occupancy Has Data
    [Tags]  Winterwood Operations Future Occupancy KPI Data Diff
    RentVal.Rentlytics Winterwood Operations Future Occupancy Has Data

Rentlytics Winterwood Operations Rent per Sq Ft Has Data
    [Tags]  Winterwood Operations Rent per Sq Ft KPI Data Diff
    RentVal.Rentlytics Winterwood Operations Rent per Sq Ft Has Data
