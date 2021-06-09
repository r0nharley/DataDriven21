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
Rentlytics Winterwood Operations Leases Has Data
    Run Keyword  User Signin Extended
    Navigate to Winterwood Operations Leases
    Maximize MOL Window
    Wait for Operations Leases KPIs
    Add Operations Leases KPIs Collection File
    Operations Leases # Occupied Units
    Operations Leases AVG Months of Tenacy
    Operations Leases AVG Lease Term
    Operations Leases Has Data Difference

    #Operations Leases Has Data Primary
    #Operations Leases Has Data Secondary


Navigate to Winterwood Operations Leases
    go to  https://staging.rentlytics.com/winterwood/bi/operations-leases/visualization

Maximize MOL Window
    maximize browser window


Wait for Operations Leases KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  3

Add Operations Leases KPIs Collection File
    create file  HasDataProd/HasDataWinterwood/Results/Operations_Leases_File.txt

Operations Leases # Occupied Units
    ${OLkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi1}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ${OLkpi1}\n

Operations Leases AVG Months of Tenacy
    ${OLkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi2_1}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ${OLkpi2_1}\n

Operations Leases AVG Lease Term
    ${OLkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi3_1}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ${OLkpi3_1}\n

#Operations Leases Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  3
    #${OL_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OL_has_data_primary}  IN   @{OL_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OL_has_data_p1}=  element should be visible  ${OL_has_data_primary}
    # \       ${OL_get_text1}=  get text  ${OL_has_data_primary}
    # \       log  ${OL_get_text1}
    # \       append to file   HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ${OL_get_text1}\n



#Operations Leases Has Data Secondary

    #${OL_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${OL_has_data_secondary}  IN   @{OL_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OL_has_data_p2}=  element should be visible  ${OL_has_data_secondary}
    # \       ${OL_get_text2}=  get text  ${OL_has_data_secondary}

Operations Leases Has Data Difference
    copy file  ./HasDataProd/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ${output_dir}/HasDataProd/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt

    copy file  ./HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ${output_dir}/HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt

    diff kpis  ./HasDataProd/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  ./HasDataStage/HasDataWinterwood/Results/Operations_Leases_KPIs_File.txt  Operations Leases
