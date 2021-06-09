*** Settings ***
Library  Selenium2Library
Library  Collections


Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot


*** Variables ***
${Overview_Executive_Dashboard_Url} =  ${START_URL}/bi/overview-executive/visualization
${Property_Filter_Xpath} =  //div[contains(@class,'rl-property-filter')]//div[@ng-click='toggleExpandFilter()']
${Filter_Options_Xpath} =  //li[contains(@class, 'rl-filter-option')]
${Selected_Filter_Xpath} =  //ul[contains(@class, 'rl-selected-options')]
${Selected_Options_Xpath} =  //span[@ng-repeat='op in option.options']
${Filter_OK_Btn_Xpath} =  //div[@ng-click='applyChanges()']
${Saved_Filter_Btn_Xpath} =  //div[@class='rl-saved-filter-button btn btn-sm rl-btn']
${Filter_Name_Field_Xpath} =  //input[@placeholder='Name your new filter']
${Filter_Add_Btn_Xpath} =  //a[@ng-click='createSavedFilter(savedFilterName)']
${Filter_No_Listed_Items} =  //div[@ng-class="noListedItems"]
${Saved_Filter_Name} =  Regression Filter
${Saved_Filter_Xpath} =  //span[contains(.,'${Saved_Filter_Name}')]
${Delete_Filter_Xpath} =  //a[contains(@class,'rl-delete-filter fa fa-trash')]
${Delete_Filter_Confirm_Xpath} =  //div[@ng-click='executeAction(savedFilter)']
${No_Filters_Added_Xpath} =  //p[contains(.,'Your saved filters will appear here!')]

${Table1_Xpath} =  //div[@id='table1']
${Table1_Total_Units_Title_Xpath} =  ${Table1_Xpath}//td[contains(., 'Total Units')]
${Table1_Total_Units_Value_Xpath} =  ${Table1_Xpath}//div[@class="rl-scrollable-table"]//tr[1]//td[1]
${Table1_Page_2_Xpath} =  //div[@class="rl-table-pagination"][1]//a[contains(., '2')]
${Table1_Page_Indicator_Xpath} =  //div[@class="rl-table-pagination"][1]//div[@class="rl-row-indicator"]

${ResetFilters} =  //div[@ng-click='resetFilters()']
${NoFiltersAdded} =  //p[contains(.,'Your saved filters will appear here!')]


*** Keywords ***
Navigate to Overview Executive
    go to  ${Overview_Executive_Dashboard_Url}
    CommonPage.Wait For Page Loading
    wait until element is visible  ${Property_Filter_Xpath}  ${Element_Wait_Time}


Select Property Group Filter Options
    click element  ${Property_Filter_Xpath}
    wait until element is visible   ${Filter_Options_Xpath}   ${Element_Wait_Time}
    @{PropertyGroupFilterOptions} =  Get Webelements  xpath=${Filter_Options_Xpath}
    click element   @{PropertyGroupFilterOptions}[0]
    click element   @{PropertyGroupFilterOptions}[1]
    click element   @{PropertyGroupFilterOptions}[3]


Save Filter
    click element  ${Saved_Filter_Btn_Xpath}
    input text  ${Filter_Name_Field_Xpath}  ${Saved_Filter_Name}
    
    Wait Until Element Is Visible  ${Filter_No_Listed_Items}  ${Element_Wait_Time}
    wait until element is visible  ${Filter_Add_Btn_Xpath}  ${Element_Wait_Time}
    click element  ${Filter_Add_Btn_Xpath}
    
    wait until element is visible  ${Saved_Filter_Xpath}  ${Element_Wait_Time}
    click element  ${Filter_OK_Btn_Xpath}
    Wait For Filter Applied


Verify Filter Options Have Been Selected
    wait until element is visible  ${Selected_Filter_Xpath}  ${Element_Wait_Time}
    ${SelectedCount} =  Get Matching Xpath Count  ${Selected_Options_Xpath}
    Should Be Equal As Integers  ${SelectedCount}  3


