*** Settings ***
Library  Selenium2Library

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/SignInTest.robot


*** Variables ***
${GLEntriesButton}  //span[contains(.,'GL Account Manager')]
${GLEntriesHeader}  //h3[contains(.,'GL Account Manager')]
${GLMappingDefaultText}  //div[contains(.,'Choose an account from left or right to view or edit a relationship ')]
${GLRightCheveron}  //i[@class='fa fa-chevron-right fa-4x']


*** Keywords ***
GLETest
    CommonV.Load Page and Wait for Element up to X Times  ${OverviewExecutiveDashboard}  ${OverviewExecutiveDashboardMenuHeading}
    Navigate to GL Entries

Navigate to GL Entries
      CommonV.Screenshot if Specified
      wait until element is visible  ${RentUserName}  ${page_request_timeout}
      CommonV.Screenshot if Specified
      Click element  ${RentUserName}
      CommonV.Screenshot if Specified
      wait until element is visible  ${GLEntriesButton}  10
      CommonV.Screenshot if Specified
      click element  ${GLEntriesButton}
      CommonV.Screenshot if Specified
      wait until element is visible  ${GLEntriesHeader}  ${page_request_timeout}
      CommonV.Screenshot if Specified
      wait until element is visible  ${GLMappingDefaultText}  ${page_request_timeout}
      CommonV.Screenshot if Specified
