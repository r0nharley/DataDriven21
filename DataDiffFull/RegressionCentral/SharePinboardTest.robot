*** Settings ***
Library  DateTime

Resource   ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource   ${EXECDIR}/RegressionCentral/FilterTest.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/PinboardPage.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/DashboardPage.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/Widget.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/SharedPinboardEmail.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/SharedDashboardEmail.robot


*** Variables ***
${SharedPinboardAtDateTime}
${SharedDashboardName} =  Leasing & Rents - Occupancy & Unit Availability
${SharedDashboard} =  leasing-rents-occupancy-unit-availability
${PinboardName} =  Test Pinboard share-1
${PinboardShareText} =  This is a test pinboard
${DashboardShareText} =  This is a test dashboard


*** Keywords ***
Share Pinboard Test
    Maximize Browser Window
    CommonV.Load Homepage
    SignInTest.Signin In Place Generic  %{ROBOT_WORKER_USERNAME}  %{ROBOT_WORKER_PASSWORD}
    Create Shared Pinboards and Dashboard
    SignInTest.Sign Out
    SignInTest.Signin In Place Generic  %{ROBOT_WORKER_USERNAME2}  %{ROBOT_WORKER_PASSWORD2}
    Verify Shared Dashboad and Pinboard

Share Pinboard Test Teardown
    SignInTest.Sign Out
    SignInTest.Signin In Place Generic  %{ROBOT_WORKER_USERNAME}  %{ROBOT_WORKER_PASSWORD}
    PinboardPage.Delete Pinboards  5

Create Shared Pinboards and Dashboard
    ${SharedPinboardAtDateTime} =  Get Time
    Set Global Variable  ${SharedPinboardAtDateTime}  ${SharedPinboardAtDateTime}
    Create Shared Pinboards
    Create Share Dashboard

Create Shared Pinboards
    PinboardPage.Create Pinboard  ${PinboardName}
    PinboardPage.Verify Share Button is Not Active
    DashboardPage.Navigate to dashboard  ${SharedDashboard}
    DashboardPage.Add Widget to Pinboard  ${PinboardName}  ${DashboardChart1_XPath}
    DashboardPage.Navigate to dashboard details  ${SharedDashboard}
    DashboardPage.Add Widget to Pinboard  ${PinboardName}  ${DashboardDetails_Table1_XPath}
    PinboardPage.Go to Pinboard  ${PinboardName}
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  PinboardPage.Verify Widget displayed  ${ChartInPinboard_XPath}
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  PinboardPage.Verify Widget displayed  ${TableInPinboard_XPath}
    FilterTest.Select Property Group Filter Options
    FilterTest.Save Filter  ${SavedFilterName}
    FilterTest.Verify Filter Options Have Been Selected
    PinboardPage.Verify Share Button is Active
    PinboardPage.Verify Manage Users Button is not Active
    PinboardPage.Share Pinboard with User  %{ROBOT_WORKER_USERNAME2}  ${PinboardShareText}
    PinboardPage.Verify Manage Users Button is Active

Create Share Dashboard
    DashboardPage.Navigate to dashboard  ${SharedDashboard}
    FilterTest.Select Property Group Filter Options  0  1  3  4
    FilterTest.Save Filter  Regression Filter 2
    DashboardPage.Verify Share Button is Active
    DashboardPage.Share Dashboard with User  %{ROBOT_WORKER_USERNAME2}  ${DashboardShareText}

Verify Shared Dashboad and Pinboard
    ${min_datetime} =  Convert Date  ${SharedPinboardAtDateTime}  datetime
    ${max_datetime} =  Get Time
    ${max_datetime} =  Convert Date  ${max_datetime}  datetime
    Verify Shared Pinboards  ${min_datetime}  ${max_datetime}
    Verify Shared Dashboard  ${min_datetime}  ${max_datetime}

Verify Shared Pinboards
    [Arguments]  ${min_datetime}  ${max_datetime}
    ${emails} =  SharedPinboardEmail.Verify Shared Pinboard Email  ${min_datetime}  ${max_datetime}  ${PinboardName}  ${PinboardShareText}
    SharedPinboardEmail.Click on Shared Pinboard Email Pinboard Link  ${emails}  ${PinboardName}
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  PinboardPage.Verify Widget displayed  ${ChartInPinboard_XPath}
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  PinboardPage.Verify Widget displayed  ${TableInPinboard_XPath}
    # filters will not be set until the user uses the email link, then they will persist until the user clears them.
    FilterTest.Verify Filter Options Have Been Selected
    # verify the pinboard via the pinboard menu
    CommonV.Load Page and Wait for Element up to X Times  ${START_URL}  ${DashboardMenuButton_XPath}
    CommonV.Screenshot if Specified
    PinboardPage.Go to Pinboard  ${PinboardName}
    CommonV.Screenshot if Specified
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  PinboardPage.Verify Widget displayed  ${ChartInPinboard_XPath}
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  PinboardPage.Verify Widget displayed  ${TableInPinboard_XPath}

Verify Shared Dashboard
    [Arguments]  ${min_datetime}  ${max_datetime}
    ${emails} =  SharedDashboardEmail.Verify Shared Dashboard Email  ${min_datetime}  ${max_datetime}  ${SharedDashboardName}  ${DashboardShareText}
    SharedDashboardEmail.Click on Shared Dashboard Email Link  ${emails}  ${SharedDashboardName}
    Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  DashboardPage.Verify Shared Dashboard is Displayed
    FilterTest.Verify Filter Options Have Been Selected  4
