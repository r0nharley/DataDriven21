*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics Livcor Finances By Property KPI Has Data
    Navigate to Livcor Finances By Property
    Maximize FBP Window
    Wait for Finances By Property KPIs
    Add Finances By Property Collection File
    Finances By Property Total Revenue Actual Per Unit
    Finances By Property Total Revenue % Variance
    Finances By Property Total Expenses Actual Per Unit
    Finances By Property Total Expenses % Variance
    Finances By Property Net Operating Income Actual Per Unit
    Finances By Property Net Operating % Variance
    Finances By Property Net Income Actual Per Unit
    Finances By Property Net Income %Variance



Navigate to Livcor Finances By Property
    go to  https://secure.rentlytics.com/livcor/bi/finances-by-property/visualization


Maximize FBP Window
    maximize browser window

Wait for Finances By Property KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  8
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  8

Add Finances By Property Collection File
    create file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt

Finances By Property Total Revenue Actual Per Unit
    ${FBPkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi1}
    log  ${FBPkpi2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi2}\n

Finances By Property Total Revenue % Variance
    ${FBPkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi2_1}
    log  ${FBPkpi2_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi2_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi2_2}\n

Finances By Property Total Expenses Actual Per Unit
    ${FBPkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi3_1}
    log  ${FBPkpi3_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi3_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi3_2}\n

Finances By Property Total Expenses % Variance
    ${FBPkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi4_1}
    log  ${FBPkpi4_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi4_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi4_2}\n

Finances By Property Net Operating Income Actual Per Unit
    ${FBPkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi5_1}
    log  ${FBPkpi5_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi5_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi5_2}\n

Finances By Property Net Operating % Variance
    ${FBPkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi6_1}
    log  ${FBPkpi6_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi6_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi6_2}\n

Finances By Property Net Income Actual Per Unit
    ${FBPkpi7_1} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi7_2} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi7_1}
    log  ${FBPkpi7_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi7_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi7_2}\n

Finances By Property Net Income %Variance
    ${FBPkpi8_1} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FBPkpi8_2} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FBPkpi8_1}
    log  ${FBPkpi8_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi8_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${FBPkpi8_2}\n


#Finances By Property Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  8
    #${PB_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${PB_has_data_primary}  IN   @{PB_has_data_primary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${PB_has_data_p1}=  element should be visible  ${PB_has_data_primary}
    # \       ${PB_get_text1}=  get text  ${PB_has_data_primary}
    # \       log  ${PB_get_text1}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${PB_get_text1}\n


#Finances By Property Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  8
    #${PB_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${PB_has_data_secondary}  IN   @{PB_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     #\       ${PB_has_data_p2}=  element should be visible  ${PB_has_data_secondary}
     #\       ${PB_get_text2}=  get text  ${PB_has_data_secondary}
     #\       log  ${PB_get_text2}
     #\       append to file   HasDataProd/HasDataLivcor/Results/Finances_By_Property_KPIs_File.txt  ${PB_get_text2}\n
