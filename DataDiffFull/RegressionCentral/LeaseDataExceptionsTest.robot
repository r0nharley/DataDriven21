*** Settings ***
Library  Selenium2Library

*** Variables ***
${LDEDashboard} =  ${START_URL}/bi/overview-lease-data-exceptions/visualization
${RESChart} =  //div[@id="chart01"]
${LDESChart} =  //div[@id="chart02"]


*** Keywords ***
Lease Data Exceptions Test
    Navigate to the LDE Dashboard
    Verify Data Rent Exceptions Summary Chart
    Verify Lease Data Exceptions Summary Chart

Navigate to the LDE Dashboard
    go to  ${LDEDashboard}
    wait until element is visible  ${RESChart}  60
    wait until element is visible  ${LDESChart}  60

Verify Data Rent Exceptions Summary Chart
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@id="chart01"]//span[@class='rl-data-label']  2
    ${RESChartValues} =  get webelements   //div[@id="chart01"]//span[@class='rl-data-label']
    :FOR  ${RESChartValues}  IN  @{RESChartValues}
    \    element should be visible  ${RESChartValues}
    #\    element should not contain  ${RESChartValues}  0
    \    ${EachRESValue}=  get text  ${RESChartValues}
    \    log to console  ${EachRESValue}
    \    capture page screenshot

Verify Lease Data Exceptions Summary Chart
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@id="chart02"]//span[@class='rl-data-label']  5
    ${LDESChartValues} =  get webelements  //div[@id="chart02"]//span[@class='rl-data-label']
    :FOR  ${LDESChartValues}  IN  @{LDESChartValues}
    \    element should be visible  ${LDESChartValues}
    #\    element should not contain  ${LDESChartValues}  0
    \    ${EachLDESValue}=  get text  ${LDESChartValues}
    \    log to console  ${EachLDESValue}
    \    capture page screenshot
