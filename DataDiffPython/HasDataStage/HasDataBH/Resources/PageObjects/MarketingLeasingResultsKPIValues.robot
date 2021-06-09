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
Rentlytics BH Management Marketing Leasing Results Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Marketing Leasing Results
    Maximize MML Window
    Wait for Marketing Leasing Results KPIs
    Add Marketing Leasing Results Collection File
    Marketing Leasing Results Total First Contacts
    Marketing Leasing Results Move-In Percentage
    Marketing Leasing Results Total AVG Lease Rent
    Marketing Leasing Results Last 30 Days Lease Rent
    Marketing Leasing Results Has Data Difference



Navigate to BH Management Marketing Leasing Results
    go to  https://staging.rentlytics.com/bh-management/bi/marketing-leasing-results/visualization

Maximize MML Window
    maximize browser window

Wait for Marketing Leasing Results KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3

Add Marketing Leasing Results Collection File
    create file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt

Marketing Leasing Results Total First Contacts
    ${MLRkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MLRkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MLRkpi1}
    log  ${MLRkpi2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi2}\n

Marketing Leasing Results Move-In Percentage
    ${MLRkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MLRkpi2_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi2_1}\n

Marketing Leasing Results Total AVG Lease Rent
    ${MLRkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MLRkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MLRkpi3_1}
    log  ${MLRkpi3_2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi3_1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi3_2}\n

Marketing Leasing Results Last 30 Days Lease Rent
    ${MLRkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MLRkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MLRkpi4_1}
    log  ${MLRkpi4_2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi4_1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLRkpi4_2}\n

#Marketing Leasing Results Has Data Primary
   # wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
   # ${MLR_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
   # :FOR  ${MLR_has_data_primary}  IN   @{MLR_has_data_primary}
   #  \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
   #  \       ${MLR_has_data_p1}=  element should be visible  ${MLR_has_data_primary}
   #  \       ${MLR_get_text1}=  get text  ${MLR_has_data_primary}
   #  \       log  ${MLR_get_text1}
   #  \       append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLR_get_text1}\n


#Marketing Leasing Results Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3
    #${MLR_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${MLR_has_data_secondary}  IN   @{MLR_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MLR_has_data_p2}=  element should be visible  ${MLR_has_data_secondary}
    # \       ${MLR_get_text2}=  get text  ${MLR_has_data_secondary}
    # \       log  ${MLR_get_text2}
    # \       append to file   HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${MLR_get_text2}\n


Marketing Leasing Results Has Data Difference
    copy file  ./HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt

    copy file  ./HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt

    diff kpis  ./HasDataProd/HasDataBH/Results/Marketing_Leasing_Results.txt  ./HasDataStage/HasDataBH/Results/Marketing_Leasing_Results.txt  Management Marketing Leasing Results