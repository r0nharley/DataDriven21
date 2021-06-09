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
Rentlytics BH Management Finances By Property KPI Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Finances By Property
    Maximize PB Window
    Wait for Finances By Property KPIs
    Add Finances By Property Collection File
    Finances By Property Has Data Primary
    Finances By Property Has Data Secondary
    Finances By Property Difference


Navigate to BH Management Finances By Property
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/finances-by-property/visualization

Maximize PB Window
    maximize browser window

Wait for Finances By Property KPIs
    Sleep  1

Add Finances By Property Collection File
    create file   HasDataStage/HasDataBH/Results/Finances_By_Property_File.txt


Finances By Property Has Data Primary
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  8
    ${PB_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    :FOR  ${PB_has_data_primary}  IN   @{PB_has_data_primary}
     \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     \       ${PB_has_data_p1}=  element should be visible  ${PB_has_data_primary}
     \       ${PB_get_text1}=  get text  ${PB_has_data_primary}
     \       log  ${PB_get_text1}
     \       append to file   HasDataStage/HasDataBH/Results/Finances_By_Property_File.txt  ${PB_get_text1}\n


Finances By Property Has Data Secondary
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  8
    ${PB_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    :FOR  ${PB_has_data_secondary}  IN   @{PB_has_data_secondary}
     \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     \       ${PB_has_data_p2}=  element should be visible  ${PB_has_data_secondary}
     \       ${PB_get_text2}=  get text  ${PB_has_data_secondary}
     \       log  ${PB_get_text2}
     \       append to file   HasDataStage/HasDataBH/Results/Finances_By_Property_File.txt  ${PB_get_text2}\n

Finances By Property Difference
    copy file  ./HasDataProd/HasDataBH/Results/Finances_By_Property_File.txt  ${output_dir}/HasDataProd/HasDataBH/Results/Finances_By_Property_File.txt

    copy file  ./HasDataStage/HasDataBH/Results/Finances_By_Property_File.txt  ${output_dir}/HasDataStage/HasDataBH/Results/Finances_By_Property_File.txt

    diff kpis   ./HasDataProd/HasDataBH/Results/Finances_By_Property_File.txt  ./HasDataStage/HasDataBH/Results/Finances_By_Property_File.txt  Management Finances By Property KPI



