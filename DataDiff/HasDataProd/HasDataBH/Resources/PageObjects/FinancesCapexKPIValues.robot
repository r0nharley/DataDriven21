*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Finance Capex Has Data
    Navigate to BH Management Finances Capex
    Maximize FC Window
    Wait for Finances Capex KPIs
    Add Finances Capex Collection File
    Finances Capex Actual Per Unit
    Finances Capex Total Capex
    Finances Capex Budget Variance
    Finances Capex Capex % Of Revenue
    Finances Capex Total Interior Capex
    Finances Capex Total Exterior Capex




Navigate to BH Management Finances Capex
    go to  https://secure.rentlytics.com/bh-management/bi/finances-capex/visualization


Maximize FC Window
    maximize browser window

Wait for Finances Capex KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  6
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5

Add Finances Capex Collection File
    create file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt


Finances Capex Actual Per Unit
    ${FCkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi1}
    log  ${FCkpi2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi2}\n


Finances Capex Total Capex
    ${FCkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi2_1}
    log  ${FCkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi2_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi2_2}\n


Finances Capex Budget Variance
    ${FCkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi3_1}
    log  ${FCkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi3_2}\n


Finances Capex Capex % Of Revenue
    ${FCkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FCkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi4_1}
    #log  ${FCkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi4_1}\n
    #append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi4_2}\n

Finances Capex Total Interior Capex
    ${FCkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi5_1}
    log  ${FCkpi5_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi5_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi5_2}\n

Finances Capex Total Exterior Capex
    ${FCkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi6_1}
    log  ${FCkpi6_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi6_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Capex_File.txt  ${FCkpi6_2}\n






