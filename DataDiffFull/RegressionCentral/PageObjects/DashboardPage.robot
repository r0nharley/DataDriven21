*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/Widget.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot


*** Variables ***
${Dashboard_DropdownMenuToggle_XPath} =  //div[@class="rl-table-header"]//button[@class='btn btn-info dropdown-toggle']
${DashboardKPI1_XPath} =  //div[@id="kpi1"]
${DashboardChart1_XPath} =  //div[@id="chart1"]
${DashboardDetailsTable1_XPath} =  //div[@id="table1"]
${DashboardShareButton_XPath} =  //div[@class="pull-right rl-share-dashboard"]//div[@class="btn btn-primary rl-button"]
${DashboardShareButtonDisabled_XPath} =  //div[@class="pull-right rl-share-dashboard"]//div[@class="btn btn-primary rl-button" and @disabled="disabled"]
${DashboardTopicModal_XPath} =  //div[@class="rl-topic-modal" and @ng-if="isOpen"]
${DashboardShareModalHeading_XPath} =  ${DashboardTopicModal_XPath}//h3[text()="Share Dashboard"]
${DashboardShareModalUserInput_XPath} =  ${DashboardTopicModal_XPath}//input[@id="viewers_value"]
${DashboardShareModalCommentInput_XPath} =  ${DashboardTopicModal_XPath}//textarea
${DashboardShareModalShareBTN_XPath} =  ${DashboardTopicModal_XPath}//div[@class="btn btn-primary pull-right" and text()="Share"]
${DashboardShareWithUserConfirmation_XPath} =  //div[@class="rl-toast-text"]//span[@ng-bind-html="toastMessageHtml" and text()="Dashboard Successfully Shared"]
${DashboardPropertyFilter_XPath} =  //div[contains(@class,'rl-property-filter')]//div[@ng-click='toggleExpandFilter()']
${DashboardTable1_XPath} =  //div[@id="table1"]
${DashboardExportPDFButton_XPath} =  //div[not(@disabled) and span[contains(.,'Export PDF')]]
${DashboardPDFCreatedMessage_XPath} =  //h3[contains(.,'PDF Created')]
${DashboardExportPDFModalOKButton_XPath} =  //a[contains(.,'OK')]


*** Keywords ***

Share Dashboard with User
    [Arguments]  ${username}  ${comment}
    CommonV.Screenshot if Specified
    click element  ${DashboardShareButton_XPath}
    wait until element is visible  ${DashboardShareModalHeading_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    input text  ${DashboardShareModalUserInput_XPath}  ${username}
    CommonV.Screenshot if Specified
    wait until element is visible  ${DashboardTopicModal_XPath}//div[@class="selected-viewers"]//span[@class="user-email"]  ${page_request_timeout}
    CommonV.Screenshot if Specified
    input text  ${DashboardShareModalCommentInput_XPath}  ${comment}
    CommonV.Screenshot if Specified
    click element  ${DashboardShareModalShareBTN_XPath}
    CommonV.Screenshot if Specified
    wait until element is visible  ${DashboardShareWithUserConfirmation_XPath}  ${page_request_timeout}
    CommonV.Screenshot if Specified

Verify Share Button is Active
    CommonV.Screenshot if Specified
    wait until element is not visible  ${DashboardShareButtonDisabled_XPath}  ${page_request_timeout}
    element should be visible   ${DashboardShareButton_XPath}
    element should not be visible   ${DashboardShareButtonDisabled_XPath}

Verify Shared Dashboard is Displayed
    wait until element is visible  ${DashboardTable1_XPath}  ${page_request_timeout}
    wait until element is visible  ${DashboardPropertyFilter_XPath}  ${page_request_timeout}

Navigate to dashboard
    [Arguments]  ${dashboard}
    Load Page and Wait for Element up to X Times  ${START_URL}/bi/${dashboard}/visualization  ${Dashboard_DropdownMenuToggle_XPath}
    CommonPage.Wait Until Loading Bar Is Not Visible

Navigate to dashboard details
    [Arguments]  ${dashboard}
    Load Page and Wait for Element up to X Times  ${START_URL}/bi/${dashboard}/details  ${Dashboard_DropdownMenuToggle_XPath}
    CommonPage.Wait Until Loading Bar Is Not Visible

Add Widget to Pinboard
    [Arguments]  ${pinboard}  ${widget_id}
     Widget.Add Widget to Pinboard  ${pinboard}  ${widget_id}

Export to PDF
    wait until element is visible  ${DashboardExportPDFButton_XPath}  ${page_request_timeout}
    click element  ${DashboardExportPDFButton_XPath}
    Screenshot if Specified
    wait until element is visible  ${DashboardPDFCreatedMessage_XPath}  ${page_request_timeout}
    click element  ${DashboardExportPDFModalOKButton_XPath}
    wait until element is not visible  ${DashboardExportPDFModalOKButton_XPath}  ${page_request_timeout}
    Screenshot if Specified
    ${file}=  CommonV.Download should be done  @{download_folder}
    Should Contain  ${file}  .pdf
    Remove File  ${file}