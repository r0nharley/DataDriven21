*** Settings ***
Library  Selenium2Library

Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/MyPinboardTest.robot
Resource  ${EXECDIR}/RegressionCentral/FilterTest.robot
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot


*** Variables ***

${MyPinboard} =  ${START_URL}/bi/pinboards-my-pinboard/details
${ExeDash} =  ${START_URL}/bi/overview-executive/visualization
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
${ChartInPinboard} =  //div[@id="chart0"]
${TableInPinboard} =  //div[@id="table0"]
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
${PASSWORD} =  %{ROBOT_ADMIN_PASSWORD}
${passwordfield} =  name=password
${emailfield} =  name=email
${rentlyticslogo} =  xpath=//div[contains(@class,'rl-logo pull-left')]
${signinbutton} =  xpath=${signinbuttonxpath}
${usernamemenu} =  //button[contains(.,'RH NewUserTest')]
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
BIShareTesting
    Load Dashboard Share Start
    Verify Empty Pinboard Share
    Load Exe Dash Share
    Add KPI Widget to Pinboard Share
    #Add Chart Widget to Pinboard Share
    #Add Table Widget to to Pinboard Share
    Click Share button
    Enter Colleagues Name
    Enter a Comment
    Click share
    Verify Toast is displayed
    Click Manage Users MP
    Remove Colleage
    Confirm Colleage Delete
    Click Share button 2
    Enter Colleagues Name 2
    Enter a Comment 2
    Click share 2
    Verify Toast is displayed 2
    Log out
    Log in
    Verify Share with me is added to menu
    Click pinboard shared with you
    Verify that the correct pinboard is displayed
    Click leave pinboard
    Log out 2
    Signin 2
    Remove KPI Widget from Pinboard 2




Load Dashboard Share Start
    go to  ${MyPinboard}
    wait until element is visible  ${NoKPI}  30
    capture page screenshot


Verify Empty Pinboard Share
    element should not be visible  ${KPIInPinboard}
    element should not be visible  ${ChartInPinboard}
    element should not be visible  ${TableInPinboard}

Load Exe Dash Share
    go to  ${ExeDash}
    wait until element is visible  ${ExecutiveKPIMenu}  30

Add KPI Widget to Pinboard Share
    click element  ${ExecutiveKPIMenu}
    wait until element is visible  ${ExecutiveKPIAddto}  10
    click element  ${ExecutiveKPIAddto}
    wait until element is visible  ${ToastMessage}  10
    capture page screenshot

#Add Chart Widget to Pinboard Share
    #click element  ${ExecutiveChartMenu}
    #wait until element is visible  ${ExecutiveChartAddto}  10
    #click element  ${ExecutiveChartAddto}
    #wait until element is visible  ${ToastMessage}  10
    #capture page screenshot

#Add Table Widget to to Pinboard Share
    #click element  ${DetailsButton}
    #wait until element is visible  ${ExecutiveTableMenu}  20
    #capture page screenshot
    #click element  ${ExecutiveTableMenu}
    #wait until element is visible  ${executivetableAddTo}  10
    #click element  ${ExecutiveTableAddto}
    #wait until element is visible   ${ToastMessage}  10
    #capture page screenshot

Click Share button
    go to  ${MyPinboard}
    wait until element is visible  ${KPIInPinboard}  20
    wait until element is visible  ${DashboardShareDisabled}  20
    sleep  5
    click element  ${DashboardShareEnabled}
    capture page screenshot
    wait until element is visible  ${sharedashmenu}  20
    capture page screenshot

Enter Colleagues Name
    input text  ${ColleagueNameField}  Regress
    capture page screenshot
    wait until element is visible  ${ColleagueEmail}  10
    capture page screenshot
    mouse over  ${ColleagueEmail}
    capture page screenshot
    click element  ${ColleagueEmail}
    capture page screenshot

