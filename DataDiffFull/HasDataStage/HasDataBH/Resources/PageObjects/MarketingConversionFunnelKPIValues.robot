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
Rentlytics BH Management Marketing Conversion Funnel Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Marketing Conversion Funnel
    Maximize MCF Window
    Wait for Marketing Conversion Funnel KPIs
    Add Marketing Conversion Funnel Collection File
    Marketing Conversion Funnel Total First Contacts
    Marketing Conversion Funnel Total Apps Submitted
    Marketing Conversion Funnel Total Apps Denied
    Marketing Conversion Funnel Total Apps Cancelled
    Marketing Conversion Funnel Avg Days to Apply
    Marketing Conversion Funnel Has Data Difference





Navigate to BH Management Marketing Conversion Funnel
    go to  https://staging.rentlytics.com/bh-management/bi/marketing-conversion-funnel/visualization

Maximize MCF Window
    maximize browser window

Wait for Marketing Conversion Funnel KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5

Add Marketing Conversion Funnel Collection File
    create file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt

Marketing Conversion Funnel Total First Contacts
    ${MCFkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi2} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi1}
    log  ${MCFkpi2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi2}\n


Marketing Conversion Funnel Total Apps Submitted
    ${MCFkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi2_1}
    log  ${MCFkpi2_2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi2_1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi2_2}\n

Marketing Conversion Funnel Total Apps Denied
    ${MCFkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi3_1}
    log  ${MCFkpi3_2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi3_1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi3_2}\n

Marketing Conversion Funnel Total Apps Cancelled
    ${MCFkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi4_2} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi4_1}
    log  ${MCFkpi4_2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi4_1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi4_2}\n

Marketing Conversion Funnel Avg Days to Apply
    ${MCFkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    ${MCFkpi5_2} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${MCFkpi5_1}
    log  ${MCFkpi5_2}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi5_1}\n
    append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCFkpi5_2}\n

#Marketing Conversion Funnel Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    #${MCF_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${MCF_has_data_primary}  IN   @{MCF_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MCF_has_data_p1}=  element should be visible  ${MCF_has_data_primary}
    # \       ${MCF_get_text1}=  get text  ${MCF_has_data_primary}
    # \       log  ${MCF_get_text1}
    # \       append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCF_get_text1}\n


#Marketing Conversion Funnel Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  5
    #${MCF_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${MCF_has_data_secondary}  IN   @{MCF_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MCF_has_data_p2}=  element should be visible  ${MCF_has_data_secondary}
    # \       ${MCF_get_text2}=  get text  ${MCF_has_data_secondary}
    # \       log  ${MCF_get_text2}
    # \       append to file   HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${MCF_get_text2}\n


Marketing Conversion Funnel Has Data Difference
    copy file  ./HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt

    copy file  ./HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt

    diff kpis   ./HasDataProd/HasDataBH/Results/Marketing_Conversion_Funnel.txt  ./HasDataStage/HasDataBH/Results/Marketing_Conversion_Funnel.txt  Management Marketing Conversion Funnel