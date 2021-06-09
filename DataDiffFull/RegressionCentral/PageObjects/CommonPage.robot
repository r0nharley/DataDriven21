*** Settings ***


*** Variables ***
${Home_Dashboard_Url} =  ${START_URL}/bi/

${Element_Wait_Time} =  120
${Start_Waiting_Times} =  20
${End_Waiting_Times} =  60
${Overlay_Loading_Xpath} =  //div[@class="rl-overlay"]


### Menu Items ###
${Menu_Btn_XPath}                      //div[contains(@class, "rl-menu-btn")]
${Topic_Menu_XPath}                    //div[contains(@class, "rl-topics-menu")]/ul[@class="menu"]
${Feature_Menu_XPath}                  //ul[contains(@class, "rl-feature-toggle")]

${Menu_Xpath} =  //div[@ng-click="toggleMenu()"]
${Menu_Overview_Xpath} =  //div[@class='dropdown']/button[contains(., 'Overview')]
${Menu_Home_Xpath} =  //div[@class='dropdown']/button[contains(., 'Home')]
${Menu_Overview_Executive_Xpath} =  //a[contains(., 'Executive')]

${Menu_Leasing_Rents_Xpath} =  //div[@class='dropdown']/button[contains(., 'Leasing & Rents')]
${Menu_Leasing_Rents_Summary_Xpath} =  //a[contains(., 'Summary')]

${Menu_Operations_Xpath} =  //div[@class='dropdown']/button[contains(., 'Operations')]
${Menu_Operations_Rents_EDS_Xpath} =  //a[contains(., 'Rents')]


### Page Tabs ###
${Feature_Virtualization_Xpath}=  //ul[@ng-show="displayToggleButtons()"]/li[1]
${Feature_Detail_Xpath}=  //ul[@ng-show="displayToggleButtons()"]/li[2]


### Page Items ###
${KPI_Val_Xpath} =  //div[@class="rl-primary-kpi-value"][1]


### Table Items ###
${Scrolling_Script} =  $($('#standard-all-operations-rents-viz_rents div.rl-canvas')[0]).scrollTop($($('#standard-all-operations-rents-viz_rents div.rl-canvas div.rl-column')[0]).height());
${Loading_Indicator_XPaths}=  //div[contains(@class, "rl-overlay")]/div[contains(@class, "rl-loader")]


### Chart Items ###
${Bar_Chart_Rect_XPath} =  //div[@id="chart1"]//*[name()="svg"]/*[@class="highcharts-series-group"]/*[name()="g"][1]/*[name()="rect"][5]
${Bar_Chart_Xaxis_Unit_Xpath} =  //div[@id="chart1"]//*[contains(@class, "highcharts-xaxis-labels")]//*[name()="tspan"]
${Pie_Chart_Path_XPath} =  //span[@class="rl-pie-data-labels rl-pie-slice-sm"][1]


### Filter Items ###
${Reset_Filters_Xpath} =  //div[@ng-click='resetFilters()']
${Filter_Selected_Xpath} =  //li[@class="rl-selected-custom-option"]
${Filter_Selected_Li_Xpath}=  //li[@class="rl-selected-option"]
${Filter_Expand_Script}=  $("#property .rl-collapsed-sections").click();
${Filter_Option_Text_Script}=  return $("#property .rl-filter-option")[0].innerText;
${Filter_Option_Click_Script}=  $("#property .rl-filter-option")[0].click();
${Filter_Ok_Click_Script}=  $('.rl-apply-buttons .btn')[0].click();

${Widgets_XPath}=  //div[contains(@class, "rl-viz") and @ng-repeat]/*[contains(@class, "rl-table") or contains(@class, "rl-chart") or contains(@class, "rl-kpi")]
${Widget_Content_XPath}=  //*[contains(@class, "rl-table-content") or contains(@class, "rl-chart-content") or contains(@class, "rl-kpi-content") or contains(@class, "rl-no-data")]
${Alert_XPath}=    //div[@ng-show="alert" and contains(@class, "rl-alert")]/div[contains(@class, "rl-alert-container")]

# Filters
${Filter_Style_Menu_XPath}             //div[@class="rl-sidebar"]//div[@class="rl-filter-style"]/ul
${Reset_Filter_Btn_XPath}              //div[@class="rl-sidebar"]//div[contains(@class, "rl-reset-button") and @ng-if="enableResetButton"]
${Sidebar_Filter_XPath}                //div[@class="rl-sidebar"]//div[@should-expand-filter]
${Property_Group_Filter_XPath}         //div[contains(@class,'rl-property-groups-filter')]//div[@ng-click='toggleExpandFilter()']
${Property_Filter_XPath}               //div[contains(@class,'rl-property-filter')]//div[@ng-click='toggleExpandFilter()']
${Filter_Option_XPath}                 //li[contains(@class, 'rl-filter-option')]
${Save_Filter_Btn_XPath}               //div[@ng-click='applyChanges()']

*** Keywords ***
Load Home Dashboard
    go to  ${Home_Dashboard_Url}   
    
Click Menu SubItem ${menu} ${item} ${sub_item}
    click element  ${menu}
    wait until element is visible  ${item}  ${Element_Wait_Time}
    click element  ${item}
    wait until element is visible  ${sub_item}  ${Element_Wait_Time}
    click element  ${sub_item}
    Wait For Page Loading
    
Wait For Page Loading
    Wait Until Loading Bar Is Not Visible
    Wait Until All Widgets Are Loaded
    
    
