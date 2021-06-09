*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Finance Trends Has Data
    Navigate to BH Management Finance Trends
    Maximize FBT Window
    Wait for Finance Trends KPIs
    Add Finances By Trends Collection File
    Finances By Trends Total Revenue Current Period Total
    Finances By Trends Total Expenses Current Period Total
    Finances By Trends Net Operating Income Current Period Total
    Finances By Trends Net Income Current Period Total



Navigate to BH Management Finance Trends
    go to  https://secure.rentlytics.com/bh-management/bi/finances-trends/visualization


Maximize FBT Window
    maximize browser window

Wait for Finance Trends KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  4

Add Finances By Trends Collection File
    create file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt

Finances By Trends Total Revenue Current Period Total
    ${FTkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi1}
    log  ${FTkpi2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi2}\n

Finances By Trends Total Expenses Current Period Total
    ${FTkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi2_1}
    log  ${FTkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi2_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi2_2}\n


Finances By Trends Net Operating Income Current Period Total
    ${FTkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi3_1}
    log  ${FTkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi3_2}\n


Finances By Trends Net Income Current Period Total
    ${FTkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi4_1}
    log  ${FTkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi4_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Trends_File.txt  ${FTkpi4_2}\n


