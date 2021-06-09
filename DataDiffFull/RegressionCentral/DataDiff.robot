*** Settings ***
Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String

Library  ${EXECDIR}/parsers/diff_tsv.py
Library  ${EXECDIR}/settings

*** Variables ***
###
# The following variables MUST be set up before calling this test:
# ${ENVIRONMENT}
# ${ORG_NAME}
# ${START_URL}
# ${DASHBOARD_NAME}
# ${NUM_KPIS}
###


*** Keywords ***
Compare Data ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${ENV1} ${ENV2} ${FILENAME} ${ENV1_PATH} ${ENV2_PATH}
    @{ENV1_INFO} =  Split String  ${ENV1},  separator=-
    @{ENV2_INFO} =  Split String  ${ENV2},  separator=-
    ${ENV1_IS_KNOWNGOOD}=  Run Keyword And Return Status  Should Be Equal As Strings  ${ENV1_INFO[0]}  KnownGood
    ${ENV2_IS_KNOWNGOOD}=  Run Keyword And Return Status  Should Be Equal As Strings  ${ENV2_INFO[0]}  KnownGood
    ${PATH1}=   set variable if  ${ENV1_IS_KNOWNGOOD}  RegressionCentral/KnownGood  ExtractedData
    ${PATH2}=   set variable if  ${ENV2_IS_KNOWNGOOD}  RegressionCentral/KnownGood  ExtractedData
    ${TSV1}=    set variable    ${ENV1_PATH}/${PATH1}/${ENV1}/${ORG_NAME}/${DASHBOARD_NAME}/${DASHBOARD_TYPE}/${FILENAME}
    ${TSV2}=    set variable    ${ENV2_PATH}/${PATH2}/${ENV2}/${ORG_NAME}/${DASHBOARD_NAME}/${DASHBOARD_TYPE}/${FILENAME}
    ${TSV1EXIST}=  run keyword and return status   file should exist  ${TSV1}
    ${TSV2EXIST}=  run keyword and return status   file should exist  ${TSV2}
    Run Keyword Unless  ${TSV1EXIST}  Log To Console  ERROR - Could not find ${TSV1}
    Run Keyword Unless  ${TSV2EXIST}  Log To Console  ERROR - Could not find ${TSV2}
    Run Keyword Unless  ${TSV1EXIST} and ${TSV2EXIST}  Fail
    Run Keyword If  ${TSV1EXIST} and ${TSV2EXIST}   Diff TSV Files  ${TSV1}  ${TSV2}  ${ENV1}  ${ENV2}

Diff TSV Files
    [Arguments]  ${TSV1}  ${TSV2}  ${ENV1}  ${ENV2}
    diff tsvs  ${TSV1}  ${TSV2}  ${ENV1}  ${ENV2}