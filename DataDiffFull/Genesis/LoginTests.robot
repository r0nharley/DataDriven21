*** Settings ***

Documentation   Genesis Login Test Suite
Resource        Resources/GenesisApp.robot
Suite Setup     Open Browser
Test Setup      Go To Page  LoginPage
Suite Teardown  Close Browser


*** Test Cases ***

Staff User Can Log In
    login as staff user
    current page should be  RootPage

Staff User Can Log Out
    login as staff user
    click logout link
    current page should be  LoginPage

Non Staff User Cannot Log In
    [Documentation]     Non-staff users are redirected back to login page with a next=/ query parameter
    Login As Normal User
    ${next}=  RootPage.Get Page Object Path
    Current Page Should Be  LoginPage  ?next=${next}
