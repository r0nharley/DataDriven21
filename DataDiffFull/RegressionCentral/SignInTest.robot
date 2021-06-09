*** Settings ***
Library  Selenium2Library

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot


*** Variables ***
${rentlyticslogo} =  xpath=//div[contains(@class,'rl-logo pull-left')]
${invalidcred} =  xpath=//div[@class='alert alert-warning']
${noemailorpass} =  xpath=//div[@class='alert alert-warning']
${invalidpassword} =  name=password
${signinbuttonxpath} =  //button[@ng-click='submitForm()']
${signinbutton} =  xpath=${signinbuttonxpath}
${passwordfield} =  name=password
${emailfield} =  name=email
${invalidpassword} =  ThisIsSoWrong!!
${forgotpassword} =  //div[contains(@class,'rl-toggle-link pull-left')]
${resetpasswordheader} =  //h3[contains(.,'reset password')]
${passwordresetfield} =  //input[@placeholder='Email Address']
${passwordresetrequirement} =  //div[@ng-if='hasWarning']
${sendresetemail} =  //button[contains(.,'Send Reset Email')]
${resetemailconfirm} =  //div[@class='alert alert-success']
${backtologinlink} =  //div[@class='rl-toggle-link pull-left']
${loginscreen} =  //h3[contains(.,'sign in & start to explore')]
${RentUserName} =  //button[contains(.,'RegressionTest Worker')]
${AppSignoutBTN} =  //span[contains(.,'Sign Out')]
${SignInPageLogo} =  //div[@class='rl-logo']
${LoadingContainer} =  //div[@class='rl-loading-container']
${LoadingOverlay} =  //div[@class='rl-overlay']
${LoadingGlobalAlert} =  //div[@class='rl-global-alert' and @ng-if='loadingOrFailure']
${UserIQModal} =  //div[@id='_uiq_ftBody']
${UserIQDismiss} =  //button[@id='_uiq_ft_bt1']
${UserMenu_XPath} =  //div[@id="userMenu"]//button[@class="btn btn-info dropdown-toggle"]


*** Keywords ***
Functional Sign In
    Maximize Browser Window
    CommonV.Load Homepage
    Signin In Place Generic  %{ROBOT_WORKER_USERNAME}  %{ROBOT_WORKER_PASSWORD}

Logout Generic
    [Arguments]  ${UserName}
    Wait until element is visible  //button[contains(.,'${UserName}')]  ${page_request_timeout}
    Click element  //button[contains(.,'${UserName}')]
    Wait until element is visible  ${AppSignoutBTN}  10
    Click element  ${AppSignoutBTN}
    Wait until element is visible  ${SignInPageLogo}

Sign Out
    Click element  ${UserMenu_XPath}
    Wait until element is visible  ${AppSignoutBTN}  10
    Click element  ${AppSignoutBTN}
    Wait until element is visible  ${SignInPageLogo}

Signin
    Maximize Browser Window
    CommonV.Load Homepage
    Signin In Place

Signin In Place
    Signin In Place Generic  %{ROBOT_ADMIN_USERNAME}  %{ROBOT_ADMIN_PASSWORD}

Signin In Place Generic
    [Arguments]  ${USERNAME}  ${PASSWORD}
    Maximize Browser Window
    wait until element is visible  ${emailfield}  ${page_request_timeout}
    Click element  ${emailfield}
    Input Text  ${emailfield}  ${USERNAME}
    Click element  ${passwordfield}
    Input Password  ${passwordfield}  ${PASSWORD}
    Click Button  ${signinbutton}

    ##
    # 20 seconds isn't always enough in staging for the response to come back
    # before the robot test errors, so extend it to 60 secs to give it more time.
    wait until element is visible  ${rentlyticslogo}  ${page_request_timeout}

Signin Extended
    CommonV.Load Homepage
    Maximize Browser Window
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  ${signinbuttonxpath}  1
    Click Button  ${signinbutton}
    element should be visible  ${noemailorpass}
    Click element  ${emailfield}
    Input Text  ${emailfield}  %{ROBOT_WORKER_USERNAME}
    Click element  ${passwordfield}
    Input password  ${invalidpassword}  ${invalidpassword}
    element should be visible  ${invalidcred}
    Click element  ${forgotpassword}
    element should be visible  ${resetpasswordheader}
    Click element  ${passwordresetfield}
    Input password  ${passwordresetfield}  ${invalidpassword}
    Click element  ${sendresetemail}
    element should be visible  ${passwordresetrequirement}
    Click element  ${passwordresetfield}
    Input password  ${passwordresetfield}  %{ROBOT_WORKER_USERNAME}
    Click element  ${sendresetemail}
    wait until element is visible  ${resetemailconfirm}  10
    Click element  ${backtologinlink}
    wait until element is visible  ${loginscreen}  5
    Click element  ${emailfield}
    Input Text  ${emailfield}  %{ROBOT_WORKER_USERNAME}
    Click element  ${passwordfield}
    Input password  ${passwordfield}  %{ROBOT_WORKER_PASSWORD}
    Click Button  ${signinbutton}
    wait until element is visible  ${rentlyticslogo}  30
    Wait until element is visible  ${RentUserName}  60
    Click element  ${RentUserName}
    Wait until element is visible  ${AppSignoutBTN}  10
    Click element  ${AppSignoutBTN}
    Wait until element is visible  ${SignInPageLogo}

Signin Generic
    [Arguments]  ${URL}  ${USERNAME}  ${PASSWORD}
    go to  ${URL}
    Signin In Place Generic  ${USERNAME}  ${PASSWORD}

Signin to Rentlytics BI
    [Arguments]  ${START_URL}  ${Username}  ${Password}
    Signin Generic  ${START_URL}  ${Username}  ${Password}

Signout of Rentlytics BI
    [Arguments]  ${START_URL}  ${Username}
    Logout Generic  ${Username}

Dismiss UserIQ Announcement
    ${UIQDisplay}=  Run Keyword And Return Status  UserIQAnnouncement
    Run Keyword if  ${UIQDisplay}==True   click element  ${UserIQDismiss}

UserIQAnnouncement
    element should be visible   ${UserIQDismiss}