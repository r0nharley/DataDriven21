*** Settings ***

Documentation   Library of keywords applicable across Genesis tests that directly imports all the genesis
...             page object resources.
Library         OperatingSystem
Library         Selenium2Library
Library         RequestsLibrary
Resource        PageObjects/PageObjects.robot
Resource        PageObjects/RootPage.robot
Resource        PageObjects/LoginPage.robot
Resource        PageObjects/ExportDatasetPage.robot
Variables       genesis_variables.py


*** Variables ***

${PAGEOBJECTS_ROOT}     ${GENESIS_URL}


*** Keywords ***

Open Browser
    Selenium2Library.open browser  ${GENESIS_URL}  ${BROWSER}
    Selenium2Library.maximize browser window

Open Browser and Login As Staff User
    open browser
    login as staff user

Close Browser
    Selenium2Library.Close Browser

Login As Staff User
    go to page  LoginPage
    enter username  ${STAFF_USERNAME}
    enter password  ${STAFF_PASSWORD}
    submit form
    current page should be  RootPage

Login As Normal User
    go to page  LoginPage
    enter username  ${NON_STAFF_USERNAME}
    enter password  ${NON_STAFF_PASSWORD}
    submit form
    current page should be  LoginPage
