*** Settings ***

Documentation   The Genesis root page
Library         OperatingSystem
Library         Selenium2Library


*** Variables ***

${navbar_brand}                 //a[@class='navbar-brand']
${logout_link}                  //nav//a[@href='/logout']
${organization_dropdown}        //li[@class='dropdown']/a[normalize-space(.//text())='Change Organization']
${organization_selector}        //div[@class='rl-account-list-container']
${upload_form}                  //form[@action='/repository/upload']
${content_file_input}           ${upload_form}//select[@name='content']
${upload_datasource_select}     ${upload_form}//select[@name='datasource']
${export_form}                  //form[@action='/repository/export-dataset']
${export_datasource_select}     ${export_form}//select[@name='datasource']
${format_select}                ${export_form}//select[@name='format']
${start_date_field}             ${export_form}//input[@name='start_date']
${end_date_field}               ${export_form}//input[@name='end_date']

*** Keywords ***

Get Page Object Path
    [Return]  /

Change Organization To
    [Arguments]  ${org_name}
    click link  ${organization_dropdown}
    click link  ${organization_selector}//a[normalize-space(.//text())='${org_name}']
    current organization should be  ${org_name}

Current Organization Should Be
    [Arguments]  ${org_name}
    title should be  ${org_name} - Rentlytics Genesis
    element text should be  ${navbar_brand}  ${org_name}

Datasources Should Be
    [Documentation]     Ensures that the list of available datasources matches what's expected
    [Arguments]         ${datasource_list}
    ${available_list}=  get list items  ${export_datasource_select}
    log many            Expected=${datasource_list}  Actual=${available_list}
    lists should be equal  ${datasource_list}  ${available_list}

Click Logout Link
    click element  ${logout_link}

Export Data
    [Arguments]         ${org_name}  ${datasource_name}  ${exporter_name}  ${start_date}=  ${end_date}=
    set export data source  ${datasource_name}  ${org_name}
    set export type  ${exporter_name}
    set export format  JSON
    run keyword if  $start_date  set start date  ${start_date}
    run keyword if  $end_date  set end date  ${end_date}
    submit export form
    current page should be  ExportDatasetPage
    run keyword and return  get body as json

Choose Upload File
    [Documentation]     Sets the file in the upload form
    [Arguments]         ${path}
    Choose File  ${content_file_input}  ${path}

Set Upload Data Source
    [Documentation]     Selects the specified datasource in the upload form.
    [Arguments]         ${datasource_name}  ${org_name}=
    run keyword if  $org_name  change organization to  ${org_name}
    select from list by label  ${upload_datasource_select}  ${datasource_name} - ${org_name}

Set Export Data Source
    [Documentation]     Selects the specified datasource in the export form.
    [Arguments]         ${datasource_name}  ${org_name}=
    run keyword if  $org_name  change organization to  ${org_name}
    select from list by label  ${export_datasource_select}  ${datasource_name}

Set Export Type
    [Arguments]  ${exporter_name}
    select radio button  exporter  ${exporter_name}

Set Export Format
    [Arguments]  ${format}
    wait until element is visible  ${format_select}
    select from list by label  ${format_select}  ${format}

Set Start Date
    [Arguments]  ${value}
    element should be visible  ${start_date_field}  msg=Start date is not accepted for this export type
    input text  ${start_date_field}  ${value}

Set End Date
    [Arguments]  ${value}
    element should be visible  ${end_date_field}  msg=End date is not accepted for this export type
    input text  ${end_date_field}  ${value}

Submit Export Form
    [Documentation]  Saves the entire web page result to a file
    submit form  ${export_form}
    current page should be  ExportDatasetPage
