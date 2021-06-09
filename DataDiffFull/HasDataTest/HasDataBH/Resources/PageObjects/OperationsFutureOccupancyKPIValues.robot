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
    Run Keyword  User Signin Extended
    Navigate to BH Management Operations Future Occupancy
    Maximize OFO Window
    Wait for Operations Future Occupancy KPIs
    Add Operations Future Occupancy KPIs Collection File
    Operations Current Occupancy %
    Operations Future Occupancy %
    Operations # Vacant Units
    Operations # NTV Units
    Operations Future Occupancy Has Data Difference


Navigate to BH Management Operations Future Occupancy
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/operations-future-occupancy/visualization
    maximize browser window
    #wait until element is visible  //span[contains(.,'Asset Manager Custom')]  20
    #click element  //span[contains(.,'Asset Manager Custom')]
    #wait until element is visible  //button[contains(.,'Standard (ALL) - Operations')]  20
    #mouse over  //button[contains(.,'Standard (ALL) - Operations')]
    #capture page screenshot
    #wait until element is visible  //a[contains(.,'Future Occupancy')]  10
    #mouse over  //a[contains(.,'Future Occupancy')]
    #capture page screenshot
    #click element  //a[contains(.,'Future Occupancy')]
    #capture page screenshot
    wait until element is visible  //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]  60
    wait until element is visible  //div[@id="chart1"]  60
    wait until element is visible  //div[@id="chart2"]  60
    wait until element is visible  //div[@id="kpi2"]  60
    wait until element is visible  //div[@id="kpi3"]  60
    wait until element is visible  //div[@id="kpi4"]  60
    capture page screenshot

Maximize OFO Window
    maximize browser window

Wait for Operations Future Occupancy KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4

Add Operations Future Occupancy KPIs Collection File
    create file  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt

Operations Current Occupancy %
    ${OFOkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi1}
    log  ${OFOkpi2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi2}\n

Operations Future Occupancy %
    ${OFOkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi2_1}
    log  ${OFOkpi2_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi2_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi2_2}\n

Operations # Vacant Units
    ${OFOkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi3_1}
    log  ${OFOkpi3_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi3_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi3_2}\n

Operations # NTV Units
    ${OFOkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OFOkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OFOkpi4_1}
    log  ${OFOkpi4_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi4_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${OFOkpi4_2}\n


Operations Future Occupancy Has Data Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_FutureOccupancy_File.txt  Management Operations Future Occupancy