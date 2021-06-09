*** Settings ***

Documentation   The page displayed when a json export is complete
Library         RequestsLibrary
Library         Selenium2Library
Library         ${CURDIR}/../OutputManipulatorLibrary.py


*** Variables ***
${body}    //body

*** Keywords ***

Should Be Current Page
    location should be  ${PAGEOBJECTS_ROOT}/repository/export-dataset

Get Body
    run keyword and return  get text  ${body}

Get Body As Json
    ${content}=  get body
    run keyword and return  to json  ${content}
