*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/SearchTest.robot


*** Keywords ***
BI Search Test
    Run Keyword  User Signin Extended
    Run Keyword  BISearchTesting