*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics Livcor Finance Trends Has Data
    Navigate to Livcor Finance Trends
    Maximize FBT Window
    Wait for Finance Trends KPIs
    Add Finances By Trends Collection File
    Finances By Trends Total Revenue Current Period Total
    Finances By Trends Total Expenses Current Period Total
    Finances By Trends Net Operating Income Current Period Total
    Finances By Trends Net Income Current Period Total



Navigate to Livcor Finance Trends
    go to  https://secure.rentlytics.com/livcor/bi/finances-trends/visualization


Maximize FBT Window
    maximize browser window

Wait for Finance Trends KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  4

Add Finances By Trends Collection File
    create file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt

Finances By Trends Total Revenue Current Period Total
    ${FTkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi1}
    log  ${FTkpi2}
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi2}\n

Finances By Trends Total Expenses Current Period Total
    ${FTkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi2_1}
    log  ${FTkpi2_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi2_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi2_2}\n


Finances By Trends Net Operating Income Current Period Total
    ${FTkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi3_1}
    log  ${FTkpi3_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi3_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi3_2}\n


Finances By Trends Net Income Current Period Total
    ${FTkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FTkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FTkpi4_1}
    log  ${FTkpi4_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi4_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FTkpi4_2}\n



#Finance Trends Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    #${FT_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${FT_has_data_primary}  IN   @{FT_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${FT_has_data_p1}=  element should be visible  ${FT_has_data_primary}
    # \       ${FT_get_text1}=  get text  ${FT_has_data_primary}
    # \       log  ${FT_get_text1}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FT_get_text1}\n


#Finance Trends Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  4
    #${FT_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${FT_has_data_secondary}  IN   @{FT_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${FT_has_data_p2}=  element should be visible  ${FT_has_data_secondary}
    # \       ${FT_get_text2}=  get text  ${FT_has_data_secondary}
    # \       log  ${FT_get_text2}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finance_Trends_KPIs_File.txt  ${FT_get_text2}\n
