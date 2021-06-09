*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String
Library  ${EXECDIR}/diff.py
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot

*** Variables ***

${Asset_Manager_Custom_Dash} =  https://rl-chameleon-test.herokuapp.com/bh-management/bi/bh-custom-asset-manager-custom/visualization

*** Keywords ***
Rentlytics BH Management Asset Manager Custom KPI Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Asset Manager Custom
    Maximize CAMC Window
    Wait for BH Management Asset Manager Custom KPIs
    Add Custom Asset Manager Collection File
    Number of Units
    Current Occupancy
    Vacant Units
    Future Occupancy Percentage
    T13 AVG Occupancy
    T13 Effective Rent
    Make Ready %
    Custom Asset Manager Difference



Navigate to BH Management Asset Manager Custom
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/bh-custom-asset-manager-custom/visualization
    maximize browser window
    #wait until element is visible  //span[contains(.,'Asset Manager Custom')]  20
    #capture page screenshot
    wait until element is visible  //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]  60
    wait until element is visible  //div[@id="kpi2"]  60
    wait until element is visible  //div[@id="kpi3"]  60
    wait until element is visible  //div[@id="kpi4"]  60
    wait until element is visible  //div[@id="kpi5"]  60
    wait until element is visible  //div[@id="kpi6"]  60
    wait until element is visible  //div[@id="kpi7"]  60
    capture page screenshot

Maximize CAMC Window
    maximize browser window

Wait for BH Management Asset Manager Custom KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  7

Add Custom Asset Manager Collection File
    create file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt

Number of Units
    ${AMC_kpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi1}\n

Current Occupancy
    ${AMC_kpi2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi2}\n

Vacant Units
    ${AMC_kpi4} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi4}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi4}\n

Future Occupancy Percentage
    ${AMC_kpi5} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi5}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi5}\n

T13 AVG Occupancy
    ${AMC_kpi6} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi6}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi6}\n

T13 Effective Rent
    ${AMC_kpi7} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi7}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi7}\n

Make Ready %
    ${AMC_kpi8} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${AMC_kpi8}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${AMC_kpi8}\n

Custom Asset Manager Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Custom_Asset_Manager_Custom.txt  Asset Manager Custom


