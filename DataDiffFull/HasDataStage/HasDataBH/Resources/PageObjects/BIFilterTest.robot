*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/FilterTest.robot
Resource  ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource  ${EXECDIR}/RegressionCentral/DeleteUser.robot


*** Keywords ***
BI Filter Test
    Run Keyword  CreateUserTest
    Run Keyword  Signin
    Run Keyword  BIFilterTesting
    Close Browser