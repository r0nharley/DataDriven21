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
Rentlytics BH Management Operations Rent per Sq Ft Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Operations Rent per Sq Ft
    Maximize RPSF Window
    Wait for Operations Rent per Sq Ft KPIs
    Add Operations Rent per Sq Ft KPIs Collection File
    Operations Rent per Sq Ft Occupied SQ FT
    Operations Rent per Sq Ft Avg Actual Rent PSF
    Operations Rent per Sq Ft Most Recent Rents PSF
    Operations Rent per Sq Ft Occupied Market Rent PSF
    Operations Rent per Sq Ft Vacant Market Rent PSF
    Operations Rent per Sq Ft Has Data Difference


Navigate to BH Management Operations Rent per Sq Ft
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/operations-rent-per-sq-ft/visualization
    maximize browser window
    #wait until element is visible  //span[contains(.,'Asset Manager Custom')]  20
    #click element  //span[contains(.,'Asset Manager Custom')]
    #wait until element is visible  //button[contains(.,'Standard (ALL) - Operations')]  20
    #mouse over  //button[contains(.,'Standard (ALL) - Operations')]
    #capture page screenshot
    #wait until element is visible  //a[contains(.,'Rent per Sq Ft')]  10
    #mouse over  //a[contains(.,'Rent per Sq Ft')]
    #capture page screenshot
    #click element  //a[contains(.,'Rent per Sq Ft')]
    #capture page screenshot
    wait until element is visible  //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]  60
    wait until element is visible  //div[@id="kpi2"]  60
    wait until element is visible  //div[@id="kpi3"]  60
    wait until element is visible  //div[@id="kpi4"]  60
    wait until element is visible  //div[@id="kpi5"]  60
    capture page screenshot

Maximize RPSF Window
    maximize browser window

Wait for Operations Rent per Sq Ft KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5

Add Operations Rent per Sq Ft KPIs Collection File
    create file  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt

Operations Rent per Sq Ft Occupied SQ FT
    ${RPSFkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${RPSFkpi1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${RPSFkpi1}\n

Operations Rent per Sq Ft Avg Actual Rent PSF
    ${RPSFkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${RPSFkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${RPSFkpi2_1}
    log  ${RPSFkpi2_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${RPSFkpi2_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${RPSFkpi2_2}\n

Operations Rent per Sq Ft Most Recent Rents PSF
    ${RPSFkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${RPSFkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${RPSFkpi3_1}
    log  ${RPSFkpi3_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${RPSFkpi3_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${RPSFkpi3_2}\n


Operations Rent per Sq Ft Occupied Market Rent PSF
    ${RPSFkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${RPSFkpi4_1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${RPSFkpi4_1}\n


Operations Rent per Sq Ft Vacant Market Rent PSF
    ${OOkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi5_1}
    append to file  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${OOkpi5_1}\n

Operations Rent per Sq Ft Has Data Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_RentperSQFT_File.txt  Management Operations Rent per Sq Ft