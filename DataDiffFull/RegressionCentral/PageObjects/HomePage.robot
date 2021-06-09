*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot


*** Variables ***
${Element_Wait_Time} =  60
${Homepage_Category_Name} =  Home
${Pinboard_Title_PostFix} =  - HomePage Widgets

${Announcment_XPath} =  //div[@class="rl-blurb"]
${Article_XPath} =  //div[@class="rl-article"]
${Category_Label_Xpath} =  //span[@class="rl-category-label"]
${Homepage_Category_Label_XPath} =  //span[@class="rl-category-label" and text()="${Homepage_Category_Name}"]
${Most_Visited_Dashboards_XPath} =  //div[@class="rl-most-visited-dashboards"]//div[@class="rl-dashboard-name"]
${Reset_All_Filters_Button_XPath} =  //div[@class="rl-reset-button btn btn-xs"]
${Topic_Label_XPath} =  //span[@class="rl-selected-name"]

${Kpi_XPath} =  //div[@id="kpi1"]
${Kpi_Title_XPath} =  ${Kpi_XPath}//div[@class="rl-title"]
${Kpi_Content_XPath} =  ${Kpi_XPath}/div[@class="rl-kpi-content"]

${Chart_XPath} =  //div[@id="chart1"]
${Chart_Title_XPath} =  ${Chart_XPath}//div[@class="rl-title"]
${Chart_Content_XPath} =  ${Chart_XPath}/div[@class="rl-chart-content"]
${Chart_Series_XPath} =  ${Chart_Content_XPath}//*[name()="svg"]/*[name()="g" and @class="highcharts-series-group"]/*[name()="g" and contains(@class, "highcharts-series-0")]
${Chart_Columns_XPath} =  ${Chart_Series_XPath}/*[name()="rect"]
${Chart_Highlighted_Columns_XPath} =  ${Chart_Series_XPath}/*[name()="rect" and @fill!="#cccccc"]

${Table_XPath} =  //div[@id="table1"]
${Table_Title_XPath} =  ${Table_XPath}//div[@class="rl-title"]
${Table_Content_Xpath} =  ${Table_XPath}/div[@class="rl-table-content"]
${Table_Rows_XPath} =  //div[@id="table1"]/div[@class="rl-table-content"]//div[@class="rl-scrollable-table"]//tr

${Support_Links_XPath} =  //div[@class="rl-support-links"]
${Support_Links_Column_One_Links_XPath} =  ${Support_Links_XPath}//div[@class="rl-column-one"]//a
${Support_Links_Column_Two_Links_XPath} =  ${Support_Links_XPath}//div[@class="rl-column-two"]//a

${Pinboard_Kpi_XPath} =  //div[@id="kpi0"]
${Pinboard_Kpi_Title_XPath} =  ${Pinboard_Kpi_XPath}//div[@class="rl-title"]
${Pinboard_Chart_XPath} =  //div[@id="chart0"]
${Pinboard_Chart_Title_XPath} =  ${Pinboard_Chart_XPath}//div[@class="rl-title"]
${Pinboard_Table_XPath} =  //div[@id="table0"]
${Pinboard_Table_Title_XPath} =  ${Pinboard_Table_XPath}//div[@class="rl-title"]

${Pinboard_Nonexistent_Kpi_XPath} =  //div[@id="kpi1"]
${Pinboard_Nonexistent_Chart_XPath} =  //div[@id="chart1"]
${Pinboard_Nonexistent_Table_XPath} =  //div[@id="table1"]
${Table1_Data_Col_Xpath} =  //div[@id="table1"]//div[@class="rl-left-container"]//div[@class="rl-frozen-columns"]//td[@class="rl-data"]


*** Keywords ***
Verify On Homepage
  Log to Console  + Verify On Homepage
  Wait Until Element Is Visible  xpath=${Homepage_Category_Label_XPath}  ${Element_Wait_Time}
  Element Should Not Be Visible  xpath=${Topic_Label_XPath}
  

Verify Homepage Widgets Are Present
  Log to Console  + Verify Homepage Widgets Are Present
  CommonPage.Wait Until All Widgets Are Loaded
  Wait Until Element Is Visible  xpath=${Kpi_Content_XPath}  ${Element_Wait_Time}
  Wait Until Element Is Visible  xpath=${Table_Content_Xpath}  ${Element_Wait_Time}
  

Verify Filtering
  Log to Console  + Verify Filtering
  Element Should Not Be Visible  xpath=${Reset_All_Filters_Button_XPath}
  # Table data should be loaded
  Wait Until Element Is Visible  ${Table1_Data_Col_Xpath}  ${Element_Wait_Time}
  # Filter by one Property
  Execute Javascript  ${Filter_Expand_Script}
  Wait Until Element Is Visible  ${Filter_Selected_Li_Xpath}  ${Element_Wait_Time}
  ${Property_Selected_Text}=  Execute Javascript  ${Filter_Option_Text_Script}
  Execute Javascript  ${Filter_Option_Click_Script}
  Execute Javascript  ${Filter_Ok_Click_Script}
  CommonPage.Wait For Filter Applied
  # Verify the filter data
  ${Property_Data_Text}=  Get Text  ${Table1_Data_Col_Xpath}
  Should Be Equal As Strings  ${Property_Selected_Text}  ${Property_Data_Text}
  

Verify No More Than Five Announcements
  Log to Console  + Verify No More Than Five Announcements
  ${announcement_count}=  Get Matching Xpath Count  xpath=${Announcment_XPath}
  Should Be True  ${announcement_count} <= 5
  

Verify Most Visited Dashboards
  Log to Console  + Verify Most Visited Dashboards
  Wait Until Element Is Visible  ${Most_Visited_Dashboards_XPath}  ${Element_Wait_Time}
  ${dashboard_count}=  Get Matching Xpath Count  xpath=${Most_Visited_Dashboards_XPath}
  Should Be True  ${dashboard_count} <= 5
  : FOR  ${index}  IN RANGE  1  ${dashboard_count}+1
  \   Set Test Variable  ${dasbhoard_name_xpath}  (${Most_Visited_Dashboards_XPath})[${index}]
  \   Wait Until Element Is Visible  xpath=${dasbhoard_name_xpath}  ${Element_Wait_Time}
  \   ${topic_name}=  Get Text  xpath=${dasbhoard_name_xpath}
  \   Click Element  xpath=${dasbhoard_name_xpath}
  \   Element Text Should Be  xpath=${Topic_Label_XPath}  ${topic_name}
  \   CommonPage.Load Home Dashboard
  \   CommonPage.Wait For Page Loading


Verify Support Links Are Present
  Log to Console  + Verify Support Links Are Present
  Wait Until Element Is Visible  xpath=${Support_Links_XPath}  ${Element_Wait_Time}
  ${support_link_count}=  Get Matching Xpath Count  xpath=${Support_Links_Column_One_Links_XPath}[./text()="FAQ"]
  Should Be True  ${support_link_count} > 0
  ${support_link_count}=  Get Matching Xpath Count  xpath=${Support_Links_Column_One_Links_XPath}[./text()="Resources"]
  Should Be True  ${support_link_count} > 0
  ${support_link_count}=  Get Matching Xpath Count  xpath=${Support_Links_Column_One_Links_XPath}[./text()="Contact Support"]
  Should Be True  ${support_link_count} > 0

