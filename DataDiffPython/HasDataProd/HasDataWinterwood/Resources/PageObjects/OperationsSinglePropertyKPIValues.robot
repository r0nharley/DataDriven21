*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***



*** Keywords ***
Rentlytics Winterwood Operations Single Property Has Data
    Navigate to Winterwood Operations Single Property
    Maximize OSP Window
    Wait for Operations Single Property KPIs
    Add Operations Single Property KPIs Collection File
    Operations Single Property # Units
    Operations Single Property Occupancy Percentage
    Operations Single Property Vacant Units
    Operations Single Property Notice Units
    Operations Single Property AVG Actual Rent
    Operations Single Property Vacant Market Rent
    Operations Single Property Loss To Lease
    Operations Single Property Loss To Lease %
    Operations Single Property # Of Delinquent Residents
    Operations Single Property AVG Outstanding Balance
    Operations Single Property Delinquent % of Rent
    Operations Single Property Total Aged Balance
    Operations Single Property Future Occupancy %
    Operations Single Property OEnding Move-Ins
    Operations Single Property NTV Units
    Operations Single Property Rented %
    Operations Single Property Vacant Units 2
    Operations Single Property Current Vacancy Cost
    Operations Single Property AVG Days Vacant
    Operations Single Property Make Ready %
    Operations Single Property AVG Lease Term
    Operations Single Property AVG Months of Tenancy
    #Operations Single Property Has Data Primary
    #Operations Single Property Has Data Secondary


Navigate to Winterwood Operations Single Property
    go to  https://secure.rentlytics.com/winterwood/bi/operations-single-property/visualization


Maximize OSP Window
    maximize browser window

Wait for Operations Single Property KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  22
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  2

Add Operations Single Property KPIs Collection File
    create file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt

Operations Single Property # Units
    ${OSPkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi1}\n

Operations Single Property Occupancy Percentage
    ${OSPkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi2_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi2_1}\n

Operations Single Property Vacant Units
    ${OSPkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi3_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi3_1}\n

Operations Single Property Notice Units
    ${OSPkpi4_1} =      Get Text    //div[@id="kpi4"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi4_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi4_1}\n

Operations Single Property AVG Actual Rent
    ${OSPkpi5_1} =      Get Text    //div[@id="kpi5"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi5_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi5_1}\n

Operations Single Property Vacant Market Rent
    ${OSPkpi6_1} =      Get Text    //div[@id="kpi6"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi6_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi6_1}\n

Operations Single Property Loss To Lease
    ${OSPkpi7_1} =      Get Text    //div[@id="kpi7"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi7_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi7_1}\n

Operations Single Property Loss To Lease %
    ${OSPkpi8_1} =      Get Text    //div[@id="kpi8"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi8_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi8_1}\n

Operations Single Property # Of Delinquent Residents
    ${OSPkpi9_1} =      Get Text    //div[@id="kpi9"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi9_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi9_1}\n

Operations Single Property AVG Outstanding Balance
    ${OSPkpi10_1} =      Get Text    //div[@id="kpi10"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi10_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi10_1}\n

Operations Single Property Delinquent % of Rent
    ${OSPkpi11_1} =      Get Text    //div[@id="kpi11"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi11_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi11_1}\n

Operations Single Property Total Aged Balance
    ${OSPkpi12_1} =      Get Text    //div[@id="kpi12"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi12_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi12_1}\n

Operations Single Property Future Occupancy %
    ${OSPkpi13_1} =      Get Text    //div[@id="kpi13"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi13_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi13_1}\n

Operations Single Property OEnding Move-Ins
    ${OSPkpi14_1} =      Get Text    //div[@id="kpi14"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi14_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi14_1}\n


Operations Single Property NTV Units
    ${OSPkpi15_1} =      Get Text    //div[@id="kpi15"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi15_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi15_1}\n

Operations Single Property Rented %
    ${OSPkpi16_1} =      Get Text    //div[@id="kpi16"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi16_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi16_1}\n

Operations Single Property Vacant Units 2
    ${OSPkpi17_1} =      Get Text    //div[@id="kpi17"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi17_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi17_1}\n

Operations Single Property Current Vacancy Cost
    ${OSPkpi18_1} =      Get Text    //div[@id="kpi18"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi18_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi18_1}\n

Operations Single Property AVG Days Vacant
    ${OSPkpi19_1} =      Get Text    //div[@id="kpi19"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OSPkpi19_2} =      Get Text    //div[@id="kpi19"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OSPkpi19_1}
    log  ${OSPkpi19_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi19_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi19_2}\n

Operations Single Property Make Ready %
    ${OSPkpi20_1} =      Get Text    //div[@id="kpi20"]//div[contains(@class,'rl-primary-kpi-value')]
    ${OSPkpi20_2} =      Get Text    //div[@id="kpi20"]//div[contains(@class,'rl-secondary-kpi-value')]
    log  ${OSPkpi20_1}
    log  ${OSPkpi20_2}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi20_1}\n
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi20_2}\n

Operations Single Property AVG Lease Term
    ${OSPkpi21_1} =      Get Text    //div[@id="kpi21"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi21_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi21_1}\n

Operations Single Property AVG Months of Tenancy
    ${OSPkpi22_1} =      Get Text    //div[@id="kpi22"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OSPkpi22_1}
    append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSPkpi22_1}\n







#Operations Single Property Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  22
    #${OSP_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OSP_has_data_primary}  IN   @{OSP_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OSP_has_data_p1}=  element should be visible  ${OSP_has_data_primary}
    # \       ${OSP_get_text1}=  get text  ${OSP_has_data_primary}
    # \       log  ${OSP_get_text1}
    # \       append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSP_get_text1}\n



#Operations Single Property Has Data Secondary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-secondary-kpi-value']  2
    #${OSP_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${OSP_has_data_secondary}  IN   @{OSP_has_data_secondary}
    # \       wait until element is visible  xpath=//div[@class='rl-secondary-kpi-value']
    # \       ${OSP_has_data_p2}=  element should be visible  ${OSP_has_data_secondary}
    # \       ${OSP_get_text2}=  get text  ${OSP_has_data_secondary}
    # \       log  ${OSP_get_text2}
    # \       append to file   HasDataProd/HasDataWinterwood/Results/Operations_Single_Property_KPIs_File.txt  ${OSP_get_text2}\n
