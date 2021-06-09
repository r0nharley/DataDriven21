*** Settings ***
Library  Selenium2Library

Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/MyPinboardTest.robot
Resource  ${EXECDIR}/RegressionCentral/FilterTest.robot
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot


*** Variables ***

${MyPinboard} =  ${START_URL}/bh-management/bi/pinboards-my-pinboard/details
${ExeDash} =  ${START_URL}/bh-management/bi/overview-executive/visualization
${ExecutiveKPIMenu} =  //div[@id="kpi1"]//button[@class='btn btn-info dropdown-toggle']
${ExecutiveKPIAddto} =  //div[@id="kpi1"]//span[contains(.,'Add to My Pinboard')]
${ExecutiveKPIViewDetails} =  //div[@id="kpi0"]//a[contains(.,'View Details')]
${ExecutiveChartMenu} =  //div[@id="chart01"]//button[@class='btn btn-info dropdown-toggle']
${ExecutiveChartAddto} =  //div[@id="chart01"]//span[contains(.,'Add to My Pinboard')]
${ToastMessage} =  //span[@ng-bind-html='toastMessageHtml']
${DetailsButton} =  //span[contains(.,'Details')]
${ExecutiveTableMenu} =  //div[@id="table01"]//button[@class='btn btn-info dropdown-toggle']
${ExecutiveTableAddto} =  //div[@id="table01"]//a[contains(.,'Add to My Pinboard')]
${KPIInPinboard} =  //div[@id="kpi0"]
${ChartInPinboard} =  //div[@id="chart00"]
${TableInPinboard} =  //div[@id="table00"]
${DashboardShareEnabled} =  //span[contains(.,'Share')]
${DashboardShareDisabled} =  //div[@ng-disabled='!isReady || disableButton']
${ManageUsers} =  //span[contains(.,'Manage Users')]
${ColleagueNameField} =  //input[contains(@id,'viewers_value')]
${ColleagueEmail} =  //div[@ng-bind-html='result.description']
${CommentField} =  //textarea[@ng-model='formData.comments']
${DeleteColleageShare} =  //div[@class='fa fa-close']
${ShareCancel} =  //div[contains(.,'Cancel')]
${ShareToast} =  //div[contains(.,'Dashboard Successfully Shared')]
${AreYouSureUserDelete} =  //div[@ng-click='removeMember(userPendingDelete)']
${AreYouSureUserCancel} =  //div[@ng-click='removeMemberCancel()']
${LeavePinboardHeader} =  //span[contains(.,'Leave Pinboard')]
${LeavePinboardButton} =  //div[contains(@ng-click,'leavePinboard()')]
${SharedWithMeMenu} =  //button[contains(.,'Shared With Me')]
${MyPinboardMenu} =  //span[contains(.,'My Pinboard')]
${SharedpinboardName} =  //a[@ng-click='onOptionClick(item)']
${PropertyGroups} =  //span[contains(.,'Property Groups')]
${AVP} =  //li[contains(@title,'Santos, Mike')]
${USERNAME} =  RegressionTest2@rentlytics.com
${PASSWORD} =  %{PASSWORD}
${passwordfield} =  name=password
${emailfield} =  name=email
${rentlyticslogo} =  xpath=//div[contains(@class,'rl-logo pull-left')]
${signinbutton} =  xpath=${signinbuttonxpath}
${usernamemenu} =  //button[contains(.,'Ron Harley')]
${usernamemenu2} =  //button[contains(.,'Regression RonHarley')]
${RHPinboardKPI} =  //div[@id='kpi0']
${Logoutbtn} =  //a[contains(.,'Log Out')]
${sharedashmenu} =  //h3[contains(.,'Share Dashboard')]
${ShareDashboard2} =  //div[@ng-click='shareDashboard()']
${DeleteCompleteIndication} =  //div[contains(.,'Manage UsersUsers are added by sharing your pinboard.')]
${KPIInPinboardMenu} =  //div[@id="kpi0"]//button[@class='btn btn-info dropdown-toggle']
${KPIUnpin} =  //div[@id="kpi0"]//a[contains(.,'Unpin')]
${NoKPI} =  //div[contains(.,'  Add KPI')]



*** Keywords ***
BICoreDashboardShare
    Load Exe Dashboard
    Add Filters
    Click Share
    Add a Collegue
    Add a Comment
    Click Share
    Verify Toast Message is displayed
    Log out user 1
    Log in user 2
    Navigate to the Exe Dashboard
    Verify that filters are applied


Load Exe Dashboard
    go to ${ExeDash}

Add Filters
    click element  ${PropertyGroups}
    capture page screenshot
    click element  ${AVP}
    capture page screenshot
    click element  ${Client}
    capture page screenshot

Click Share
    click element  ${DashboardShareEnabled}

Add a Collegue
    input text  ${ColleagueNameField}  Regress
    capture page screenshot
    wait until element is visible  ${ColleagueEmail}  10
    capture page screenshot
    mouse over  ${ColleagueEmail}
    capture page screenshot
    click element  ${ColleagueEmail}
    capture page screenshot

Add a Comment
    input text  ${CommentField}  This is my Regression Test. There are many like it but this one is mine.
    capture page screenshot

Click Share
    click element  ${ShareDashboard2}

Verify Toast Message is displayed
    wait until element is visible  ${ShareToast}  15

Log out user 1
    click element  ${usernamemenu}
    wait until element is visible  ${Logoutbtn}  10
    click element  ${Logoutbtn}

Log in user 2
    wait until element is visible  ${emailfield}  60
    Click element  ${emailfield}
    Input Text  ${emailfield}  RegressionTest2@rentlytics.com
    Click element  ${passwordfield}
    Input text  ${passwordfield}  ${PASSWORD}
    Click Button  ${signinbutton}
    wait until element is visible  ${rentlyticslogo}  12
    go to  ${MyPinboard}



Navigate to the Exe Dashboard
    go to ${ExeDash}


Verify that filters are applied
