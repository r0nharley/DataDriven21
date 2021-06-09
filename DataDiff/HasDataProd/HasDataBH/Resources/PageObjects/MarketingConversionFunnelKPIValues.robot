*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Marketing Conversion Funnel Has Data
    Navigate to BH Management Marketing Conversion Funnel
    Maximize MCF Window
    Wait for Marketing Conversion Funnel KPIs
    Add Marketing Conversion Funnel Collection File
    Marketing Conversion Funnel Total First Contacts
    Marketing Conversion Funnel Total Apps Submitted
    Marketing Conversion Funnel Total Apps Denied
    Marketing Conversion Funnel Total Apps Cancelled
    Marketing Conversion Funnel Avg Days to Apply





Navigate to BH Management Marketing Conversion Funnel
    go to  https://secure.rentlytics.com/bh-management/bi/marketing-conversion-funnel/visualization


Maximize MCF Window
    maximize browser window

Wait for Marketing Conversion Funnel KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5

Add Marketing Conversion Funnel Collection File
    create file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt

Marketing Conversion Funnel Total First Contacts
    ${MCFkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi1}
    log  ${MCFkpi2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi2}\n


Marketing Conversion Funnel Total Apps Submitted
    ${MCFkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi2_1}
    log  ${MCFkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi2_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi2_2}\n

Marketing Conversion Funnel Total Apps Denied
    ${MCFkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi3_1}
    log  ${MCFkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi3_2}\n

Marketing Conversion Funnel Total Apps Cancelled
    ${MCFkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi4_1}
    log  ${MCFkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi4_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi4_2}\n

Marketing Conversion Funnel Avg Days to Apply
    ${MCFkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi5_1}
    log  ${MCFkpi5_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi5_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi5_2}\n




