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
Rentlytics Winterwood Operations Rent per Sq Ft Has Data
    Run Keyword  User Signin Extended
    Navigate to Winterwood Operations Rent per Sq Ft
    Maximize RPSF Window
    Wait for Operations Rent per Sq Ft KPIs
    Add Operations Rent per Sq Ft KPIs Collection File
    Operations Rent per Sq Ft Occupied SQ FT
    Operations Rent per Sq Ft Avg Actual Rent PSF
    Operations Rent per Sq Ft Most Recent Rents PSF
    Operations Rent per Sq Ft Occupied Market Rent PSF
    Operations Rent per Sq Ft Vacant Market Rent PSF
    Operations Rent per Sq Ft Has Data Diff
    #Operations Rent per Sq Ft Has Data Primary
    #Operations Rent per Sq Ft Has Data Secondary


Navigate to Winterwood Operations Rent per Sq Ft
    go to  https://staging.rentlytics.com/winterwood/bi/operations-rent-per-sq-ft/visualization

Maximize RPSF Window
    maximize browser window

Wait for Operations Rent per Sq Ft KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  2

Add Operations Rent per Sq Ft KPIs Collection File
    create file  HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt



Operations Rent per Sq Ft Occupied SQ FT
    ${RPSFkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${RPSFkpi1}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSFkpi1}\n

Operations Rent per Sq Ft Avg Actual Rent PSF
    ${RPSFkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    ${RPSFkpi2_2} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${RPSFkpi2_1}
    log  ${RPSFkpi2_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSFkpi2_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSFkpi2_2}\n

Operations Rent per Sq Ft Most Recent Rents PSF
    ${RPSFkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    ${RPSFkpi3_2} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${RPSFkpi3_1}
    log  ${RPSFkpi3_2}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSFkpi3_1}\n
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSFkpi3_2}\n


Operations Rent per Sq Ft Occupied Market Rent PSF
    ${RPSFkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${RPSFkpi4_1}
    append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSFkpi4_1}\n


Operations Rent per Sq Ft Vacant Market Rent PSF
    ${OOkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OOkpi5_1}
    append to file  HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${OOkpi5_1}\n


#Operations Rent per Sq Ft Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  5
    #${RPSF_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-valueng-bindiHasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txtng']
    #:FOR  ${RPSF_has_data_primary}  IN   @{RPSF_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${RPSF_has_data_p1}=  element should be visible  ${RPSF_has_data_primary}
    # \       ${RPSF_get_text1}=  get text  ${RPSF_has_data_primary}
    # \       log  ${RPSF_get_text1}
    # \       append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSF_get_text1}\n


#Operations Rent per Sq Ft Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  2
    #${RPSF_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${RPSF_has_data_secondary}  IN   @{RPSF_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${RPSF_has_data_p2}=  element should be visible  ${RPSF_has_data_secondary}
    # \       ${RPSF_get_text2}=  get text  ${RPSF_has_data_secondary}
    # \       log  ${RPSF_get_text2}
    # \       append to file   HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${RPSF_get_text2}\n


Operations Rent per Sq Ft Has Data Diff
    copy file  ./HasDataProd/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${output_dir}/HasDataProd/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt

    copy file  ./HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ${output_dir}/HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt

    diff kpis  ./HasDataProd/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  ./HasDataStage/HasDataWinterwood/Results/Operations_Rent_per_Sq_Ft_KPIs_File.txt  Management Operations Rent per Sq Ft
