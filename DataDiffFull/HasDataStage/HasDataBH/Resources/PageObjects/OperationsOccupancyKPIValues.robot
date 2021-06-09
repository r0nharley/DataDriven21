*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String
Library  DiffLibrary
Library  ${EXECDIR}/diff.py
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot

*** Variables ***



*** Keywords ***
Rentlytics BH Management Operations Occupancy Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Operations Occupancy
    Maximize OO Window
    Wait for Operations Occupancy KPIs
    Add Operations Occupancy KPIs Collection File
    Operations Occupancy # Units
    Operations Occupancy Vacant Units
    Operations Occupancy Make Ready %
    Operations Occupancy Pending Move-Ins
    Operations Occupancy Notice Units
    Operations Occupancy Occupancy Percent
    Operations Occupancy Future Occupancy %
    Operations Occupancy AVG Days Vacant
    Operations Occupancy Max Days Vacant
    Operations Occupancy Vacancy Cost
    Operations Occupancy Has Data Difference

    #Operations Occupancy Has Data Primary
    #Operations Occupancy Has Data Secondary


Navigate to BH Management Operations Occupancy
    go to  https://staging.rentlytics.com/bh-management/bi/operations-occupancy/visualization

Maximize OO Window
    maximize browser window

Wait for Operations Occupancy KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  10

Add Operations Occupancy KPIs Collection File
    create file  HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt


Operations Occupancy # Units
    ${OOkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi1}\n

Operations Occupancy Vacant Units
    ${OOkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi2_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi2_1}\n

Operations Occupancy Make Ready %
    ${OOkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi3_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi3_1}\n

Operations Occupancy Pending Move-Ins
    ${OOkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi4_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi4_1}\n

Operations Occupancy Notice Units
    ${OOkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi5_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi5_1}\n

Operations Occupancy Occupancy Percent
    ${OOkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi6_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi6_1}\n

Operations Occupancy Future Occupancy %
    ${OOkpi7_1} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi7_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi7_1}\n

Operations Occupancy AVG Days Vacant
    ${OOkpi8_1} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi8_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi8_1}\n

Operations Occupancy Max Days Vacant
    ${OOkpi9_1} =      Get Text    //div[@id="kpi9"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi9_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi9_1}\n

Operations Occupancy Vacancy Cost
    ${OOkpi10_1} =      Get Text    //div[@id="kpi10"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi10_1}
    append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OOkpi10_1}\n


#Operations Occupancy Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  10
    #${OO_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OO_has_data_primary}  IN   @{OO_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OO_has_data_p1}=  element should be visible  ${OO_has_data_primary}
    # \       ${OO_get_text1}=  get text  ${OO_has_data_primary}
    # \       log  ${OO_get_text1}
    # \       append to file   HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${OO_get_text1}\n


#Operations Occupancy Has Data Secondary

    #${OO_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${OO_has_data_secondary}  IN   @{OO_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OO_has_data_p2}=  element should be visible  ${OO_has_data_secondary}
    # \       ${OO_get_text2}=  get text  ${OO_has_data_secondary}

Operations Occupancy Has Data Difference
    copy file  ./HasDataProd/HasDataBH/Results/Operations_Occupancy_File.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Operations_Occupancy_File.txt

    copy file  ./HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt

    diff kpis  ./HasDataProd/HasDataBH/Results/Operations_Occupancy_File.txt  ./HasDataStage/HasDataBH/Results/Operations_Occupancy_File.txt  Management Operations Occupancy