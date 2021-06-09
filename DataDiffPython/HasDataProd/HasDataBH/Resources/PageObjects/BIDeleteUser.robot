*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/DeleteUser.robot



*** Keywords ***
BI Delete User Test
    Run Keyword  DeleteUserTest