*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${START_URL} =  https://secure.rentlytics.com/winterwood
${BROWSER} =  PhantomJS
${USERNAME} =  RegressionTestAdmin@rentlytics.com
${PASSWORD} =  %{PASSWORD}
${BADPASSWORD} =  test

*** Test Cases ***


Rentlytics User Signin
    [Tags]  Signin/Forgot Password Test
    RentVal.Rentlytics User Signin Extended

Rentlytics Winterwood Dashboard KPIs Have Data
    [Tags]  Winterwood Data Capture
    RentVal.Rentlytics Winterwood Executive KPI Has Data
    #RentVal.Rentlytics Winterwood Property Grouping Has Data
    RentVal.Rentlytics Winterwood Finances By Property KPI Has Data
    RentVal.Rentlytics Winterwood Finances By Month Has Data
    RentVal.Rentlytics Winterwood Finance Trends Has Data
    RentVal.Rentlytics Winterwood Finance Utilities Has Data
    RentVal.Rentlytics Winterwood Finance Capex Has Data
    RentVal.Rentlytics Winterwood Operations Occupancy Has Data
    RentVal.Rentlytics Winterwood Operations Delinquency Has Data
    RentVal.Rentlytics Winterwood Operations Rents Has Data
    RentVal.Rentlytics Winterwood Operations Leases Has Data
    RentVal.Rentlytics Winterwood Operations Future Occupancy Has Data
    RentVal.Rentlytics Winterwood Operations Rent per Sq Ft Has Data

#Rentlytics Winterwood Operations Single Property Has Data
#    [Tags]  Winterwood Operations Single Property Has Data?
#    RentVal.Rentlytics User Signin
#    RentVal.Rentlytics Winterwood Operations Single Property Has Data



