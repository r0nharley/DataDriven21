*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Finance Utilities Has Data
    Navigate to BH Management Finances Utilities
    Maximize FU Window
    Wait for Finances Utilities KPIs
    Add Finances Utilities Collection File
    Finances Net Total Utilities
    Finances Utilities % Variance
    Finances Utilities Actual Per Unit
    Finances Utilities Actual Recovery %
    Finances Utilities Water Recovery %
    Finances Utilities Electric Recovery
    Finances Utilities Gas Recovery
    Finances Utilities Trash Recovery





Navigate to BH Management Finances Utilities
    go to  https://secure.rentlytics.com/bh-management/bi/finances-utilities/visualization


Maximize FU Window
    maximize browser window

Wait for Finances Utilities KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  10
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  8

Add Finances Utilities Collection File
    create file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt


Finances Net Total Utilities
    ${FUkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi1}
    log  ${FUkpi2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi2}\n

Finances Utilities % Variance
    ${FUkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi2_1}
    log  ${FUkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi2_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi2_2}\n


Finances Utilities Actual Per Unit
    ${FUkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi3_1}
    log  ${FUkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi3_2}\n


Finances Utilities Actual Recovery %
    ${FUkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi4_1}
    log  ${FUkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi4_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi4_2}\n

Finances Utilities Water Recovery %
    ${FUkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi5_1}
    log  ${FUkpi5_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi5_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi5_2}\n


Finances Utilities Electric Recovery
    ${FUkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi6_1}
    log  ${FUkpi6_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi6_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi6_2}\n

Finances Utilities Gas Recovery
    ${FUkpi7_1} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi7_2} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi7_1}
    log  ${FUkpi7_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi7_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi7_2}\n

Finances Utilities Trash Recovery
    ${FUkpi8_1} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FUkpi8_2} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FUkpi8_1}
    log  ${FUkpi8_2}
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi8_1}\n
    append to file   HasDataProd/HasDataBH/Results/Finances_Utilities_File.txt  ${FUkpi8_2}\n






