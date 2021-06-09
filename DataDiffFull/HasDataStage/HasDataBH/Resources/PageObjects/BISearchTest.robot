*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/SearchTest.robot
Resource  ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource  ${EXECDIR}/RegressionCentral/DeleteUser.robot


*** Keywords ***
BI Search Test
    Run Keyword  CreateUserTest
    Run Keyword  Signin
    Run Keyword  BISearchTesting
    Close Browser