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
Rentlytics BH Management Cost Analysis Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Cost Analysis
    Maximize MCA Window
    Wait for Cost Analysis KPIs
    Add Marketing Cost Analysis Collection File
    Marketing Cost Analysis Cost Per Contact
    Marketing Cost Analysis Cost Per Application
    Marketing Cost Analysis Cost Per App Approved
    Marketing Cost Analysis Cost Per Move-In
    Cost Analysis Has Data Difference




Navigate to BH Management Cost Analysis
    go to  https://staging.rentlytics.com/bh-management/bi/marketing-cost-analysis/visualization

Maximize MCA Window
    maximize browser window

Wait for Cost Analysis KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4

Add Marketing Cost Analysis Collection File
    create file   HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt

Marketing Cost Analysis Cost Per Contact
    ${MCAkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi1}\n

Marketing Cost Analysis Cost Per Application
    ${MCAkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi2_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi2_1}\n

Marketing Cost Analysis Cost Per App Approved
    ${MCAkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi3_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi3_1}\n

Marketing Cost Analysis Cost Per Move-In
    ${MCAkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi4_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCAkpi4_1}\n

#Cost Analysis Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    #${MCA_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${MCA_has_data_primary}  IN   @{MCA_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MCA_has_data_p1}=  element should be visible  ${MCA_has_data_primary}
    # \       ${MCA_get_text1}=  get text  ${MCA_has_data_primary}
    # \       log  ${MCA_get_text1}
    # \       append to file   HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${MCA_get_text1}\n

Cost Analysis Has Data Difference
    copy file  ./HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt

    copy file  ./HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt

    diff kpis   ./HasDataProd/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  ./HasDataStage/HasDataBH/Results/Marketing_Cost_Analysis_Results.txt  Management Cost Analysis
