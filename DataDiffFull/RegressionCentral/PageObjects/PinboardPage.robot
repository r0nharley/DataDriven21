*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/Widget.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot


*** Variables ***
${KPIInPinboard_XPath} =  //div[@id="kpi0"]
${ChartInPinboard_XPath} =  //div[@id="chart0"]
${TableInPinboard_XPath} =  //div[@id="table0"]
${CreatePinboardNameField_XPath} =  //input[@id='pinboard-title-input']
${DashboardMenuButton_XPath} =  //div[@class="rl-menu-btn"]
${MaxPinboards} =  5
${EmptyDescription_XPath} =  //div[@class='rl-is-empty rl-display']
${DescriptionDefaultTxt_XPath} =  //div[contains(.,'Add Pinboard Description')]
${DescriptionInput_XPath} =  //div[@class='ql-editor']
${PinboardSaveBtn_XPath} =  //span[contains(.,'Save')]
${PinboardEditBtn_XPath} =  //span[contains(.,'Edit')]
${DescriptionConfirmation_XPath} =   //p[contains(.,'this is my description ')]
${CreateButton_XPath} =  //a[contains(.,'Create')]
${CreatePinboardModalHeading_XPath} =  //h3[contains(.,'Create Pinboard')]
${CreatePinboardButton_XPath} =  //a[contains(.,'+ Create Pinboard')]
${PinboardMenuItem_XPath} =  //button[contains(.,'Pinboards')]
${PinboardDrowdownItems_XPath} =  //div[@class="rl-dashboard-menu"]//div[@class="rl-topics-menu"]//ul[@class="menu"]//li//a[not(contains(.,'+ Create Pinboard'))]
${EmptyPinboardMessage_XPath} =  //span[contains(.,'Customize your Pinboard')]
${ModalDialog_XPath} =  //div[@class="modal-dialog"]
${DashboardMenuTopicNav_XPath} =  //div[@class="pull-left rl-topic-nav"]
${PinboardShareButtonDisabled_XPath} =  //div[@class="pull-right rl-share-dashboard"]//div[@class="btn btn-primary rl-button" and @disabled="disabled"]
${PinboardShareButton_XPath} =  //div[@class="pull-right rl-share-dashboard"]//div[@class="btn btn-primary rl-button"]
${PinboardManageUserBTN_XPath} =  //div[span = "Manage Viewers"]
${PinboardManageUserInActiveBTN_XPath} =  //div[@class="pull-right rl-manage-users ng-hide"]//div[@class="btn rl-button"]
${PinboardTopicModal_XPath} =  //div[@class="rl-topic-modal" and @ng-if="isOpen"]
${PinboardShareModalHeading_XPath} =  ${PinboardTopicModal_XPath}//h3[text()="Share Dashboard"]
${PinboardShareModalUserInput_XPath} =  ${PinboardTopicModal_XPath}//input[@id="viewers_value"]
${PinboardShareModalCommentInput_XPath} =  ${PinboardTopicModal_XPath}//textarea
${PinboardShareModalShareBTN_XPath} =  ${PinboardTopicModal_XPath}//div[@class="btn btn-primary pull-right" and text()="Share"]
${PinboardShareModalCancelBTN_XPath} =  ${PinboardTopicModal_XPath}//div[text()="Cancel"]
${PinboardShareWithUserConfirmation_XPath} =  //div[@class="rl-toast-text"]//span[@ng-bind-html="toastMessageHtml" and text()="Dashboard Successfully Shared"]


