*** Settings ***

Library  Selenium2Library
Resource  ${EXECDIR}/RegressionCentral/LeaseDataExceptionsTest.robot
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot



*** Keywords ***
BI LeaseDataExcept Test
    Run Keyword  Rentlytics User Signin Extended
    Run Keyword  Lease Data Exceptions Test
