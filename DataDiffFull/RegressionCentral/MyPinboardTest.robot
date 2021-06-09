*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/PinboardPage.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/DashboardPage.robot


*** Variables ***
${Dashboard} =  leasing-rents-occupancy-unit-availability


*** Keywords ***
My Pinboards Test
    PinboardPage.Delete Pinboards  ${MaxPinboards}
    Load Homepage
    : FOR   ${INDEX}    IN RANGE    1   ${MaxPinboards}+1
    \   PinboardPage.Create Pinboard  Test Pinboard ${INDEX}
    PinboardPage.Verify that Create Pinboard is no longer displayed
    DashboardPage.Navigate to dashboard  ${Dashboard}
    : FOR   ${INDEX}    IN RANGE    1   ${MaxPinboards}+1
    \   DashboardPage.Add Widget to Pinboard  Test Pinboard ${INDEX}  ${DashboardKPI1_XPath}
    \   DashboardPage.Add Widget to Pinboard  Test Pinboard ${INDEX}  ${DashboardChart1_XPath}
    DashboardPage.Navigate to dashboard details  ${Dashboard}
    : FOR   ${INDEX}    IN RANGE    1   ${MaxPinboards}+1
    \   DashboardPage.Add Widget to Pinboard  Test Pinboard ${INDEX}  ${DashboardDetails_Table1_XPath}
    PinboardPage.Go to Pinboard  Test Pinboard 1
    PinboardPage.Add pinboard description
    PinboardPage.Remove Widget from Pinboard  ${KPIInPinboard_XPath}
    PinboardPage.Remove Widget from Pinboard  ${ChartInPinboard_XPath}
    PinboardPage.Remove Widget from Pinboard  ${TableInPinboard_XPath}
    PinboardPage.Verify Empty Pinboard End
    PinboardPage.Edit pinboard name

# tests the default "My Pinboard" that ever new user assigned to an organization receives
Default My Pinboard Test
    DashboardPage.Navigate to dashboard  ${Dashboard}
    PinboardPage.Go to Pinboard  My Pinboard
    PinboardPage.Verify Empty Pinboard Copy

# removes the "My Pinboard". Otherwise, PinboardsTesting will fail
Default My Pinboard Test Teardown
    Run Keyword If Test Failed  Log To Console  Test Failed, now trying to delete any remaining Pinboards
    PinboardPage.Delete Pinboards  1
    PinboardPage.Check All Pinboards Deleted

Pinboards Test Teardown
    Run Keyword If Test Failed  Log To Console  Test Failed, now trying to delete any remaining Pinboards
    PinboardPage.Delete Pinboards  ${MaxPinboards}
    PinboardPage.Check All Pinboards Deleted
