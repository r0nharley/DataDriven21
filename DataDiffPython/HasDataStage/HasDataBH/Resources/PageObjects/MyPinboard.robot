*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/MyPinboardTest.robot
Resource  ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource  ${EXECDIR}/RegressionCentral/DeleteUser.robot



*** Keywords ***
My Pinboard Test
    Run Keyword  CreateUserTest
    Run Keyword  Signin
    Run Keyword  PinboardsTesting