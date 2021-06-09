*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/CreateUser.robot



*** Keywords ***
BI New User Test
    Run Keyword  CreateUserTest
