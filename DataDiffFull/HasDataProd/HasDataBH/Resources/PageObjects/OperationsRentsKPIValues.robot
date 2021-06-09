*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics BH Management Operations Rents Has Data
    Navigate to BH Management Operations Rents
    Maximize OR Window
    Wait for Operations Rents KPIs
    Add Operations Rents KPIs Collection File
    Operations Rents # Occupied Units
    Operations Rents AVG Actual Rent
    Operations Rents AVG Rent PSF
    Operations Rents Most Recent Rents
    Operations Rents Occupied Market Rent
    Operations Rents Vacant Market Rent

    #Operations Rents Has Data Primary
    #Operations Rents Has Data Secondary


Navigate to BH Management Operations Rents
    go to  https://secure.rentlytics.com/bh-management/bi/operations-rents/visualization


Maximize OR Window
    maximize browser window

Wait for Operations Rents KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  6
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3

Add Operations Rents KPIs Collection File
    create file  HasDataProd/HasDataBH/Results/Operations_Rents_File.txt

Operations Rents # Occupied Units
    ${ORkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ORkpi1}
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi1}\n

Operations Rents AVG Actual Rent
    ${ORkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${ORkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${ORkpi2_1}
    log  ${ORkpi2_2}
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi2_1}\n
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi2_2}\n

Operations Rents AVG Rent PSF
    ${ORkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${ORkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${ORkpi3_1}
    log  ${ORkpi3_2}
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi3_1}\n
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi3_2}\n


Operations Rents Most Recent Rents
    ${ORkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${ORkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${ORkpi4_1}
    log  ${ORkpi4_2}
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi4_1}\n
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi4_2}\n


Operations Rents Occupied Market Rent
    ${ORkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ORkpi5_1}
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi5_1}\n

Operations Rents Vacant Market Rent
    ${ORkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ORkpi6_1}
    append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi6_1}\n


#Operations Rents Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  6
    #${OR_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OR_has_data_primary}  IN   @{OR_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OR_has_data_p1}=  element should be visible  ${OR_has_data_primary}
    # \       ${OR_get_text1}=  get text  ${OR_has_data_primary}
    # \       log  ${OR_get_text1}
    # \       append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${OR_get_text1}\n


#Operations Rents Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3
    #${OR_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    # :FOR  ${OR_has_data_secondary}  IN   @{OR_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OR_has_data_p2}=  element should be visible  ${OR_has_data_secondary}
    # \       ${OR_get_text2}=  get text  ${OR_has_data_secondary}
    # \       log  ${OR_get_text2}
    # \       append to file   HasDataProd/HasDataBH/Results/Operations_Rents_File.txt  ${OR_get_text2}\n
