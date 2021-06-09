*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String
Library  ${EXECDIR}/diff.py
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot

*** Variables ***

${executive_dashboard} =  ${START_URL}/bi/bh-custom-asset-manager-custom/visualization

*** Keywords ***
Rentlytics BH Management Executive KPI Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Executive
    #Maximize Executive Window
    Wait for Executive KPIs
    Add Executive Collection File
    Properties/Units
    Current Occupancy/Future Occupancy %
    #Average Actual Rent/Loss to Lease
    #NOI Budget Variance%/Variance in $
    YOY NOI/^in $
    YOY Potential Rent/^in $
    Executive KPI Difference

Navigate to BH Management Executive
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/overview-executive/visualization
    maximize browser window
    #wait until element is visible  //span[contains(.,'Asset Manager Custom')]  20
    #click element  //span[contains(.,'Asset Manager Custom')]
    #wait until element is visible  //button[contains(.,'Standard (SDS) - Overview')]  20
    #mouse over  //button[contains(.,'Standard (SDS) - Overview')]
    #wait until element is visible  //a[contains(.,'Executive')]  10
    #mouse over  //a[contains(.,'Executive')]
    #click element  //a[contains(.,'Executive')]
    wait until element is visible  //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]  60
    wait until element is visible  //div[@id="chart1"]  60
    wait until element is visible  //div[@id="chart2"]  60
    wait until element is visible  //div[@id="kpi1"]  60
    capture page screenshot



#Maximize Executive Window
    #maximize browser window

Wait for Executive KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5

Add Executive Collection File
    create file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt

Properties/Units
    ${kpi1_1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi1_2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi1_1}
    log  ${kpi1_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi1_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi1_2}\n


Current Occupancy/Future Occupancy %
    ${kpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi2_1}
    log  ${kpi2_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi2_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi2_2}\n


#Average Actual Rent/Loss to Lease
    #${kpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    #${kpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    #log  ${kpi3_1}
    #log  ${kpi3_2}
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt ${kpi3_1}\n
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt ${kpi3_2}\n

#NOI Budget Variance%/Variance in $
    #${kpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    #${kpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    #log  ${kpi4_1}
    #log  ${kpi4_2}
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt ${kpi4_1}\n
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt ${kpi4_2}\n

YOY NOI/^in $
    ${kpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi5_1}
    log  ${kpi5_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi5_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi5_2}\n

YOY Potential Rent/^in $
    ${kpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    ${kpi6_2} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi6_1}
    log  ${kpi6_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi6_1}\n
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi6_2}\n

Expense Ratio
    ${kpi7_1} =      Get Text    //div[@id='kpi7']//div[contains(@class,'rl-primary-kpi-value')]
    #${kpi7_2} =      Get Text    //div[@id='kpi7']//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${kpi7_1}
    #log  ${kpi7_2}
    append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${kpi7_1}\n
    #append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt ${kpi7_2}\n



Executive KPI Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Exe_Value_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Exe_Value_File.txt  Management Executive