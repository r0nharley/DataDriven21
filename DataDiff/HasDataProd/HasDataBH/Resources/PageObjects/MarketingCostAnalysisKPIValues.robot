*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Cost Analysis Has Data
    Navigate to BH Management Cost Analysis
    Maximize MCA Window
    Wait for Cost Analysis KPIs
    Add Marketing Cost Analysis Collection File
    Marketing Cost Analysis Cost Per Contact
    Marketing Cost Analysis Cost Per Application
    Marketing Cost Analysis Cost Per App Approved
    Marketing Cost Analysis Cost Per Move-In




Navigate to BH Management Cost Analysis
    go to  https://secure.rentlytics.com/bh-management/bi/marketing-cost-analysis/visualization


Maximize MCA Window
    maximize browser window

Wait for Cost Analysis KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4

Add Marketing Cost Analysis Collection File
    create file   HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt

Marketing Cost Analysis Cost Per Contact
    ${MCAkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi1}\n

Marketing Cost Analysis Cost Per Application
    ${MCAkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi2_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi2_1}\n

Marketing Cost Analysis Cost Per App Approved
    ${MCAkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi3_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi3_1}\n

Marketing Cost Analysis Cost Per Move-In
    ${MCAkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi4_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi4_1}\n






