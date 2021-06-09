*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/CommonV.robot


*** Keywords ***
# WIDGETID is an xpath reference to the wiget, which has id's specified. ID is the name of the pinboard.
Add Widget to Pinboard
    [Arguments]  ${pinboard}  ${widget_id}
    CommonV.Screenshot if Specified
    wait until element is visible  ${widget_id}   ${page_request_timeout}
    CommonV.Screenshot if Specified
    click element  ${widget_id}//button[@class='btn btn-info dropdown-toggle']
    CommonV.Screenshot if Specified
    wait until element is visible  ${widget_id}//span[contains(.,'Pinboards')]  ${page_request_timeout}
    CommonV.Screenshot if Specified
    mouse over  ${widget_id}//span[contains(.,'Pinboards')]
    CommonV.Screenshot if Specified
    click element  ${widget_id}//span[contains(.,'Pinboards')]
    CommonV.Screenshot if Specified
    click element  ${widget_id}//span[contains(.,'${pinboard}')]
    CommonV.Screenshot if Specified
    wait until element is visible  //span[contains(.,'Widget added to ${pinboard}!')]  ${page_request_timeout}
    CommonV.Screenshot if Specified

Get Widget Menu Button
    [Arguments]  ${widget_id}
    [Return]  ${widget_id}//button[@ng-click='toggleMenu()']
