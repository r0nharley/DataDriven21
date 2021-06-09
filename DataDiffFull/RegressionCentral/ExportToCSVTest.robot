*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/PageObjects/OverviewExecutivePage.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/OverviewExecutiveDetailsPage.robot


*** Keywords ***
ExportToCSV Testing
    OverviewExecutivePage.Navigate
    OverviewExecutivePage.Save as Image
    OverviewExecutivePage.Export to CSV Visualization
    OverviewExecutiveDetailsPage.Navigate
    OverviewExecutiveDetailsPage.Export to CSV Details
