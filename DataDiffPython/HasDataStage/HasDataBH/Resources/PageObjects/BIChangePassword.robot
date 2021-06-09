*** Settings ***
Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/ChangePasswordTest.robot
Resource  ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource  ${EXECDIR}/RegressionCentral/DeleteUser.robot


*** Keywords ***
BI Change PW Test
    Run Keyword  BIChangePasswordTesting