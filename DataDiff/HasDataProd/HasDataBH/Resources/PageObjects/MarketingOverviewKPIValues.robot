*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Marketing Overview Has Data
    Navigate to BH Management Marketing Overview
    Maximize MMO Window
    Wait for Marketing Overview KPIs
    Add Marketing Overview KPIs Collection File
    Marketing Overview Total First Contacts
    Marketing Overview Total Apps Submitted
    Marketing Overview Total Move-ins
    Marketing Overview Conversion Percentage
    Marketing Overview Move-In Percentage
    Marketing Overview Cancel/Denial Ratio




Navigate to BH Management Marketing Overview
    go to  https://secure.rentlytics.com/bh-management/bi/marketing-overview/visualization


Maximize MMO Window
    maximize browser window

Wait for Marketing Overview KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  6
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3

Add Marketing Overview KPIs Collection File
    create file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt


Marketing Overview Total First Contacts
    ${MOkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MOkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MOkpi1}
    log  ${MOkpi2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi2}\n

Marketing Overview Total Apps Submitted
    ${MOkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MOkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MOkpi2_1}
    log  ${MOkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi2_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi2_2}\n

Marketing Overview Total Move-ins
    ${MOkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MOkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MOkpi3_1}
    log  ${MOkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi3_2}\n

Marketing Overview Conversion Percentage
    ${MOkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MOkpi4_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi4_1}\n

Marketing Overview Move-In Percentage
    ${MOkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MOkpi5_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi5_1}\n

Marketing Overview Cancel/Denial Ratio
    ${MOkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MOkpi6_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Overview.txt  ${MOkpi6_1}\n





