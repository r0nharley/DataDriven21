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
Rentlytics BH Management Marketing Traffic Counts Has Data
    Run Keyword  Rentlytics User Signin Extended
    Navigate to BH Management Marketing Traffic Counts
    Maximize MTC Window
    Wait for Marketing Traffic Counts KPIs
    Add Marketing Traffic Counts KPIs Collection File
    Marketing Traffic Counts First Contacts
    Marketing Traffic Counts Shows
    Marketing Traffic Counts Apps Submitted
    Marketing Traffic Counts Apps Approved
    Marketing Traffic Counts Move-Ins
    Marketing Traffic Counts Has Data Difference


    #Marketing Traffic Counts Has Data Primary
    #Marketing Traffic Counts Has Data Secondary


Navigate to BH Management Marketing Traffic Counts
    go to  https://staging.rentlytics.com/bh-management/bi/marketing-traffic-counts/visualization

Maximize MTC Window
    maximize browser window

Wait for Marketing Traffic Counts KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5

Add Marketing Traffic Counts KPIs Collection File
    create file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt

Marketing Traffic Counts First Contacts
    ${MTCkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MTCkpi1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${MTCkpi1}\n

Marketing Traffic Counts Shows
    ${MTCkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MTCkpi2_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${MTCkpi2_1}\n

Marketing Traffic Counts Apps Submitted
    ${MTCkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MTCkpi3_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${MTCkpi3_1}\n

Marketing Traffic Counts Apps Approved
    ${MTCkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MTCkpi4_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${MTCkpi4_1}\n

Marketing Traffic Counts Move-Ins
    ${MTCkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MTCkpi5_1}
    append to file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${MTCkpi5_1}\n



#Marketing Traffic Counts Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    #${MTC_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${MTC_has_data_primary}  IN   @{MTC_has_data_primary}
     #\       wait until element is visible  ${MTC_has_data_primary}
     #\       ${MTC_has_data_p1}=  element should be visible  ${MTC_has_data_primary}
     #\       ${MTC_get_text1}=  get text  ${MTC_has_data_primary}
     #\       log  ${MTC_get_text1}
     #\       append to file   HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${MTC_get_text1}\n


#Marketing Traffic Counts Has Data Secondary

    #${MTC_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${MTC_has_data_secondary}  IN   @{MTC_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MTC_has_data_p2}=  element should be visible  ${MTC_has_data_secondary}
    # \       ${MTC_get_text2}=  get text  ${MTC_has_data_secondary}


Marketing Traffic Counts Has Data Difference
    copy file  ./HasDataProd/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Marketing_Traffic_Counts.txt

    copy file  ./HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt

    diff kpis  ./HasDataProd/HasDataBH/Results/Marketing_Traffic_Counts.txt  ./HasDataStage/HasDataBH/Results/Marketing_Traffic_Counts.txt  Management Marketing Traffic Counts