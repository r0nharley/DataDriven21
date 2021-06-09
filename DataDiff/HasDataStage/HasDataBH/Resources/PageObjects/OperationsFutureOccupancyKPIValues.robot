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
Rentlytics BH Management Operations Future Occupancy Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Operations Future Occupancy
    Maximize OFO Window
    Wait for Operations Future Occupancy KPIs
    Add Operations Future Occupancy KPIs Collection File
    Operations Current Occupancy %
    Operations Future Occupancy %
    Operations # Vacant Units
    Operations # NTV Units
    Operations Future Occupancy Has Data Difference

    #Operations Future Occupancy Has Data Primary
    #Operations Future Occupancy Has Data Secondary


Navigate to BH Management Operations Future Occupancy
    go to  https://staging.rentlytics.com/bh-management/bi/operations-future-occupancy/visualization


Maximize OFO Window
    maximize browser window

Wait for Operations Future Occupancy KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  4

Add Operations Future Occupancy KPIs Collection File
    create file  HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt

Operations Current Occupancy %
    ${OFOkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi1}
    log  ${OFOkpi2}
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi1}\n
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi2}\n

Operations Future Occupancy %
    ${OFOkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi2_1}
    log  ${OFOkpi2_2}
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi2_1}\n
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi2_2}\n

Operations # Vacant Units
    ${OFOkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi3_1}
    log  ${OFOkpi3_2}
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi3_1}\n
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi3_2}\n

Operations # NTV Units
    ${OFOkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi4_1}
    log  ${OFOkpi4_2}
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi4_1}\n
    append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi4_2}\n

#Operations Future Occupancy Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    #${OFO_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OFO_has_data_primary}  IN   @{OFO_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OFO_has_data_p1}=  element should be visible  ${OFO_has_data_primary}
    # \       ${OFO_get_text1}=  get text  ${OFO_has_data_primary}
    # \       log  ${OFO_get_text1}
    # \       append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFO_get_text1}\n


#Operations Future Occupancy Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  4
    #${OFO_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${OFO_has_data_secondary}  IN   @{OFO_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    #\       ${OFO_has_data_p2}=  element should be visible  ${OFO_has_data_secondary}
    #\       ${OFO_get_text2}=  get text  ${OFO_has_data_secondary}
    #\       log  ${OFO_get_text2}
    #\       append to file   HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFO_get_text2}\n

Operations Future Occupancy Has Data Difference
    copy file  ./HasDataProd/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Operations_FutureOccupancy_File.txt

    copy file  ./HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt

    diff kpis  ./HasDataProd/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ./HasDataStage/HasDataBH/Results/Operations_FutureOccupancy_File.txt  Management Operations Future Occupancy