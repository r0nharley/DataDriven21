*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics Livcor Cost Analysis Has Data
    Navigate to Livcor Cost Analysis
    Maximize MCA Window
    Wait for Cost Analysis KPIs
    Add Marketing Cost Analysis Collection File
    Marketing Cost Analysis Cost Per Contact
    Marketing Cost Analysis Cost Per Application
    Marketing Cost Analysis Cost Per App Approved
    Marketing Cost Analysis Cost Per Move-In




Navigate to Livcor Cost Analysis
    go to  https://secure.rentlytics.com/livcor/bi/marketing-cost-analysis/visualization


Maximize MCA Window
    maximize browser window

Wait for Cost Analysis KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4

Add Marketing Cost Analysis Collection File
    create file   HasDataProd/HasDataLivcor/Results/Cost_Analysis_KPIs_File.txt

Marketing Cost Analysis Cost Per Contact
    ${MCAkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi1}
    append to file   HasDataProd/HasDataLivcor/Results/Cost_Analysis_KPIs_File.txt  ${MCAkpi1}\n

Marketing Cost Analysis Cost Per Application
    ${MCAkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi2_1}
    append to file   HasDataProd/HasDataLivcor/Results/Cost_Analysis_KPIs_File.txt  ${MCAkpi2_1}\n

Marketing Cost Analysis Cost Per App Approved
    ${MCAkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi3_1}
    append to file   HasDataProd/HasDataLivcor/Results/Cost_Analysis_KPIs_File.txt  ${MCAkpi3_1}\n

Marketing Cost Analysis Cost Per Move-In
    ${MCAkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${MCAkpi4_1}
    append to file   HasDataProd/HasDataLivcor/Results/Cost_Analysis_KPIs_File.txt  ${MCAkpi4_1}\n



#Cost Analysis Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4
    #${MCA_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${MCA_has_data_primary}  IN   @{MCA_has_data_primary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MCA_has_data_p1}=  element should be visible  ${MCA_has_data_primary}
    # \       ${MCA_get_text1}=  get text  ${MCA_has_data_primary}
    # \       log  ${MCA_get_text1}
    # \       append to file   HasDataProd/HasDataLivcor/Results/Cost_Analysis_KPIs_File.txt  ${MCA_get_text1}\n


#Cost Analysis Has Data Secondary

    #${MCA_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${MCA_has_data_secondary}  IN   @{MCA_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${MCA_has_data_p2}=  element should be visible  ${MCA_has_data_secondary}
    # \       ${MCA_get_text2}=  get text  ${MCA_has_data_secondary}