Enter a Comment
    input text  ${CommentField}  This is my Regression Test. There are many like it but this one is mine.
    capture page screenshot

Click share
    click element  ${ShareDashboard2}

Verify Toast is displayed
    wait until element is visible  ${ShareToast}  15

Click Manage Users MP
    wait until element is not visible  ${ShareToast}  10
    click element  ${ManageUsers}
    capture page screenshot

Remove Colleage
    click element  ${DeleteColleageShare}
    capture page screenshot

Confirm Colleage Delete
    wait until element is visible  ${AreYouSureUserDelete}  10
    click element  ${AreYouSureUserDelete}
    wait until element is not visible  ${AreYouSureUserDelete}  10
    capture page screenshot

Click Share button 2
    go to  ${MyPinboard}
    wait until element is visible  ${KPIInPinboard}  20
    wait until element is visible  ${DashboardShareDisabled}  20
    sleep  5
    click element  ${DashboardShareEnabled}
    capture page screenshot
    wait until element is visible  ${sharedashmenu}  20
    capture page screenshot

Enter Colleagues Name 2
    input text  ${ColleagueNameField}  Regress
    capture page screenshot
    wait until element is visible  ${ColleagueEmail}  10
    capture page screenshot
    mouse over  ${ColleagueEmail}
    capture page screenshot
    click element  ${ColleagueEmail}
    capture page screenshot

Enter a Comment 2
    input text  ${CommentField}  This is also my Regression Test. There are many like it but this one is mine.
    capture page screenshot

Click share 2
    click element  ${ShareDashboard2}

Verify Toast is displayed 2
    wait until element is visible  ${ShareToast}  15

Log out
    click element  ${usernamemenu}
    wait until element is visible  ${Logoutbtn}  10
    click element  ${Logoutbtn}

Log in
    wait until element is visible  ${emailfield}  60
    Click element  ${emailfield}
    Input Text  ${emailfield}  RegressionTest2@rentlytics.com
    Click element  ${passwordfield}
    Input text  ${passwordfield}  ${PASSWORD}
    Click Button  ${signinbutton}
    wait until element is visible  ${rentlyticslogo}  12
    go to  ${MyPinboard}


Verify Share with me is added to menu
    wait until element is visible  ${MyPinboardMenu}  20
    click element  ${MyPinboardMenu}
    wait until element is visible  ${SharedWithMeMenu}  10


Click pinboard shared with you
    click element  ${SharedWithMeMenu}
    #mouse over  ${SharedpinboardName}
    go to   ${START_URL}/bh-management/bi/shared-with-me-2235/visualization

Verify that the correct pinboard is displayed
    wait until element is visible  ${RHPinboardKPI}  15
    capture page screenshot

Click leave pinboard
    click element  ${LeavePinboardHeader}
    wait until element is visible  ${LeavePinboardButton}  8
    click element  ${LeavePinboardButton}
    wait until element is visible  ${MyPinboardMenu}  15
    wait until element is visible  //div[@class='rl-empty-text']  20
    capture page screenshot


Log out 2
    click element  ${usernamemenu2}
    wait until element is visible  ${Logoutbtn}  10
    click element  ${Logoutbtn}

Signin 2
    wait until element is visible  ${emailfield}  60
    Click element  ${emailfield}
    Input Text  ${emailfield}  ${NEWUSERNAME1}
    Click element  ${passwordfield}
    Input text  ${passwordfield}  ${PASSWORD}
    Click Button  ${signinbutton}
    wait until element is visible  ${rentlyticslogo}  20

Remove KPI Widget from Pinboard 2
    go to  ${MyPinboard}
    wait until element is visible  ${KPIInPinboardMenu}  20
    click element  ${KPIInPinboardMenu}
    wait until element is visible  ${KPIUnpin}  10
    click element  ${KPIUnpin}
    SLEEP  5
    wait until element is not visible  ${KPIInPinboard}  20
    capture page screenshot