Reset All Filters
    wait until element is visible  ${Reset_Filters_Xpath}  ${Element_Wait_Time}
    click element  ${Reset_Filters_Xpath}
    wait until element is not visible  ${Reset_Filters_Xpath}  ${Element_Wait_Time}
    element should not be visible  ${Reset_Filters_Xpath}


Delete Saved Filter
    wait until element is visible  ${Property_Filter_Xpath}  ${Element_Wait_Time}
    click element  ${Property_Filter_Xpath}
    wait until element is visible  ${Saved_Filter_Btn_Xpath}  ${Element_Wait_Time}
    click element  ${Saved_Filter_Btn_Xpath}
    wait until element is visible  ${Saved_Filter_Xpath}  ${Element_Wait_Time}
    mouse over  ${Saved_Filter_Xpath}
    wait until element is visible  ${Delete_Filter_Xpath}  ${Element_Wait_Time}
    click element  ${Delete_Filter_Xpath}
    wait until element is visible  ${Delete_Filter_Confirm_Xpath}  ${Element_Wait_Time}
    click element  ${Delete_Filter_Confirm_Xpath}
    wait until element is visible  ${No_Filters_Added_Xpath}  ${Element_Wait_Time}
    element should not be visible  ${Saved_Filter_Xpath}
    
    
Verify Filter Panel
    Log To Console  "---> Step 1: Apply Filters and verify that the dashboard reflects changes"
    # Apply Filters and verify that the dashboard reflects changes
    ${val_before} =  Go To Page And Get One Val ${Menu_Overview_Xpath} ${Menu_Overview_Executive_Xpath} ${KPI_Val_Xpath}
    ${val_after} =  Apply Filter Properties And One Val 1 ${KPI_Val_Xpath}
    Should Not Be Equal As Strings  ${val_before}  ${val_after} "The data should be reflects changed"
    
    Log To Console  "---> Step 2: Apply Filters and navigate to another dashboard. Verify that the filter is still applied"
    # Apply Filters and navigate to another dashboard. Verify that the filter is still applied
    ${selected_items_before} =  Get Filter Selected Items
    ${selected_items_after} =  Go To Page And Get Filter Selected Items ${Menu_Leasing_Rents_Xpath} ${Menu_Leasing_Rents_Summary_Xpath}
    Lists Should Be Equal  ${selected_items_before}  ${selected_items_after}  "The filter should be still applied"
    
    Log To Console  "---> Step 3: Apply Filters and navigate between visualizations and details. Verify that the filter is still applied"
    # Apply Filters and navigate between visualizations and details. Verify that the filter is still applied
    ${selected_items_before} =  Go To Page And Get Filter Selected Items ${Menu_Overview_Xpath} ${Menu_Overview_Executive_Xpath}
    ${selected_items_after} =  Switch Tab And Get Filter Selected Items ${Feature_Detail_Xpath}
    Lists Should Be Equal  ${selected_items_before}  ${selected_items_after}  "The filter should be still applied"
    
    Log To Console  "---> Step 4: Reset Filters and verify that the dashboard not longer reflects change"
    # Reset Filters and verify that the dashboard not longer reflects change
    Switch To Tab ${Feature_Virtualization_Xpath}
    Reset Filter
    ${val_after} =  Go To Page And Get One Val ${Menu_Overview_Xpath} ${Menu_Overview_Executive_Xpath} ${KPI_Val_Xpath}
    Should Be Equal As Strings  ${val_before}  ${val_after}  "The dashboard data should be not longer reflects changed"
    
    Log To Console  "---> Step 5: Click on a bar chart to filter -- confirm that side bar filter is applied for 1 selection and all widgets update"
    # Click on a bar chart to filter -- confirm that side bar filter is applied for 1 selection and all widgets update
    CommonPage.Click Menu SubItem ${Menu_Xpath} ${Menu_Leasing_Rents_Xpath} ${Menu_Leasing_Rents_Summary_Xpath}
    Click On Bar Chart And Verify Filter
    
    Log To Console  "---> Step 6: Click on a pie chart to filter -- confirm that side bar filter is applied for 1 selection and all widgets update"
    # Click on a pie chart to filter -- confirm that side bar filter is applied for 1 selection and all widgets update
    Reset Filter
    CommonPage.Click Menu SubItem ${Menu_Xpath} ${Menu_Operations_Xpath} ${Menu_Operations_Rents_EDS_Xpath}
    Click On Pie Chart And Verify Filter
    
    Log To Console  "---> Step 7: Single property sidebar filter: Verify that dashboards with a single select property filter "
    # Single property sidebar filter: Verify that dashboards with a single select property filter 
    # have not been changed unless they have updated to be
    Reset Filter
    ${val_before} =  Go To Page And Get One Val ${Menu_Overview_Xpath} ${Menu_Overview_Executive_Xpath} ${KPI_Val_Xpath}
    ${val_after} =  Click Filter Properties And One Val 1 ${KPI_Val_Xpath}
    Should Be Equal As Strings  ${val_before}  ${val_after}  "The widgets' data should not be updated before click on OK button"
    ${val_after} =  Click Filter Ok Button And Get One Val ${KPI_Val_Xpath}
    Should Not Be Equal As Strings  ${val_before}  ${val_after}  "The widgets' data should be updated after click on OK button"
    
    Log To Console  "---> Step 8: Multi property sidebar filter: Verify that a dashboard with a mult select propery filter "
    # Multi property sidebar filter: Verify that a dashboard with a mult select propery filter 
    # have not been changed unless they have been updated to be
    Reset Filter
    ${val_before} =  Go To Page And Get One Val ${Menu_Overview_Xpath} ${Menu_Overview_Executive_Xpath} ${KPI_Val_Xpath}
    ${val_after} =  Click Filter Properties And One Val 3 ${KPI_Val_Xpath}
    Should Be Equal As Strings  ${val_before}  ${val_after}  "The widgets' data should not be updated before click on OK button"
    ${val_after} =  Click Filter Ok Button And Get One Val ${KPI_Val_Xpath}
    Should Not Be Equal As Strings  ${val_before}  ${val_after}  "The widgets' data should be updated after click on OK button"
    
    Log To Console  "---> Step 9: Sort a column on a table"
    # Sort a column on a table
    CommonPage.Load Home Dashboard
    ${val_before} =  Sort Table And Get One Value ${Table1_Total_Units_Title_Xpath} ${Table1_Total_Units_Value_Xpath}
    ${val_after} =  Sort Table And Get One Value ${Table1_Total_Units_Title_Xpath} ${Table1_Total_Units_Value_Xpath}
    Should Not Be Equal As Strings  ${val_before}  ${val_after}  "The table should be sorted as expected"
    
    Log To Console  "---> Step 10: Page through a table"
    # Page through a table
    Table Paging And Get Value
    

