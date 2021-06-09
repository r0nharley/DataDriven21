*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/ShareTest.robot


*** Keywords ***
BI Share Test
    Run Keyword  CreateUserTest
    Run Keyword  Signin
    Run Keyword  BIShareTesting
    #Run Keyword  DeleteUserTest