Wait Until Loading Bar Is Not Visible
	Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${Alert_XPath}  ${Element_Wait_Time}
	Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${Loading_Indicator_XPaths}  ${Element_Wait_Time}
	
Wait Until Loading Bar Is Visible
    Wait Until Page Contains Element  ${Loading_Indicator_XPaths}  20

Wait For Filter Applied
    #In case the same data is loaded
    Run Keyword And Ignore Error  Wait Until Element Is Visible  ${Loading_Indicator_XPaths}  30
    Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${Loading_Indicator_XPaths}  ${Element_Wait_Time}
	
# Wait Until All Widgets Are Loaded
Wait Until All Widgets Are Loaded
    ${widget_count}=  Get Matching Xpath Count  ${Widgets_XPath}
    :FOR  ${index}  IN RANGE  1  ${widget_count} + 1
    \    Run Keyword And Ignore Error  Wait Until Element Is Visible  xpath=(${Widgets_XPath})[${index}]${Widget_Content_XPath}  ${Element_Wait_Time}


Navigate to Dashboard using Header Buttons
    [Documentation]  Navigate to topics, ex. Leasing and Rents: Occupancy & Unit Availability
    [Arguments]  ${Category_Name}  ${Topic_Name}
    Wait Until Loading Bar Is Not Visible
    
    Element Should Be Visible  ${Menu_Btn_XPath}
    Click Element  ${Menu_Btn_XPath}
    
    # Click Category
    ${Category_Menu_Btn_XPath}=  Set Variable  //div[contains(@class, "rl-menu")]/div[@class="dropdown"]/button[contains(@class, "rl-category") and contains(., "${Category_Name}")]
    Wait Until Element Is Visible  xpath=${Category_Menu_Btn_XPath}
    Element Should Be Visible  xpath=${Category_Menu_Btn_XPath}
    Click Element  xpath=${Category_Menu_Btn_XPath}
    
    # Click Topic
    ${Topic_Menu_Item_XPath}=  Set Variable  ${Topic_Menu_XPath}/li/a[contains(., "${Topic_Name}")]
    Wait Until Element Is Visible  xpath=${Topic_Menu_Item_XPath}
    Element Should Be Visible  xpath=${Topic_Menu_Item_XPath}
    Click Element  xpath=${Topic_Menu_Item_XPath}
    
    Wait Until Loading Bar Is Not Visible

Open Dashboard Feature
    [Documentation]  Open feature for topic. (Visualization) or (Details)
    [Arguments]  ${Feature_Name}
    Wait Until Element Is Visible  xpath=${Feature_Menu_XPath}
    Element Should Be Visible  xpath=${Feature_Menu_XPath}
    ${Feature_Menu_Item_XPath}=  Set Variable  ${Feature_Menu_XPath}/li[.//span[contains(., "${Feature_Name}")]]
    
    Wait Until Element Is Visible  xpath=${Feature_Menu_Item_XPath}
    Element Should Be Visible  xpath=${Feature_Menu_Item_XPath}
    Click Element  xpath=${Feature_Menu_Item_XPath}
    
    Wait Until Loading Bar Is Not Visible
    
# Filters
Toggle Filter Style
    [Arguments]  ${Filter_Style}
    Element Should Be Visible  xpath=${Filter_Style_Menu_XPath}/li[@ng-click="select(option)" and ./span[contains(., "${Filter_Style}")]]
    Click Element  xpath=${Filter_Style_Menu_XPath}/li[@ng-click="select(option)" and ./span[contains(., "${Filter_Style}")]]
    Run Keyword And Ignore Error  Wait Until Loading Bar Is Visible
    Wait Until Loading Bar Is Not Visible
    
Reset Sidebar Filters
    Element Should Be Visible  xpath=${Reset_Filter_Btn_XPath}
    Click Element  xpath=${Reset_Filter_Btn_XPath}
    Wait Until Element Is Visible  xpath=${Loading_Indicator_XPaths}
    Wait Until Loading Bar Is Not Visible
    
Verify Sidebar Filter Reflected
    [Documentation]  When sidebar filter reflected then inside the sidebar will contain an element with a number of filter that we using
    [Arguments]  ${Number_Of_Filter}
    Element Should Be Visible  xpath=${Sidebar_Filter_XPath}//span[contains(@class, "rl-filter-option-count")]/span[contains(., "${Number_Of_Filter}/")]
    
Select Default Filters
    # Select Property Group
    Click Element  ${Property_Group_Filter_XPath}
    Wait Until Element Is Visible   ${Filter_Option_XPath}   60
    @{Property_Group_Filter_Options}  Get Webelements  xpath=${Filter_Option_XPath}
    Click Element  @{Property_Group_Filter_Options}[0]
    Click Element  ${Save_Filter_Btn_XPath}
    Wait Until Loading Bar Is Visible
    Wait Until Loading Bar Is Not Visible
    
    Click Element  ${Property_Filter_XPath}
    Wait Until Element Is Visible   ${Filter_Option_XPath}   60
    @{Property_Filter_Options}  Get Webelements  xpath=${Filter_Option_XPath}
    Click Element  @{Property_Filter_Options}[0]
    Click Element  @{Property_Filter_Options}[1]
    Click Element  @{Property_Filter_Options}[3]
    Click Element  ${Save_Filter_Btn_XPath}
    Wait Until Loading Bar Is Visible
    Wait Until Loading Bar Is Not Visible
