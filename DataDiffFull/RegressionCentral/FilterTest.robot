*** Settings ***
Library  Selenium2Library


Resource   ${EXECDIR}/RegressionCentral/PageObjects/FilterPanel.robot


*** Keywords ***
BIFilterTesting
    CommonPage.Wait For Page Loading
    FilterPanel.Verify Filter Panel
    FilterPanel.Navigate to Overview Executive
    FilterPanel.Select Property Group Filter Options
    FilterPanel.Save Filter
    FilterPanel.Verify Filter Options Have Been Selected
    

BI Filter Test Teardown
    FilterPanel.Reset All Filters
    FilterPanel.Delete Saved Filter
    FilterPanel.Confirm No Saved Filters
