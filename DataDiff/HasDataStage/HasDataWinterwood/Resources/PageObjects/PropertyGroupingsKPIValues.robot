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
Rentlytics Winterwood Property Grouping Has Data
    Run Keyword  User Signin Extended
    Navigate to Winterwood Property Groupings
    Maximize PG Window
    Wait for Property Grouping KPIs
    Add Property Grouping KPIs Collection File
    Property Grouping Properties/Units
    Property Grouping Current Occupancy/Future Occupancy %
    Property Grouping Average Actual Rent/Loss to Lease
    Property Grouping NOI Budget Variance%/Variance in $
    Property Grouping YOY NOI/^in $
    Property Grouping YOY Potential Rent/^in $
    Property Grouping Expense Ratio
    Property Grouping Has Data Diff

    #Property Grouping Has Data Primary
    #Property Grouping Has Data Secondary


Navigate to Winterwood Property Groupings
    go to  https://staging.rentlytics.com/winterwood/bi/overview-property-groupings/visualization

Maximize PG Window
    maximize browser window

Wait for Property Grouping KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  7
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  6

Add Property Grouping KPIs Collection File
    create file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt



Property Grouping Properties/Units
    ${PGkpi1_1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${PGkpi1_2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi1_1}
    log  ${PGkpi1_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi1_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi1_2}\n


Property Grouping Current Occupancy/Future Occupancy %
    ${PGkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${PGkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi2_1}
    log  ${PGkpi2_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi2_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi2_2}\n

Property Grouping Average Actual Rent/Loss to Lease
    ${PGkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${PGkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi3_1}
    log  ${PGkpi3_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi3_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi3_2}\n

Property Grouping NOI Budget Variance%/Variance in $
    ${PGkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${PGkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi4_1}
    log  ${PGkpi4_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi4_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi4_2}\n

Property Grouping YOY NOI/^in $
    ${PGkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${PGkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi5_1}
    log  ${PGkpi5_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi5_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi5_2}\n

Property Grouping YOY Potential Rent/^in $
    ${PGkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${PGkpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi6_1}
    log  ${PGkpi6_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi6_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi6_2}\n

Property Grouping Expense Ratio
    ${PGkpi7_1} =      Get Text    //div[@id='kpi7']//div[contains(@class,'rl-primary-kpi-value')]
    #${PGkpi7_2} =      Get Text    //div[@id='kpi7']//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${PGkpi7_1}
    #log  ${PGkpi7_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi7_1}\n
    #append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PGkpi7_2}\n


#Property Grouping Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  7
    #${PG_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${PG_has_data_primary}  IN   @{PG_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${PG_has_data_p1}=  element should be visible  ${PG_has_data_primary}
    # \       ${PG_get_text1}=  get text  ${PG_has_data_primary}
    # \       log  ${PG_get_text1}
    # \       append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PG_get_text1}\n


#Property Grouping Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  6
    #${PG_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${PG_has_data_secondary}  IN   @{PG_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${PG_has_data_p2}=  element should be visible  ${PG_has_data_secondary}
    # \       ${PG_get_text2}=  get text  ${PG_has_data_secondary}
    # \       log  ${PG_get_text2}
    # \       append to file   HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${PG_get_text2}\n


Property Grouping Has Data Diff
    copy file  ./HasDataProd/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${output_dir}/HasDataProd/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt

    copy file  ./HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ${output_dir}/HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt

    diff kpis  ./HasDataProd/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  ./HasDataStage/HasDataWinterwood/Results/Property_Grouping_KPIs_File.txt  Management Property Grouping



#Property Grouping Has Data Secondary

    #${PG_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${PG_has_data_secondary}  IN   @{PG_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${PG_has_data_p2}=  element should be visible  ${PG_has_data_secondary}
    # \       ${PG_get_text2}=  get text  ${PG_has_data_secondary}
