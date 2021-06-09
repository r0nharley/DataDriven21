*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String
Library  DiffLibrary
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot

*** Variables ***

${executive_dashboard} =  https://secure.rentlytics.com/winterwood/bi/overview-executive/visualization

*** Keywords ***
Rentlytics Winterwood Executive KPI Has Data
    Run keyword  User Signin Extended
    Navigate to Winterwood Executive
    Maximize Window
    Wait for Executive KPIs
    Add Executive Collection File
    Properties/Units
    Current Occupancy/Future Occupancy %
    Average Actual Rent/Loss to Lease
    NOI Budget Variance%/Variance in $
    YOY NOI/^in $
    YOY Potential Rent/^in $
    Expense Ratio
    #Has Data Primary
    #Has Data Secondary




Navigate to Winterwood Executive
    go to  ${executive_dashboard}


Maximize Window
    maximize browser window


Wait for Executive KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  7
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  6

Add Executive Collection File
    create file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt

Properties/Units
    ${kpi1_1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi1_2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi1_1}
    log  ${kpi1_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi1_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi1_2}\n


Current Occupancy/Future Occupancy %
    ${kpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi2_1}
    log  ${kpi2_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi2_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi2_2}\n

Average Actual Rent/Loss to Lease
    ${kpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi3_1}
    log  ${kpi3_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi3_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi3_2}\n

NOI Budget Variance%/Variance in $
    ${kpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi4_1}
    log  ${kpi4_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi4_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi4_2}\n

YOY NOI/^in $
    ${kpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi5_1}
    log  ${kpi5_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi5_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi5_2}\n

YOY Potential Rent/^in $
    ${kpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi6_1}
    log  ${kpi6_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi6_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi6_2}\n

Expense Ratio
    ${kpi7_1} =      Get Text    //div[@id='kpi7']//div[contains(@class,'rl-primary-kpi-value')]
    #${kpi7_2} =      Get Text    //div[@id='kpi7']//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi7_1}
    #log  ${kpi7_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi7_1}\n
    #append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${kpi7_2}\n


#Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  7
    #${has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${has_data_primary}  IN   @{has_data_primary}
     #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     #\       ${has_data_p1}=  element should be visible  ${has_data_primary}
     #\       ${get_text1}=  get text  ${has_data_primary}
     #\       log  ${get_text1}
     #\       append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${get_text1}\n

#Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  6
    #${has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${has_data_secondary}  IN   @{has_data_secondary}
     #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     #\       ${has_data_p2}=  element should be visible  ${has_data_secondary}
     #\       ${get_text2}=  get text  ${has_data_secondary}
     #\       log  ${get_text2}
     #\       append to file   HasDataProd/HasDataWinterwood/Results/Executive_KPIs_File.txt  ${get_text2}\n

