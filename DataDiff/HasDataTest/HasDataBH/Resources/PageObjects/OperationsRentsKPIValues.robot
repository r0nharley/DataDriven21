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
Rentlytics BH Management Operations Rents Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Operations Rents
    Maximize OR Window
    Wait for Operations Rents KPIs
    Add Operations Rents KPIs Collection File
    Operations Rents # Occupied Units
    #Operations Rents AVG Actual Rent
    Operations Rents AVG Rent PSF
    #Operations Rents Most Recent Rents
    Operations Rents Occupied Market Rent
    Operations Rents Vacant Market Rent
    Operations Rents Has Data Difference



Navigate to BH Management Operations Rents
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/operations-rents/visualization
    maximize browser window
    #wait until element is visible  //span[contains(.,'Asset Manager Custom')]  20
    #click element  //span[contains(.,'Asset Manager Custom')]
    #wait until element is visible  //button[contains(.,'Standard (ALL) - Operations')]  20
    #mouse over  //button[contains(.,'Standard (ALL) - Operations')]
    #wait until element is visible  //a[contains(.,'Rents')]  10
    #mouse over  //a[contains(.,'Rents')]
    #click element  //a[contains(.,'Rents')]
    wait until element is visible  //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]  60
    wait until element is visible  //div[@id="chart1"]  60
    wait until element is visible  //div[@id="chart2"]  60
    wait until element is visible  //div[@id="kpi3"]  60
    capture page screenshot

Maximize OR Window
    maximize browser window

Wait for Operations Rents KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4

Add Operations Rents KPIs Collection File
    create file  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt

Operations Rents # Occupied Units
    ${ORkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ORkpi1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi1}\n

#Operations Rents AVG Actual Rent
    #${ORkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    #${ORkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    #log  ${ORkpi2_1}
    #log  ${ORkpi2_2}
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi2_1}\n
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi2_2}\n

Operations Rents AVG Rent PSF
    ${ORkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${ORkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${ORkpi3_1}
    log  ${ORkpi3_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi3_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi3_2}\n


#Operations Rents Most Recent Rents
    #${ORkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    #${ORkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    #log  ${ORkpi4_1}
    #log  ${ORkpi4_2}
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi4_1}\n
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi4_2}\n


Operations Rents Occupied Market Rent
    ${ORkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ORkpi5_1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi5_1}\n

Operations Rents Vacant Market Rent
    ${ORkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${ORkpi6_1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${ORkpi6_1}\n

Operations Rents Has Data Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Rents_File.txt  Management Operations Rents