*** Settings ***
Library  Selenium2Library

Resource   ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/HomePage.robot


*** Variables ***


*** Keywords ***
Homepage Test Suite
  CommonPage.Load Home Dashboard
  SignInTest.Signin
  CommonPage.Wait For Page Loading
  HomePage.Verify On Homepage
  HomePage.Verify Homepage Widgets Are Present
  HomePage.Verify Filtering
  HomePage.Verify No More Than Five Announcements
  HomePage.Verify Most Visited Dashboards
  HomePage.Verify Support Links Are Present