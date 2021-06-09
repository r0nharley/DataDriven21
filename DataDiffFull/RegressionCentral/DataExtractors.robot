*** Settings ***
Library  Selenium2Library
Library  Process
Library  OperatingSystem
Library  String

Library  ${EXECDIR}/parsers/robot_framework_commands.py

Resource  ${EXECDIR}/RegressionCentral/SignInTest.robot
Resource  ${EXECDIR}/RegressionCentral/BubbleChartParser.robot

Documentation
...     Widget data extractors
...
...     Extract widget values from a given dashboard, organization and environment
...     Write the extracted values to a result file

*** Variables ***
###
# The following variables MUST be set up before calling this test:
# ${ENVIRONMENT}
# ${ORG_NAME}
# ${START_URL}
###
${emailfield} =  name=email

*** Keywords ***
Extract Data
    [Arguments]  ${DASHBOARD_NAME}  ${DASHBOARD_SLUG}  ${DASHBOARD_TYPE}  ${DASHBOARD_QUERYSTRING}  ${NUM_KPIS}  ${NUM_CHARTS}  ${NUM_TABLES}  ${CHARTS_SORT_ITEMS}  ${TABLES_SORT_ITEMS}
    Run Keyword And Continue On Failure  Extract All Data  ${DASHBOARD_NAME}  ${DASHBOARD_SLUG}  ${DASHBOARD_TYPE}  ${DASHBOARD_QUERYSTRING}  ${NUM_KPIS}  ${NUM_CHARTS}  ${NUM_TABLES}  ${CHARTS_SORT_ITEMS}  ${TABLES_SORT_ITEMS}


Extract All Data
    [Arguments]  ${DASHBOARD_NAME}  ${DASHBOARD_SLUG}  ${DASHBOARD_TYPE}  ${DASHBOARD_QUERYSTRING}  ${NUM_KPIS}  ${NUM_CHARTS}  ${NUM_TABLES}  ${CHARTS_SORT_ITEMS}  ${TABLES_SORT_ITEMS}
    Set Test Variable  ${DASHBOARD_OUTPUT}  ${EXECDIR}/ExtractedData/${ENVIRONMENT}/${ORG_NAME}/${DASHBOARD_NAME}/${DASHBOARD_TYPE}
    Go To Dashboard ${DASHBOARD_SLUG} ${DASHBOARD_TYPE} ${DASHBOARD_QUERYSTRING}
    Set Window Size  3000  2000
    Check Signed In
    Wait Until Keyword Succeeds  2 min  0 sec  xpath should match x times  //div[contains(@class,'rl-kpi')]//div[contains(@class,'rl-primary-kpi-value') or contains(@class,'rl-no-data')]  ${NUM_KPIS}
    Wait Until Keyword Succeeds  2 min  0 sec  xpath should match x times  //div[contains(@class,'rl-chart')]//div[contains(@class,'highcharts-container') or contains(@class,'rl-no-data')]  ${NUM_CHARTS}
    Wait Until Keyword Succeeds  2 min  0 sec  xpath should match x times  //div[contains(@class,'rl-table')]//div[contains(@class,'rl-table-container') or contains(@class,'rl-no-data')]  ${NUM_TABLES}
    Create Directory  ${DASHBOARD_OUTPUT}
    Extract KPI Data ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${NUM_KPIS}
    Extract Chart Data  ${NUM_CHARTS}  ${CHARTS_SORT_ITEMS}
    Extract Table Data  ${NUM_TABLES}  ${TABLES_SORT_ITEMS}


Go To Dashboard ${DASHBOARD_SLUG} ${DASHBOARD_TYPE} ${DASHBOARD_QUERYSTRING}
    ${is_beta_dashboard} =  Run Keyword And Return Status  Should Contain  ${DASHBOARD_SLUG}  beta
    Run Keyword If  ${is_beta_dashboard}  Log To Console  Extracting from ${START_URL}/bi/${DASHBOARD_SLUG}/${DASHBOARD_TYPE}/beta
    Run Keyword If  ${is_beta_dashboard}  Go To  ${START_URL}/bi/${DASHBOARD_SLUG}/${DASHBOARD_TYPE}/beta${DASHBOARD_QUERYSTRING}
    Run Keyword Unless  ${is_beta_dashboard}  Go To  ${START_URL}/bi/${DASHBOARD_SLUG}/${DASHBOARD_TYPE}${DASHBOARD_QUERYSTRING}
    Run Keyword Unless  ${is_beta_dashboard}  Log To Console  Extracting from ${START_URL}/bi/${DASHBOARD_SLUG}/${DASHBOARD_TYPE}


Check Signed In
    Register Keyword To Run On Failure  No Operation
    ${is_logged_out} =  Run Keyword And Return Status  Element Should Be Visible  ${emailfield}
    Run Keyword If  ${is_logged_out}  SignInTest.Signin In Place


