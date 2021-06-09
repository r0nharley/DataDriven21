*** Settings ***

Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String


*** Variables ***
${FILENAME}  Operations_Leases_File
${DASHBOARD_NAME}  Operations Leases


*** Keywords ***
Rentlytics Operations Leases Has Data
    Navigate to Operations Leases
    Maximize MOL Window
    Wait for Operations Leases KPIs
    Add Operations Leases KPIs Collection File
    Operations Leases # Occupied Units
    Operations Leases AVG Months of Tenacy
    Operations Leases AVG Lease Term

    #Operations Leases Has Data Primary
    #Operations Leases Has Data Secondary


Navigate to Operations Leases
    go to  ${START_URL}/bi/operations-leases/visualization


Maximize MOL Window
    maximize browser window


Wait for Operations Leases KPIs
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  3

Add Operations Leases KPIs Collection File
    create file  HasData${ENVIRONMENT}/HasData${ORG_NAME}/Results/${FILENAME}.txt

Operations Leases # Occupied Units
    ${OLkpi1} =      Get Text    //div[@id="kpi1"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi1}
    append to file   HasData${ENVIRONMENT}/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${OLkpi1}\n

Operations Leases AVG Months of Tenacy
    ${OLkpi2_1} =      Get Text    //div[@id="kpi2"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi2_1}
    append to file   HasData${ENVIRONMENT}/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${OLkpi2_1}\n

Operations Leases AVG Lease Term
    ${OLkpi3_1} =      Get Text    //div[@id="kpi3"]//div[contains(@class,'rl-primary-kpi-value')]
    log  ${OLkpi3_1}
    append to file   HasData${ENVIRONMENT}/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${OLkpi3_1}\n

#Operations Leases Has Data Primary
    #wait until keyword succeeds  2 min  3 sec  xpath should match x times  //div[@class='rl-primary-kpi-value']  3
    #${OL_has_data_primary} =  get webelements  xpath=//div[@class='rl-primary-kpi-value']
    #:FOR  ${OL_has_data_primary}  IN   @{OL_has_data_primary}
    # \       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OL_has_data_p1}=  element should be visible  ${OL_has_data_primary}
    # \       ${OL_get_text1}=  get text  ${OL_has_data_primary}
    # \       log  ${OL_get_text1}
    # \       append to file   HasData${ENVIRONMENT}/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${OL_get_text1}\n



#Operations Leases Has Data Secondary

    #${OL_has_data_secondary} =  get webelements  xpath=//div[@class='rl-secondary-kpi-value']
    #:FOR  ${OL_has_data_secondary}  IN   @{OL_has_data_secondary}
    #\       wait until element is visible  xpath=//div[@class='rl-primary-kpi-value']
    # \       ${OL_has_data_p2}=  element should be visible  ${OL_has_data_secondary}
    # \       ${OL_get_text2}=  get text  ${OL_has_data_secondary}
