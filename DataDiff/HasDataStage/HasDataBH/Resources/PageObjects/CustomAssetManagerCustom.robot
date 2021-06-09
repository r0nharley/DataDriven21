*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String
Library  DiffLibrary
Library  ${EXECDIR}/diff.py
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot

*** Variables ***

${Asset_Manager_Custom_Dash} =  https://staging.rentlytics.com/bh-management/bi/bh-custom-asset-manager-custom/visualization

*** Keywords ***
Rentlytics BH Management Asset Manager Custom KPI Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Asset Manager Custom
    Maximize Asset Manager Custom Window
    Wait for BH Management Asset Manager Custom KPIs
    Add Custom Asset Manager Collection File
    Number of Units
    Current Occupancy
    Current Effective Rent
    Vacant Units
    Future Occupancy Percentage
    T13 AVG Occupancy
    T13 Effective Rent
    Make Ready %
    Custom Asset Manager Difference




Navigate to BH Management Asset Manager Custom
    go to  ${Asset_Manager_Custom_Dash}

Maximize Asset Manager Custom Window
    maximize browser window

Wait for BH Management Asset Manager Custom KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  8

Add Custom Asset Manager Collection File
    create file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt

Number of Units
    ${AMC_kpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi1}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi1}\n

Current Occupancy
    ${AMC_kpi2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi2}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi2}\n

Current Effective Rent
    ${AMC_kpi3} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi3}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi3}\n

Vacant Units
    ${AMC_kpi4} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi4}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi4}\n

Future Occupancy Percentage
    ${AMC_kpi5} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi5}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi5}\n

T13 AVG Occupancy
    ${AMC_kpi6} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi6}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi6}\n

T13 Effective Rent
    ${AMC_kpi7} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi7}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi7}\n

Make Ready %
    ${AMC_kpi8} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi8}
    append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi8}\n

#BH Management Asset Manager Custom Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  8
    #${PC_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${PC_has_data_primary}  IN   @{PC_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${PC_has_data_p1}=  element should be visible  ${PC_has_data_primary}
    # \       ${PC_get_text1}=  get text  ${PC_has_data_primary}
    # \       log  ${PC_get_text1}
    # \       append to file   HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${PC_get_text1}\n

Custom Asset Manager Difference
    copy file  ./HasDataProd/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Custom_Asset_Manager_Custom.txt

    copy file  ./HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt

    diff kpis  ./HasDataProd/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ./HasDataStage/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  Asset Manager Custom