Extract KPI Data ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${NUM_KPIS}
    [Documentation]  Loops over all KPIs present on the dashboard and extract the primary value and secondary value (if any)
    ${KPIS_OUTPUT} =  Set Variable  ${DASHBOARD_OUTPUT}/kpis.tsv
    Create File  ${KPIS_OUTPUT}
    :FOR    ${INDEX}    IN RANGE  1  ${NUM_KPIS}+1
    \   Record KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} primary ${KPIS_OUTPUT}
    \   Record KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} secondary ${KPIS_OUTPUT}


Record KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT}
    [Documentation]  Check if a primary or secondary KPI value is available or not, and log the result to the output file
    ${is_kpi_value}  Run Keyword And Return Status  Element Should Be Visible  //div[@id="kpi${INDEX}"]//div[contains(@class,'rl-${TYPE}-kpi-value')]
    Run Keyword If  ${is_kpi_value}  Output KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT}
    Run Keyword Unless  ${is_kpi_value}  Output No KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT}


Output KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT}
    [Documentation]  Output a primary or secondary KPI value to the KPI output file
    ${VALUE} =  Get Text  //div[@id="kpi${INDEX}"]//div[contains(@class,'rl-${TYPE}-kpi-value')]
    Append KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT} ${VALUE}


Output No KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT}
    [Documentation]  Output a primary or secondary KPI value to the KPI output file when there is no value
    ${VALUE} =  Set Variable    NO_VALUE
    Append KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT} ${VALUE}


Append KPI Value ${DASHBOARD_NAME} ${DASHBOARD_TYPE} ${INDEX} ${TYPE} ${KPIS_OUTPUT} ${VALUE}
    [Documentation]  Append the KPI value to the extracted data tsv
    ${widget_titles_json}=  Get file  ${EXECDIR}/Resources/Mappings/dashboards_widgets.json
    ${widget_titles}=  Evaluate  json.loads(r'''${widget_titles_json}''')  json
    ${kpi_title_index}=  Evaluate  ${INDEX} - 1
    Append to File  ${KPIS_OUTPUT}  kpi${INDEX}:${widget_titles["${DASHBOARD_NAME}"]["${DASHBOARD_TYPE}"]["kpis"][${kpi_title_index}]}\t
    Append to File  ${KPIS_OUTPUT}  ${TYPE}\t
    Append To File  ${KPIS_OUTPUT}  ${VALUE}\n


Extract Chart Data
    [Arguments]  ${NUM_CHARTS}  ${CHARTS_SORT_ITEMS}
    [Documentation]  Loops over all charts present on the dashboard and generate a tsv file per chart
    :FOR    ${INDEX}    IN RANGE  0  ${NUM_CHARTS}
    \   Record Chart Value ${INDEX} @{CHARTS_SORT_ITEMS}[${INDEX}]


Record Chart Value ${INDEX} ${CHART_SORT_ITEM}
    [Documentation]  Output the result of the chart parser to a TSV file
    ${chart_suffix} =  Evaluate  ${INDEX} + 1
    ${chart_output} =  Set Variable  ${DASHBOARD_OUTPUT}/chart${chart_suffix}.tsv
    Create File  ${chart_output}
    Set Test Variable  ${chart_xpath}  //div[@id="chart${chart_suffix}"]
    ${chart_class}  Get Element Attribute  xpath=${chart_xpath}@class
    ${is_bubble_chart} =  Run Keyword And Return Status  Should Contain  ${chart_class}  chart-bubble
    Run Keyword If  ${is_bubble_chart}  BubbleChartParser.Parse Bubble Chart ${chart_xpath} ${chart_output}
    Run Keyword Unless  ${is_bubble_chart}  Parse Chart ${chart_xpath} ${chart_output} ${CHART_SORT_ITEM}


Parse Chart ${WEB_ELEMENT_XPATH} ${CHART_OUTPUT} ${CHART_SORT_ITEM}
    ${web_element} =  Get Webelement  ${WEB_ELEMENT_XPATH}
    ${parsed_chart} =  parse chart  ${web_element}  ${CHART_SORT_ITEM}
    Append To File  ${CHART_OUTPUT}  ${parsed_chart}


Extract Table Data
    [Arguments]  ${NUM_TABLES}  ${TABLES_SORT_ITEMS}
    [Documentation]  Loops over all tables present on the dashboard and generate a tsv file per table
    :FOR    ${INDEX}    IN RANGE  0  ${NUM_TABLES}
    \   Record Table Value ${INDEX} @{TABLES_SORT_ITEMS}[${INDEX}]


Record Table Value ${INDEX} ${TABLE_SORT_ITEM}
    [Documentation]  Output the result of the table parser to a TSV file
    ${table_suffix} =  Evaluate  ${INDEX} + 1
    ${table_output} =  Set Variable  ${DASHBOARD_OUTPUT}/table${table_suffix}.tsv
    Create File  ${table_output}
    ${web_element} =  Get Webelement  //div[@id="table${table_suffix}"]
    ${parsed_table} =  parse table  ${web_element}  ${TABLE_SORT_ITEM}
    Append To File  ${table_output}  ${parsed_table}