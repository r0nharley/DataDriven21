*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics Livcor Finance Capex Has Data
    Navigate to Livcor Finances Capex
    Maximize FC Window
    Wait for Finances Capex KPIs
    Add Finances Capex Collection File
    Finances Capex Actual Per Unit
    Finances Capex Total Capex
    Finances Capex Budget Variance
    Finances Capex Capex % Of Revenue
    Finances Capex Total Interior Capex
    Finances Capex Total Exterior Capex




Navigate to Livcor Finances Capex
    go to  https://secure.rentlytics.com/livcor/bi/finances-capex/visualization


Maximize FC Window
    maximize browser window

Wait for Finances Capex KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  6
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5

Add Finances Capex Collection File
    create file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt


Finances Capex Actual Per Unit
    ${FCkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi1}
    log  ${FCkpi2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi2}\n


Finances Capex Total Capex
    ${FCkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi2_1}
    log  ${FCkpi2_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi2_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi2_2}\n


Finances Capex Budget Variance
    ${FCkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi3_1}
    log  ${FCkpi3_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi3_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi3_2}\n


Finances Capex Capex % Of Revenue
    ${FCkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    #${FCkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi4_1}
    #log  ${FCkpi4_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi4_1}\n
    #append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi4_2}\n

Finances Capex Total Interior Capex
    ${FCkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi5_1}
    log  ${FCkpi5_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi5_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi5_2}\n

Finances Capex Total Exterior Capex
    ${FCkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${FCkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${FCkpi6_1}
    log  ${FCkpi6_2}
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi6_1}\n
    append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FCkpi6_2}\n



#Finances Capex Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  6
    #${FC_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${FC_has_data_primary}  IN   @{FC_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${FC_has_data_p1}=  element should be visible  ${FC_has_data_primary}
    # \       ${FC_get_text1}=  get text  ${FC_has_data_primary}
    # \       log  ${FC_get_text1}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FC_get_text1}\n



#Finances Capex Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5
    #${FC_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${FC_has_data_secondary}  IN   @{FC_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${FC_has_data_p2}=  element should be visible  ${FC_has_data_secondary}
    # \       ${FC_get_text2}=  get text  ${FC_has_data_secondary}
    # \       log  ${FC_get_text2}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Finances_Capex_KPIs_File.txt  ${FC_get_text2}\n

