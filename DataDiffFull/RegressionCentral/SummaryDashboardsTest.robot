*** Settings ***
Resource  ${EXECDIR}/RegressionCentral/CommonV.robot
Resource  ${EXECDIR}/RegressionCentral/PageObjects/SummaryDashboard.robot

*** Variables ***
${PropertyCount_Summary_XPath}=  //div[contains(.,'1')]
${SidebarFilterCount_Summary_XPath}=  //span[contains(.,'1/')]
${Number_Of_Bars}=  1

*** Keywords ***
Summary Dashboards Test
    Log To Console  Verify Go To Dashboard Links Redirect To The Corresponding Dashboards
    Verify Go To Dashboard Links Redirect To The Corresponding Dashboards
    
    Log To Console  Highlight A Bar Chart Area and Verify The Remain Area Is Greyed Out
    Highlight A Bar Chart Area and Verify The Remain Area Is Greyed Out
    
    Log To Console  Verify The Side Bar Filters Reflects The Highlighted Area
    Verify The Side Bar Filters Reflects The Highlighted Area
    
    Log To Console  Toggle To Slice Filter Style And Verify Selected Data Is Displayed In The Chart
    Toggle To Slice Filter Style And Verify Selected Data Is Displayed In The Chart
    
    Log To Console  Click Reset All Filter Button and Verify Filters Reseted
    Click Reset All Filter Button and Verify Filters Reseted

    Log To Console  Use Sidebar Filters and Verify Widgets Reflect The Filters
    Use Sidebar Filters and Verify Widgets Reflect The Filters
    
Verify Go To Dashboard Links Redirect To The Corresponding Dashboards
    ${Blurbs_XPath}=  SummaryDashboard.Navigate To Leasing & Rents Summary Dashboard And Get Blurds
    ${Blurbs}=  Get Matching Xpath Count  xpath=${Blurbs_XPath}
    : FOR  ${Index}  IN RANGE  1  ${Blurbs}+1
    \    ${Blurb_XPath}=  Set Variable  (${Blurbs_XPath})[${Index}]
    \    SummaryDashboard.Verify Go to Dashboard Link Button  ${Blurb_XPath}

Highlight A Bar Chart Area and Verify The Remain Area Is Greyed Out
    CommonPage.Toggle Filter Style  Highlight
    CommonPage.Wait Until Loading Bar Is Not Visible
    CommonPage.Wait Until All Widgets Are Loaded
    Dashboard.Select Property From Chart  chart3
    Wait Until Element Is Visible  xpath=${PropertyCount_Summary_XPath}  30
    Wait Until Element Is Visible  xpath=${SidebarFilterCount_Summary_XPath}  10
    ${Bars}=  Dashboard.Get Number Of Bars On Chart  chart3
    Set Test Variable  ${Bars_Before_Reset}  ${Bars}
    
Verify The Side Bar Filters Reflects The Highlighted Area
    CommonPage.Verify Sidebar Filter Reflected  ${Number_Of_Bars}
    
Toggle To Slice Filter Style And Verify Selected Data Is Displayed In The Chart
    CommonPage.Toggle Filter Style  Slice
    Capture Page Screenshot
    ${Bars}=  Dashboard.Get Number Of Bars On Chart  chart3
    Should Be Equal  ${Bars}  ${Number_Of_Bars}
    
Click Reset All Filter Button and Verify Filters Reseted
    CommonPage.Reset Sidebar Filters
    # Verify all filters are reset
    CommonPage.Wait Until Loading Bar Is Not Visible
    CommonPage.Wait Until All Widgets Are Loaded
    Capture Page Screenshot
    ${Bars_After_Reset}=  Dashboard.Get Number Of Bars On Chart  chart3
    Should Be True  ${Bars_Before_Reset} == ${Bars_After_Reset}
    
Use Sidebar Filters and Verify Widgets Reflect The Filters
    CommonPage.Select Default Filters
    Capture Page Screenshot
    ${Bars_After_Filter}=  Dashboard.Get Number Of Bars On Chart  chart3
    Should Be True  ${Bars_Before_Reset} != ${Bars_After_Filter}