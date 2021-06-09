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
Rentlytics BH Management Operations Lease Performance Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Operations Lease Performance
    Maximize Window
    Wait for KPIs
    Create KPIs File
    Operations Leases # Occupied Units
    Operations Leases AVG Months of Tenacy
    Operations Leases AVG Lease Term
    Compare KPIs


Navigate to BH Management Operations Lease Performance
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/operations-lease-performance/visualization
    maximize browser window
    #wait until element is visible  //span[contains(.,'Asset Manager Custom')]  20
    #click element  //span[contains(.,'Asset Manager Custom')]
    #wait until element is visible  //button[contains(.,'Standard (ALL) - Operations')]  20
    #mouse over  //button[contains(.,'Standard (ALL) - Operations')]
    #capture page screenshot
    #wait until element is visible  //a[contains(.,'Lease Performance')]  10
    #mouse over  //a[contains(.,'Lease Performance')]
    #capture page screenshot
    #click element  //a[contains(.,'Lease Performance')]
    #capture page screenshot
    wait until element is visible  //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]  60
    wait until element is visible  //div[@id="kpi2"]  60
    wait until element is visible  //div[@id="kpi3"]  60
    wait until element is visible  //div[@id="kpi4"]  60
    capture page screenshot



Maximize Window
    maximize browser window


Wait for KPIs
    sleep  20
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4


Create KPIs File
    create file  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Lease_Performance.txt


Operations Leases # Occupied Units
    ${OLkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Lease_Performance.txt  ${OLkpi1}\n

Operations Leases AVG Months of Tenacy
    ${OLkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi2_1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Lease_Performance.txt  ${OLkpi2_1}\n

Operations Leases AVG Lease Term
    ${OLkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi3_1}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Lease_Performance.txt  ${OLkpi3_1}\n


Compare KPIs
    diff kpis  ./HasDataTest/HasDataBH/Results/Operations_Lease_Performance.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Lease_Performance.txt  Operations Lease Performance