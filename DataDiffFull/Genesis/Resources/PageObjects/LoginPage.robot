*** Settings ***

Documentation   The genesis login page
Library         Selenium2Library


*** Variables ***

${username_field}   name=username
${password_field}   name=password


*** Keywords ***

Get Page Object Path
    [Return]  /login

Should Be Current Page
    Title Should Be  Rentlytics - Please Login

Enter Username
    [Arguments]  ${user_name}
    input text  ${username_field}  ${user_name}

Enter Password
    [Arguments]  ${password}
    input text  ${password_field}  ${password}