Go To Page And Get One Val ${menu_item} ${sub_item} ${val_item}
    CommonPage.Click Menu SubItem ${Menu_Xpath} ${menu_item} ${sub_item}
    Wait For Page Loading
    ${val} =  Get Text  ${val_item}
    [Return]  ${val}
    
    
Click To Expand The Property Filter
    ${items_count} =  Get Matching Xpath Count  xpath=${Filter_Options_Xpath}
    Run keyword if  ${items_count} == 0  click element  ${Property_Filter_Xpath}
    Run keyword if  ${items_count} == 0  wait until element is visible   ${Filter_Options_Xpath}   ${Element_Wait_Time}
    
    
Click Filter Properties And One Val ${property_num} ${val_item}
    Click To Expand The Property Filter
    @{PropertyGroupFilterOptions} =  Get Webelements  xpath=${Filter_Options_Xpath}
    : FOR  ${index}  IN RANGE  1  ${property_num} + 1
    \    click element   @{PropertyGroupFilterOptions}[${index}]
    ${val} =  Get Text  ${val_item}
    [Return]  ${val}
    
    
Click Filter Ok Button And Get One Val ${val_item}
    click element  ${Filter_OK_Btn_Xpath}
    Wait For Filter Applied
    ${val} =  Get Text  ${val_item}
    [Return]  ${val}
    
    
