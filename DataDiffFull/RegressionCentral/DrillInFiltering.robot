*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot

Library  Selenium2Library
Library  Collections

*** Variables ***



*** Keywords ***
DrillInFilteringTest
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Leasing
    # Chart widget
    Pick Widget To Test By Order  1
    Test Drill In Filtering For Widget
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Leasing
    # Table widget
    Pick Widget To Test By Order  2
    Test Drill In Filtering For Widget
    
Test Drill In Filtering For Widget
    ${Widget_Elements_Count}=  Get Matching Xpath Count  xpath=${Widget_Chart_Rect_XPath}
    Set Test Variable  ${Widget_Elements_Count}  ${Widget_Elements_Count}
    ${Labels}=  Get Widget Labels
    Set Test Variable  ${Labels}  ${Labels}
    
    Click Element  xpath=${Widget_XPath}
    Capture Page Screenshot
    Click The Hamburger Menu
    Hover Over The Drill In Icon and Select Data Point
    Verify Widget Reflected
    Capture Page Screenshot
    Verify BreadCrumbs Reflected
    Click The X/Delete BreadCrumbs And Verify Widget Return To Default

Pick Widget To Test By Order
    [Arguments]  ${Widget_Order}
    ${Widget_XPath}=  Set Variable  (//div[contains(@class, "rl-row") and .//a[@ng-if="option.key === 'drillIns'"]])[${Widget_Order}]
	Set Test Variable  ${Widget_XPath}                     ${Widget_XPath}
	Set Test Variable  ${Hamburger_XPath}                  ${Widget_XPath}//div[contains(@class, "rl-viz-dropdown")]
	Set Test Variable  ${Hamburger_Button_XPath}           ${Hamburger_XPath}//div[contains(@class, "rl-dropdown-menu")]/button[@ng-click="toggleMenu()"]
	Set Test Variable  ${Drill_Into_Data_Point_XPath}      ${Hamburger_XPath}//a[@ng-if="option.key === 'drillIns'"]
	Set Test Variable  ${Data_Point_XPath}                 ${Hamburger_XPath}//div[@class="rl-viz-dropdown-drill-in-submenu"]/div[@class="rl-dropdown-submenu"]/ul/li[not(@class="rl-disabled")][1]
	Set Test Variable  ${BreadCrumbs_XPath}                ${Widget_XPath}//div[contains(@class, "rl-drill-in-breadcrumb")]
	Set Test Variable  ${Button_Close_BreadCrumbs_XPath}   ${BreadCrumbs_XPath}/div[contains(@ng-click, "onCrumbClick")]
	Set Test Variable  ${Widget_Chart_Rect_XPath}          ${Widget_XPath}//div[contains(@class, "rl-chart")]/div[contains(@class, "rl-chart-content")]//*[local-name()='svg']/*[@class="highcharts-axis-labels highcharts-xaxis-labels "]/*[local-name()="text"]/*[local-name()="tspan"] | ${Widget_XPath}//div[contains(@class, "rl-table")]/div[contains(@class, "rl-table-content")]/div[contains(@class, "rl-table-container")]//tr/td[@ng-class="tableCellStyles(cell)"]
	
Click The Hamburger Menu
    Wait Until Element Is Visible  xpath=${Hamburger_XPath}  20
    Click Element  xpath=${Hamburger_Button_XPath}
    
Hover Over The Drill In Icon and Select Data Point
    Click Element  xpath=${Drill_Into_Data_Point_XPath}
    Wait Until Element Is Visible  xpath=${Data_Point_XPath}  20
    Click Element  xpath=${Data_Point_XPath}
    CommonPage.Wait Until Loading Bar Is Not Visible
    
Verify Widget Reflected
    ${New_Widget_Elements_Count}=  Get Matching Xpath Count  xpath=${Widget_Chart_Rect_XPath}
    # If the widget elements is different after apply drill in filter then its normal
    # But if it's equal then we might need to check the labels
    Run Keyword If  ${New_Widget_Elements_Count} == ${Widget_Elements_Count}  Compare Widget Labels
    
Get Widget Labels
    ${Labels}=  Create List
    @{Elements}=  Get Webelements  xpath=${Widget_Chart_Rect_XPath}
    :FOR  ${Element}  IN  @{Elements}
    \    Append To List  ${Labels}  ${Element.text}
    [Return]  ${Labels}
    
Compare Widget Labels
    ${New_Labels}=  Get Widget Labels
    ${New_Labels_String}=  Evaluate  "".join($New_Labels)
    ${Labels_String}=  Evaluate  "".join($Labels)
    Should Not Be Equal As Strings  ${New_Labels_String}  ${Labels_String}
    
Verify BreadCrumbs Reflected
    Wait Until Element Is Visible  xpath=${BreadCrumbs_XPath}  20
    
Click The X/Delete BreadCrumbs And Verify Widget Return To Default
    Click Element  xpath=${Button_Close_BreadCrumbs_XPath}
    CommonPage.Wait Until Loading Bar Is Not Visible
    ${New_Widget_Elements_Count}=  Get Matching Xpath Count  xpath=${Widget_Chart_Rect_XPath}
    Should Be True  ${New_Widget_Elements_Count} == ${Widget_Elements_Count}
    