*** Keywords ***
Create Pinboard
    [Arguments]  ${Name}
    CommonV.Check Page Ready  ${DashboardMenuButton_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    Hover over Pinboards
    Click Create Pinboard
    Verify Create Pinboard modal is displayed
    Add pinboard ${Name}
    Click Create
    Wait Until Page Does Not Contain Element  ${CreatePinboardModalHeading_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    Verify Empty Pinboard Copy

Add pinboard ${NAME}
    [Tags]  Add pinboard
    CommonV.Screenshot if Specified
    input text  ${CreatePinboardNameField_XPath}  ${NAME}
    CommonV.Screenshot if Specified

Add Pinboard Description
    CommonV.Screenshot if Specified
    click element  ${PinboardEditBtn_XPath}
    CommonV.Screenshot if Specified
    wait until element is visible  ${EmptyDescription_XPath}  ${quick_action_timeout}
    CommonV.Screenshot if Specified
    click element  ${EmptyDescription_XPath}
    CommonV.Screenshot if Specified
    input text   ${DescriptionInput_XPath}    this is my description
    CommonV.Screenshot if Specified
    click element  ${PinboardSaveBtn_XPath}
    CommonV.Screenshot if Specified
    Verify Pinboard Edit Mode Off
    wait until element is visible  ${DescriptionConfirmation_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified

Click Create
    [Tags]  Click Create
    CommonV.Screenshot if Specified
    click element  ${CreateButton_XPath}
    CommonV.Screenshot if Specified

Click Create Pinboard
    [Tags]  Click Create Pinboard
    CommonV.Screenshot if Specified
    element should be visible   ${CreatePinboardButton_XPath}
    click element  ${CreatePinboardButton_XPath}

Check All Pinboards Deleted
    CommonV.Load Homepage
    CommonV.Check Page Ready  ${DashboardMenuButton_XPath}  ${page_request_timeout}
    element should not be visible  //a[@title='EDIT']
    Hover over Pinboards
    element should be visible  //a[contains(.,'+ Create Pinboard')]
    CommonV.Screenshot if Specified


Delete Pinboards
    [Arguments]  ${max_pinboards}
    Log To Console  Deleting Pinboards
    : FOR   ${INDEX}    IN RANGE    1   ${max_pinboards}+1
    \   CommonV.Load Homepage
    \   CommonV.Check Page Ready  ${DashboardMenuButton_XPath}  ${page_request_timeout}
    \   Hover over Pinboards
    \   ${has_pinboards}=  Run Keyword And Return Status  Element Should Be Visible  ${PinboardDrowdownItems_XPath}
    \   Exit For Loop If  '${has_pinboards}' == 'False'
    \   click element  ${PinboardDrowdownItems_XPath}[last()]
    \   CommonV.Check Page Ready  ${DashboardMenuButton_XPath}  ${page_request_timeout}
    \   CommonV.Screenshot if Specified
    \   click element  ${PinboardEditBtn_XPath}
    \   CommonV.Screenshot if Specified
    \   click element  //a[@class='rl-delete fa fa-trash']
    \   CommonV.Screenshot if Specified
    \   wait until element is visible  //div[contains(.,'Are you sure you want to delete this Pinboard?')]  ${quick_action_timeout}
    \   CommonV.Screenshot if Specified
    \   click element  //span[contains(.,'Delete')]
    \   CommonV.Screenshot if Specified
    \   CommonV.Check Page Ready  ${DashboardMenuButton_XPath}  ${page_request_timeout}
    \   CommonV.Screenshot if Specified

Edit pinboard name
    CommonV.Screenshot if Specified
    click element  ${PinboardEditBtn_XPath}
    CommonV.Screenshot if Specified
    wait until element is visible  //a[@class='rl-edit fa fa-pencil']  ${page_request_timeout}
    CommonV.Screenshot if Specified
    click element  //a[@class='rl-edit fa fa-pencil']
    CommonV.Screenshot if Specified
    input text  //input[@id='dashboard-title-input']  EDIT
    CommonV.Screenshot if Specified
    click element  //a[@class='rl-edit fa fa-pencil']
    CommonV.Screenshot if Specified
    wait until element is visible  ${PinboardSaveBtn_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    click element  ${PinboardSaveBtn_XPath}
    CommonV.Screenshot if Specified
    Verify Pinboard Edit Mode Off

Go to Pinboard
    [Arguments]  ${PinboardName}
    Hover over Pinboards
    click element  //div[@class="rl-dashboard-menu"]//div[@class="rl-topics-menu"]//ul[@class="menu"]//li//a[@title="${PinboardName}"]
    CommonV.Run Keyword and Reload Page and Rerun on Fail  False  ${DashboardMenuButton_XPath}  False  CommonPage.Wait Until Loading Bar Is Not Visible
    CommonV.Screenshot if Specified

Hover over Pinboards
    [Tags]  Hover over Pinboards
    CommonV.Screenshot if Specified
    click element  ${DashboardMenuButton_XPath}
    CommonV.Screenshot if Specified
    click element  ${PinboardMenuItem_XPath}
    CommonV.Screenshot if Specified

Remove Widget from Pinboard
    [Arguments]  ${WIDGET}
    CommonV.Screenshot if Specified
    ${widget_menu_button} =  Widget.Get Widget Menu Button  ${WIDGET}
    mouse over  ${widget_menu_button}
    CommonV.Screenshot if Specified
    click element  ${widget_menu_button}
    CommonV.Screenshot if Specified
    click element  ${WIDGET}//a[contains(.,'Pinboards')]
    CommonV.Screenshot if Specified
    click element  ${WIDGET}//span[contains(.,'1')]
    CommonV.Screenshot if Specified
    Wait Until Page Does Not Contain Element  ${WIDGET}  ${page_request_timeout}
    CommonV.Screenshot if Specified

Verify Create Pinboard modal is displayed
    [Tags]  Verify Create Pinboard modal is displayed
    CommonV.Screenshot if Specified
    element should be visible  ${CreatePinboardModalHeading_XPath}

##
# make sure whatever calls this, ensures the page has already loaded or transitioned out of the previous action. Also,
# depending on where you were previously, a similar matching span may already be on page from other actions.
Verify Empty Pinboard Copy
    [Tags]  Verify Empty Pinboard Copy
    CommonV.Screenshot if Specified
    CommonV.Run Keyword and Reload Page and Rerun on Fail  False  ${EmptyPinboardMessage_XPath}  False  wait until element is visible  ${EmptyPinboardMessage_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified

Verify that Create Pinboard is no longer displayed
    CommonV.Check Page Ready  ${DashboardMenuButton_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    Hover over Pinboards
    element should not be visible   //a[contains(.,'+ Create Pinboard')]

Verify Widgets displayed
    CommonV.Screenshot if Specified
    wait until element is visible  ${KPIInPinboard_XPath}     ${page_request_timeout}
    CommonV.Screenshot if Specified
    wait until element is visible  ${ChartInPinboard_XPath}   ${page_request_timeout}
    CommonV.Screenshot if Specified
    wait until element is visible  ${TableInPinboard_XPath}   ${page_request_timeout}
    CommonV.Screenshot if Specified

Verify Widget displayed
    [Arguments]  ${Widget_XPath}
    CommonV.Screenshot if Specified
    wait until element is visible  ${Widget_XPath}  ${page_request_timeout}

Verify Empty Pinboard End
    CommonV.Screenshot if Specified
    wait until element is visible  //span[contains(.,'Customize your Pinboard')]  ${page_request_timeout}
    CommonV.Screenshot if Specified
    element should not be visible  ${KPIInPinboard_XPath}
    element should not be visible  ${ChartInPinboard_XPath}
    element should not be visible  ${TableInPinboard_XPath}

Verify Pinboard Edit Mode Off
    CommonV.Screenshot if Specified
    wait until element is visible  ${PinboardEditBtn_XPath}  ${page_request_timeout}
    wait until element is visible  ${DashboardMenuTopicNav_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified


Verify Share Button is Not Active
    CommonV.Screenshot if Specified
    element should be visible   ${PinboardShareButtonDisabled_XPath}

Verify Share Button is Active
    CommonV.Screenshot if Specified
    wait until element is not visible  ${PinboardShareButtonDisabled_XPath}  ${page_request_timeout}
    element should be visible   ${PinboardShareButton_XPath}
    element should not be visible   ${PinboardShareButtonDisabled_XPath}

Verify Manage Users Button is not Active
    click element  ${PinboardShareButton_XPath}
    wait until element is visible  ${PinboardShareModalHeading_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    element should not be visible  ${PinboardManageUserBTN_XPath}
    click element  ${PinboardShareModalCancelBTN_XPath}

Verify Manage Users Button is Active
    click element  ${PinboardShareButton_XPath}
    wait until element is visible  ${PinboardShareModalHeading_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    element should be visible  ${PinboardManageUserBTN_XPath}
    click element  ${PinboardShareModalCancelBTN_XPath}

Share Pinboard with User
    [Arguments]  ${username}  ${comment}
    CommonV.Screenshot if Specified
    click element  ${PinboardShareButton_XPath}
    wait until element is visible  ${PinboardShareModalHeading_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    input text  ${PinboardShareModalUserInput_XPath}  ${username}
    CommonV.Screenshot if Specified
    wait until element is visible  ${PinboardTopicModal_XPath}//div[@class="selected-viewers"]//span[@class="user-email"]  ${page_request_timeout}
    CommonV.Screenshot if Specified
    input text  ${PinboardShareModalCommentInput_XPath}  ${comment}
    CommonV.Screenshot if Specified
    click element  ${PinboardShareModalShareBTN_XPath}
    CommonV.Screenshot if Specified
    wait until element is visible  ${PinboardShareWithUserConfirmation_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified

