*** Settings ***
Library  Selenium2Library

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot
Resource   ${EXECDIR}/RegressionCentral/FilterTest.robot


*** Variables ***
${ExecutiveChart} =  //div[@id="chart1"]
${ClickStart} =  //div[@id="chart1"]//*[name()="svg"]/*[@class="highcharts-series-group"]/*[name()="g"][1]/*[name()="rect"][1]
${ClickStop} =  //div[@id="chart1"]//*[name()="svg"]/*[@class="highcharts-series-group"]/*[name()="g"][1]/*[name()="rect"][3]
${Navigator} =   //div[@id="chart1"]//*[name()="svg"]/*[name()="g"][15]/*[name()="path"][2]
${PropertyCount} =  //div[contains(.,'2')]
${UnitsByPropertyHighlightFilter} =  //div[@title='# Units by Property']
${SidebarFilterCount} =  //span[contains(.,'2/')]

*** Keywords ***
HighlightFilter
    CommonV.Load Page and Wait for Element up to X Times  ${OverviewExecutiveDashboard}  ${UnitsByPropertyHighlightFilter}
    Select Highlight Area

Select Highlight Area
    CommonV.Screenshot if Specified
    wait until element is visible  ${UnitsByPropertyHighlightFilter}  ${page_request_timeout}
    element should not be visible  ${ResetFilters}
    wait until element is visible  ${ClickStart}  ${page_request_timeout}
    CommonV.Screenshot if Specified
    drag and drop   ${ClickStart}   ${ClickStop}
    CommonV.Screenshot if Specified
    wait until element is visible  ${PropertyCount}  30
    wait until element is visible  ${SidebarFilterCount}  10
    click element  ${ResetFilters}
    wait until element is not visible  ${ResetFilters}  10
    CommonV.Screenshot if Specified

