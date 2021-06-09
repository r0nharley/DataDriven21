*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${ENVIRONMENT}  Prod
${ORG_SLUG}     livcor
${ORG_NAME}     Livcor
${APP_URL}      https://secure.rentlytics.com
${START_URL}    ${APP_URL}/${ORG_SLUG}
${BROWSER} =  PhantomJS
${USERNAME} =  RegressionTestAdmin@rentlytics.com
${PASSWORD} =  %{PASSWORD}
${BADPASSWORD} =  test

*** Test Cases ***


Rentlytics User Signin
    [Tags]  Signin/Forgot Password Test
    RentVal.Rentlytics User Signin Extended


Rentlytics Livcor Dashboard KPIs Have Data
    [Tags]  Livcor KPI Data Capture
    RentVal.Rentlytics Livcor Executive KPI Has Data
    #RentVal.Rentlytics Livcor Property Grouping Has Data
    RentVal.Rentlytics Livcor Finances By Property KPI Has Data
    RentVal.Rentlytics Livcor Finances By Month Has Data
    RentVal.Rentlytics Livcor Finance Trends Has Data
    RentVal.Rentlytics Livcor Finance Utilities Has Data
    RentVal.Rentlytics Livcor Finance Capex Has Data
    RentVal.Rentlytics Livcor Operations Single Property Has Data
    RentVal.Rentlytics Livcor Operations Occupancy Has Data
    RentVal.Rentlytics Livcor Operations Delinquency Has Data
    RentVal.Rentlytics Livcor Operations Rents Has Data
    RentVal.Rentlytics Operations Leases Has Data
    RentVal.Rentlytics Livcor Operations Future Occupancy Has Data
    RentVal.Rentlytics Livcor Operations Rent per Sq Ft Has Data
    RentVal.Rentlytics Livcor Marketing Overview Has Data
    RentVal.Rentlytics Livcor Marketing Traffic Counts Has Data
    RentVal.Rentlytics Livcor Marketing Conversion Funnel Has Data
    RentVal.Rentlytics Livcor Marketing Leasing Results Has Data
    RentVal.Rentlytics Livcor Cost Analysis Has Data