Apply Filter Properties And One Val ${property_num} ${val_item}
    Click Filter Properties And One Val ${property_num} ${val_item}
    ${val} =  Click Filter Ok Button And Get One Val ${val_item}
    [Return]  ${val}
    
    
Go To Page And Get Filter Selected Items ${menu_item} ${sub_item}
    CommonPage.Click Menu SubItem ${Menu_Xpath} ${menu_item} ${sub_item}
    Wait For Page Loading
    ${val} =  Get Filter Selected Items
    [Return]  ${val}
    
Switch To Tab ${tab_xpath}
    click element  ${tab_xpath}
    Wait For Page Loading
    
Switch Tab And Get Filter Selected Items ${tab_xpath}
    Switch To Tab ${tab_xpath}
    ${val} =  Get Filter Selected Items
    [Return]  ${val}
    
Reset Filter
    wait until element is visible  ${Reset_Filters_Xpath}  ${Element_Wait_Time}
    click element  ${Reset_Filters_Xpath}
    Wait For Filter Applied
        
Table Paging And Get Value
    ${val_before} =  Get Text  ${Table1_Page_Indicator_Xpath}
    Click element  ${Table1_Page_2_Xpath}
    Wait For Filter Applied
    ${val_after} =  Get Text  ${Table1_Page_Indicator_Xpath}
    Should Not Be Equal As Strings  ${val_before}  ${val_after}  "The table's paging should be worked as expected"
    
    
Sort Table And Get One Value ${table_col} ${val_item}
    Log To Console  Sort Table And Get One Value
    wait until element is visible  ${table_col}  ${Element_Wait_Time}
    click element  ${table_col}
    Wait For Filter Applied
    ${val} =  Get Text  ${val_item}
    [Return]  ${val}


Click On Bar Chart And Verify Filter
    Log To Console  Click On Bar Chart And Verify Filter
    # Click on a bar chart to filter -- confirm that side bar filter is applied for 1 selection and all widgets update
    click element  ${Bar_Chart_Rect_XPath}
    Wait For Filter Applied
    ${filter_items_count} =  Get Matching Xpath Count  xpath=${Selected_Options_Xpath}
    ${filter_val} =  Get Text  ${Selected_Options_Xpath}[1]
    ${bar_chart_x_axis_count} =  Get Matching Xpath Count  xpath=${Bar_Chart_Xaxis_Unit_Xpath}
    ${bar_chart_x_axis_val} =  Get Text  ${Bar_Chart_Xaxis_Unit_Xpath}[1]
    Should Be True  ${filter_items_count} == ${bar_chart_x_axis_count} == 1  "The filter items should applied 1 selection item"
    Should Be Equal As Strings  ${filter_val}  ${bar_chart_x_axis_val}  "The widgets's data should be updated by 1 item [${filter_val}]"


Click On Pie Chart And Verify Filter
    Log To Console  Click On Pie Chart And Verify Filter
    ${val_before} =  Get Text  ${KPI_Val_Xpath}
    Execute Javascript  ${Scrolling_Script}
    Wait For Filter Applied
    click element  ${Pie_Chart_Path_XPath}
    Wait For Filter Applied
    ${filter_items_count} =  Get Matching Xpath Count  xpath=${Filter_Selected_Li_Xpath}
    ${val_after} =  Get Text  ${KPI_Val_Xpath}
    Should Be True  ${filter_items_count} == 1  "The filter items should applied 1 selection item"
    Should Not Be Equal As Strings  ${val_before}  ${val_after}  "The widgets's data should be updated by 1 item"


Get Filter Selected Items
    ${items_count} =  Get Matching Xpath Count  xpath=${Filter_Selected_Xpath}//span
    ${names} =  Create List
    : FOR  ${index}  IN RANGE  1  ${items_count}+1
    \    ${name}=  Get Text  ${Filter_Selected_Xpath}//span[${index}]
    \    Append To List  ${names}  ${name}
    [Return]  ${names}

Confirm No Saved Filters
    CommonV.Screenshot if Specified
    wait until element is visible  ${NoFiltersAdded}  ${page_request_timeout}
    CommonV.Screenshot if Specified
