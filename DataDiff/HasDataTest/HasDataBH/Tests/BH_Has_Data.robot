*** Settings ***

Documentation  Rentlytics regression test suite

Resource   ../../../RegressionCentral/CommonV.robot
Resource   ../Resources/RentVal.robot

Test Setup  Begin Web Test
Test Teardown  End Web Test
#Test Timeout  20

*** Variables ***

${ENVIRONMENT}  Test
${ORG_SLUG}     bh-management
${ORG_NAME}     BH
${APP_URL}      https://rl-chameleon-test.herokuapp.com
${START_URL}    ${APP_URL}/${ORG_SLUG}
${BROWSER}      PhantomJS
${USERNAME}     superuser@rentlytics.com
${PASSWORD}     %{FAKE_USER_PASSWORD}


*** Test Cases ***

Rentlytics User Signin
    [Tags]  Signin/Forgot Password Test
    RentVal.Rentlytics User Signin Extended

BI Search Test
    [Tags]  Search Testing
    RentVal.BI Search Tests

Rentlytics BH Management Executive KPI Has Data
    [Tags]  BH Management Executive KPI Data Diff
    RentVal.Rentlytics BH Management Executive KPI Has Data

#Rentlytics BH Management Operations Single Property Has Data
#    [Tags]  BH Management Operations Single Property Data Diff
#    RentVal.Rentlytics User Signin
#    RentVal.Rentlytics BH Management Operations Single Property Has Data

Rentlytics BH Management Operations Occupancy Has Data
    [Tags]  BH Management Operations Occupancy Data Diff
    RentVal.Rentlytics BH Management Operations Occupancy Has Data

Rentlytics BH Management Operations Rents Has Data
    [Tags]  BH Management Operations Rents Data Diff
    RentVal.Rentlytics BH Management Operations Rents Has Data

#Rentlytics BH Management Operations Leases Has Data
#    [Tags]  BH Management Operations Leases Data Diff
#   RentVal.Rentlytics BH Management Operations Leases Has Data

Rentlytics BH Management Operations Future Occupancy Has Data
    [Tags]  BH Management Operations Future Occupancy Data Diff
    RentVal.Rentlytics BH Management Operations Future Occupancy Has Data

Rentlytics BH Management Operations Rent per Sq Ft Has Data
    [Tags]  BH Management Operations Rent per Sq Ft Data Diff
    RentVal.Rentlytics BH Management Operations Rent per Sq Ft Has Data

# TODO: Restore after figuring out why CURRENT EXPOSURE isn't 7.5
#Rentlytics BH Management Operations Lease Performance Has Data
#    [Tags]  BH Management Operations Lease Performance Data Diff
#    RentVal.Rentlytics BH Management Operations Lease Performance Has Data

Rentlytics BH Management Asset Manager Custom KPI Has Data
    [Tags]  BH Management Asset Manager Custom KPI Data Diff
    RentVal.Rentlytics BH Management Asset Manager Custom KPI Has Data