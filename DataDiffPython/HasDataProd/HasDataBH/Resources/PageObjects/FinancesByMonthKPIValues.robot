*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String



*** Variables ***



*** Keywords ***
Rentlytics BH Management Finances By Month Has Data
    Navigate to BH Management Finances By Month
    Maximize FBM Window
    Wait for Finances by Month KPIs
    Add Finances My Month Collection File
    Finances by Month Actual Per Unit/Budget
    Finances by Month Total Revenue %Variance
    Finances by Month Total Revenue Budget Variance
    Finances by Month Total Expenses Actual Per Unit/Budget
    Finances by Month Total Expenses %Variance
    Finances by Month Total Expenses Budget Variance
    Finances by Month Net Operating Income Actual Per Unit/Budget
    Finances by Month Net income Acutal PEr Unit/Budget
    Finances by Month Net Income %Variance
    Finances by Month Net Income Budget Variance



Navigate to BH Management Finances By Month
    go to  https://secure.rentlytics.com/bh-management/bi/finances-by-month/visualization


Maximize FBM Window
    maximize browser window

Wait for Finances by Month KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  11
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5

Add Finances My Month Collection File
    create file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt

Finances by Month Actual Per Unit/Budget
    ${FBMkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi1}
    log  ${FBMkpi2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi2}\n

Finances by Month Total Revenue %Variance
    ${FBMkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi2_1}
    #log  ${FBMkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi2_1}\n
    #append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi2_2}\n

Finances by Month Total Revenue Budget Variance
    ${FBMkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi3_1}
    #log  ${FBMkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi3_1}\n
    #append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi3_2}\n

Finances by Month Total Expenses Actual Per Unit/Budget
    ${FBMkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi4_1
    log  ${FBMkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi4_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi4_2}\n

Finances by Month Total Expenses %Variance
    ${FBMkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi5_1}
    #log  ${FBMkpi5_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi5_1}\n
    #append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi5_2}\n

Finances by Month Total Expenses Budget Variance
    ${FBMkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi6_1}
    #log  ${FBMkpi6_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi6_1}\n
    #append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi6_2}\n

Finances by Month Net Operating Income Actual Per Unit/Budget
    ${FBMkpi7_1} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi7_2} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi7_1}
    log  ${FBMkpi7_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi7_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi7_2}\n

Finances by Month Net income Acutal PEr Unit/Budget
    ${FBMkpi8_1} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi8_2} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi8_1}
    log  ${FBMkpi8_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi8_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi8_2}\n

Finances by Month Net Income %Variance
    ${FBMkpi9_1} =      Get Text    //div[@id="kpi9"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi9_2} =      Get Text    //div[@id="kpi9"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi9_1}
    log  ${FBMkpi9_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi9_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi9_2}\n

Finances by Month Net Income Budget Variance
    ${FBMkpi10_1} =      Get Text    //div[@id="kpi10"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi10_2} =      Get Text    //div[@id="kpi10"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi10_1}
    #log  ${FBMkpi10_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi10_1}\n
    #append to file   HasDataProd/HasDataBH/Results/Finances_By_Month_File.txt  ${FBMkpi10_2}\n
