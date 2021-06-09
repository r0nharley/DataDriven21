*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Marketing Leasing Results Has Data
    Navigate to BH Management Marketing Leasing Results
    Maximize MML Window
    Wait for Marketing Leasing Results KPIs
    Add Marketing Leasing Results Collection File
    Marketing Leasing Results Total First Contacts
    Marketing Leasing Results Move-In Percentage
    Marketing Leasing Results Total AVG Lease Rent
    Marketing Leasing Results Last 30 Days Lease Rent



Navigate to BH Management Marketing Leasing Results
    go to  https://secure.rentlytics.com/bh-management/bi/marketing-leasing-results/visualization


Maximize MML Window
    maximize browser window

Wait for Marketing Leasing Results KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3

Add Marketing Leasing Results Collection File
    create file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt

Marketing Leasing Results Total First Contacts
    ${MLRkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MLRkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MLRkpi1}
    log  ${MLRkpi2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi2}\n

Marketing Leasing Results Move-In Percentage
    ${MLRkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MLRkpi2_1}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi2_1}\n

Marketing Leasing Results Total AVG Lease Rent
    ${MLRkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MLRkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MLRkpi3_1}
    log  ${MLRkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi3_2}\n

Marketing Leasing Results Last 30 Days Lease Rent
    ${MLRkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MLRkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MLRkpi4_1}
    log  ${MLRkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi4_1}\n
    append to file   HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi4_2}\n






