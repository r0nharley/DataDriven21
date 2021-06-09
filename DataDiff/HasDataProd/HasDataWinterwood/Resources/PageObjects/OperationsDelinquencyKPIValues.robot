*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics Winterwood Operations Delinquency Has Data
    Navigate to Winterwood Operations Delinquency
    Maximize MOD Window
    Wait for Operations Delinquency KPIs
    Add Operations Delinquency KPIs Collection File
    Operations # Delinquent
    Operations $ Per Delinquent Residents
    Operations Total Delinquent % of Rent
    Operations Total Delinquent Balance
    Operations 0-30 Days Balance
    #Operations Delinquency Has Data Primary
    #Operations Delinquency Has Data Secondary


Navigate to Winterwood Operations Delinquency
    go to  https://secure.rentlytics.com/winterwood/bi/operations-delinquency/visualization


Maximize MOD Window
    maximize browser window

Wait for Operations Delinquency KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5

Add Operations Delinquency KPIs Collection File
    create file  HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt


Operations # Delinquent
    ${ODkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ODkpi1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt  ${ODkpi1}\n

Operations $ Per Delinquent Residents
    ${ODkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ODkpi2_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt  ${ODkpi2_1}\n

Operations Total Delinquent % of Rent
    ${ODkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ODkpi3_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt  ${ODkpi3_1}\n

Operations Total Delinquent Balance
    ${ODkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ODkpi4_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt  ${ODkpi4_1}\n

Operations 0-30 Days Balance
    ${ODkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ODkpi5_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt  ${ODkpi5_1}\n


#Operations Delinquency Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    #${OD_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OD_has_data_primary}  IN   @{OD_has_data_primary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    #\       ${OD_has_data_p1}=  element should be visible  ${OD_has_data_primary}
    #\       ${OD_get_text1}=  get text  ${OD_has_data_primary}
    #\       log  ${OD_get_text1}
    #\       append to file   HasDataProd/HasDataWinterwood/Results/Operations_Delinquency_KPIs_File.txt  ${OD_get_text1}\n


#Operations Delinquency Has Data Secondary

    #${OD_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${OD_has_data_secondary}  IN   @{OD_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    #\       ${OD_has_data_p2}=  element should be visible  ${OD_has_data_secondary}
    #\       ${OD_get_text2}=  get text  ${OD_has_data_secondary}
