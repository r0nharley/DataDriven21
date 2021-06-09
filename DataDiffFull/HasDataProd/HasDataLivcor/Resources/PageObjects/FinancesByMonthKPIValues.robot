*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***




*** Keywords ***
Rentlytics Livcor Finances By Month Has Data
    Navigate to Livcor Finances By Month
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



Navigate to Livcor Finances By Month
    go to  https://secure.rentlytics.com/livcor/bi/finances-by-month/visualization


Maximize FBM Window
    maximize browser window

Wait for Finances by Month KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  11
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5

Add Finances My Month Collection File
    create file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt

Finances by Month Actual Per Unit/Budget
    ${FBMkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi1}
    log  ${FBMkpi2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi2}\n

Finances by Month Total Revenue %Variance
    ${FBMkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi2_1}
    #log  ${FBMkpi2_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi2_1}\n
    #append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi2_2}\n

Finances by Month Total Revenue Budget Variance
    ${FBMkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi3_1}
    #log  ${FBMkpi3_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi3_1}\n
    #append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi3_2}\n

Finances by Month Total Expenses Actual Per Unit/Budget
    ${FBMkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi4_1
    log  ${FBMkpi4_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi4_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi4_2}\n

Finances by Month Total Expenses %Variance
    ${FBMkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi5_1}
    #log  ${FBMkpi5_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi5_1}\n
    #append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi5_2}\n

Finances by Month Total Expenses Budget Variance
    ${FBMkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi6_1}
    #log  ${FBMkpi6_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi6_1}\n
    #append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi6_2}\n

Finances by Month Net Operating Income Actual Per Unit/Budget
    ${FBMkpi7_1} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi7_2} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi7_1}
    log  ${FBMkpi7_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi7_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi7_2}\n

Finances by Month Net income Acutal PEr Unit/Budget
    ${FBMkpi8_1} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi8_2} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi8_1}
    log  ${FBMkpi8_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi8_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi8_2}\n

Finances by Month Net Income %Variance
    ${FBMkpi9_1} =      Get Text    //div[@id="kpi9"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBMkpi9_2} =      Get Text    //div[@id="kpi9"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi9_1}
    log  ${FBMkpi9_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi9_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi9_2}\n

Finances by Month Net Income Budget Variance
    ${FBMkpi10_1} =      Get Text    //div[@id="kpi10"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FBMkpi10_2} =      Get Text    //div[@id="kpi10"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBMkpi10_1}
    #log  ${FBMkpi10_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi10_1}\n
    #append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBMkpi10_2}\n

#Finances by Month Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  11
    #${FMB_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    # :FOR  ${FMB_has_data_primary}  IN   @{FMB_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${FMB_has_data_p1}=  element should be visible  ${FMB_has_data_primary}
    # \       ${FMB_get_text1}=  get text  ${FMB_has_data_primary}
    # \       log  ${FMB_get_text1}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FMB_get_text1}\n



#Finances by Month Has Data Secondary
    # wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5
    # ${FBM_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    # :FOR  ${FBM_has_data_secondary}  IN   @{FBM_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${FBM_has_data_p2}=  element should be visible  ${FBM_has_data_secondary}
    # \       ${FBM_get_text2}=  get text  ${FBM_has_data_secondary}
    # \       log  ${FBM_get_text2}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finances_by_Month_KPIs_File.txt  ${FBM_get_text2}\n
