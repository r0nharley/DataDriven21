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
Rentlytics BH Management Operations Single Property Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Operations Single Property
    Maximize OSP Window
    Wait for Operations Single Property KPIs
    Add Operations Single Property KPIs Collection File
    Operations Single Property Has Data Primary
    Operations Single Property Has Data Secondary
    Operations Single Property Has Data Difference


Navigate to BH Management Operations Single Property
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/operations-single-property/visualization

Maximize OSP Window
    maximize browser window

Wait for Operations Single Property KPIs
    sleep  20
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  18

Add Operations Single Property KPIs Collection File
    create file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Single_Property_File.txt


Operations Single Property Has Data Primary
    ${OSP_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    :FOR  ${OSP_has_data_primary}  IN   @{OSP_has_data_primary}
     \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     \       ${OSP_has_data_p1}=  element should be visible  ${OSP_has_data_primary}
     \       ${OSP_get_text1}=  get text  ${OSP_has_data_primary}
     \       log  ${OSP_get_text1}
     \       append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Single_Property_File.txt  ${OSP_get_text1}\n



Operations Single Property Has Data Secondary
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  2
    ${OSP_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    :FOR  ${OSP_has_data_secondary}  IN   @{OSP_has_data_secondary}
     \       wait until element is visible  xpath=//div[@class='rl-secondary-kpi-value']
     \       ${OSP_has_data_p2}=  element should be visible  ${OSP_has_data_secondary}
     \       ${OSP_get_text2}=  get text  ${OSP_has_data_secondary}
     \       log  ${OSP_get_text2}
     \       append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Single_Property_File.txt  ${OSP_get_text2}\n


Operations Single Property Has Data Difference
    diff kpis  ./HasDataTest/HasDataBH/Results/Operations_Single_Property_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Operations_Single_Property_File.txt  Management Operations Single Property