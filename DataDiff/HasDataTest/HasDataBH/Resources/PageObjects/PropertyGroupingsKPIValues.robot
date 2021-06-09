*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String
Library  ${EXECDIR}/diff.py
Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot

*** Variables ***



*** Keywords ***
Rentlytics BH Management Property Grouping Has Data
    Run Keyword  User Signin Extended
    Navigate to BH Management Property Groupings
    Maximize PG Window
    Wait for Property Grouping KPIs
    Add Property Grouping KPIs Collection File
    Property Grouping Has Data Primary
    Property Grouping Has Data Secondary
    Property Grouping Has Data Difference


Navigate to BH Management Property Groupings
    go to  https://rl-chameleon-test.herokuapp.com/bh-management/bi/overview-property-groupings/visualization

Maximize PG Window
    maximize browser window

Wait for Property Grouping KPIs
    wait until keyword succeeds  2 min  10 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  4

Add Property Grouping KPIs Collection File
    create file   ${output_dir}/HasDataTest/HasDataBH/Results/Property_Grouping_File.txt

Property Grouping Has Data Primary
    ${PG_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    :FOR  ${PG_has_data_primary}  IN   @{PG_has_data_primary}
     \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     \       ${PG_has_data_p1}=  element should be visible  ${PG_has_data_primary}
     \       ${PG_get_text1}=  get text  ${PG_has_data_primary}
     \       log  ${PG_get_text1}
     \       append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Property_Grouping_File.txt  ${PG_get_text1}\n


Property Grouping Has Data Secondary
    wait until keyword succeeds  2 min  10 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  3
    ${PG_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    :FOR  ${PG_has_data_secondary}  IN   @{PG_has_data_secondary}
     \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
     \       ${PG_has_data_p2}=  element should be visible  ${PG_has_data_secondary}
     \       ${PG_get_text2}=  get text  ${PG_has_data_secondary}
     \       log  ${PG_get_text2}
     \       append to file   ${output_dir}/HasDataTest/HasDataBH/Results/Property_Grouping_File.txt  ${PG_get_text2}\n


Property Grouping Has Data Difference
    diff kpis  ./HasDataProd/HasDataBH/Results/Property_Grouping_File.txt  ${output_dir}/HasDataTest/HasDataBH/Results/Property_Grouping_File.txt  Management Property Grouping