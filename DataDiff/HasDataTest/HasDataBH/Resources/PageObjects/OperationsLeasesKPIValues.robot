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
Rentlytics BH Management Operations Leases Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Operations Leases
    Maximize OL Window
    Wait for Operations Leases KPIs
    Add Operations Leases KPIs Collection File
    Operations Leases Has Data Primary
    Operations Leases Has Data Difference


Navigate to BH Management Operations Leases
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/operations-leases/visualization

Maximize OL Window
    maximize browser window

Wait for Operations Leases KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  3

Add Operations Leases KPIs Collection File
    create file  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Leases_File.txt

Operations Leases Has Data Primary
    ${OL_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    :FOR  ${OL_has_data_primary}  IN   @{OL_has_data_primary}
     \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     \       ${OL_has_data_p1}=  element should be visible  ${OL_has_data_primary}
     \       ${OL_get_text1}=  get text  ${OL_has_data_primary}
     \       log  ${OL_get_text1}
     \       append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Leases_File.txt  ${OL_get_text1}\n


Operations Leases Has Data Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Operations_Leases_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Leases_File.txt  Management Operations Leases