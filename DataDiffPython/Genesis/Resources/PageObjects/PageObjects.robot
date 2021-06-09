*** Settings ***

Documentation   Provides keywords for faking a resource-file-as-a-page-object pattern. See below for usage information
...             and rationale behind the page object pattern.
Library         Selenium2Library


*** Keywords ***

Go To Page
    [Documentation]     Go to the page object specified by the resource name, test that we got there, and put that
    ...                 resource name at the top of the library search order so that name resolution isn't an issue.
    [Arguments]         ${resource_name}  ${skip_test}=False
    keyword should exist  ${resource_name}.Get Page Object Path
    ...                   msg="Get Path for Page" keyword must be implemented to use the "Go To Page" keyword
    ${path}=  get path for page  ${resource_name}
    Selenium2Library.go to  ${path}
    run keyword unless  ${skip_test}
    ...     current page should be  ${resource_name}

Current Page Should Be
    [Documentation]     Test that the page object specified by the resource name is the current page, and put that
    ...                 resource name at the top of the library search order so that name resolution isn't an issue.
    [Arguments]         ${resource_name}  ${query}=
    ${defined}=  run keyword and return status
    ...          keyword should exist  ${resource_name}.should be current page
    run keyword if  $defined
    ...             ${resource_name}.should be current page
    ...       ELSE  PageObjects.should be current page  ${resource_name}  ${query}
    set library search order  PageObjects  ${resource_name}

#   Abstract:
#       Implement page object pattern in robot framework by creating one XxxxPage.robot file per page that allows user
#       interactions so tests can be loosely coupled and not make direct use of the Selenium2Library.
#
#   Usage:
#       Create one robot file per page object, the name typically ends with Page. Implement the keyword(s) described
#       below.
#
#   Required Variables:
#       ${PAGEOBJECTS_ROOT}:
#           This is the root URL to all page object pages, and page objects will not function correctly unless this is
#           defined before page object keywords are executed.
#
#   Implementing Page Objects:
#       * Page object resources *MAY* implement:
#           Get Page Object Path
#               This keyword must return the relative path from ${PAGEOBJECT_ROOT} to go to when the `Go To Page`
#               keyword is executed.  If this keyword is not present, the `Go To Page` keyword will throw an exception.
#
#           Should Be Current Page
#               If this keyword is present, it should test that the browser in on the expected page for your pageobject.
#               If it is not implemented, then the `Current Page Should Be` keyword in this module will ensure that the
#               browser's URL matches the following:
#                   ${PAGEOBJECTS_ROOT} + `Get Page Object Path` + ${query}
#
#   Exposed Keywords:
#       * Go To Page
#           [Arguments]  ${resource_name}
#               Accepts the resource name as a parameter, sends the browser to that page, and sets the resource
#               resolution order so that there is no need to do `NameSpace.My Keyword` style nonsense inside your tests.
#       * Current Page Should Be
#           [Arguments]  ${resource_name}
#               Accepts the resource name as a parameter, calls your page object's `Should Be Current Page` keyword, if
#               implemented; or it ensures that the browser URL matches what it should be based on your page object's
#               `Get Page Object Path`.
#
#   Reasoning:
#       Without page objects, your test files end up being tightly coupled, somewhat like the following, or worse, your
#       test files don't contain any logic at all but each "Test" is a single-line call to a keyword that does the test
#       and that keyword is still tightly coupled, like this:
#       ----------------------------------------------------------------------------------------------------------------
#       *** Settings ***
#       Library                 Selenium2Library
#       Test Setup              Open Browser  about:blank  ${BROWSER}
#       Test Teardown           Close Browser
#
#       *** Variables ***
#       ${BROWSER}              chrome
#       ${ROOT_URL}             http://nealpert.net
#       ${LOGIN_URL}            ${ROOT_URL}/login
#       ${MAIN_URL}             ${ROOT_URL}/main
#       ${VALID_USERNAME}       neil@neilpeart.net
#       ${VALID_PASSWORD}       DrUmm3rsRUL#Z
#       ${INVALID_USERNAME}     dummy@google.com
#       ${INVALID_PASSWORD}     dum-drummer
#       ${TITLE_TEXT}           Welcome to the official website of Neil Peart
#       ${FAILED_LOGIN_TEXT}    Unknown username and/or password
#       ${USERNAME_INPUT}       input[@id='username']
#       ${PASSWORD_INPUT}       input[@id='password']
#       ${SUBMIT_BUTTON}        input[@type='submit']
#
#       *** Tests ***
#       Valid User Can Log In
#           Go To  ${LOGIN_URL}
#           Title Should Be  ${TITLE_TEXT}
#           Input Text  ${username_input}  ${VALID_USERNAME}
#           Input Text  ${password_input}  ${VALID_PASSWORD}
#           Click Button  ${SUBMIT_BUTTON}
#           URL Should Be  ${MAIN_URL}
#
#       Invalid User Cannot Log In
#           Go To  ${LOGIN_URL}
#           Title Should Be  ${TITLE_TEXT}
#           Input Text  ${username_input}  ${VALID_USERNAME}
#           Input Text  ${password_input}  ${VALID_PASSWORD}
#           Click Button  ${SUBMIT_BUTTON}
#           Alert Should be Present  ${FAILED_LOGIN_TEXT}
#           Title Should Be  ${TITLE_TEXT}
#       ----------------------------------------------------------------------------------------------------------------
#
#       or like this:
#       ----------------------------------------------------------------------------------------------------------------
#       *** Settings ***
#       Library                 Selenium2Library
#       Resource                MyKeywords.robot
#       Test Setup              MyKeywords.Setup Tests
#       Test Teardown           Close Browser
#
#       *** Variables ***
#       ${ROOT_URL}             http://nealpert.net
#
#       *** Tests ***
#       Valid User Can Log In
#           MyKeywords.Valid User Can Log In
#
#       Invalid User Cannot Log In
#           MyKeywords.Invalid User Cannot Log In
#       ----------------------------------------------------------------------------------------------------------------
#
#       With page objects, your tests can be readable without tight coupling. This test file does all the same things:
#       Sample MyTests.robot
#       ----------------------------------------------------------------------------------------------------------------
#       *** Settings ***
#       Resource                Application.robot
#       Test Setup              Open Browser
#       Test Teardown           Close Browser
#
#       *** Variables ***
#       ${PAGEOBJECTS_ROOT}     http://neilpeart.net
#       ${VALID_USERNAME}       neil@neilpeart.net
#       ${VALID_PASSWORD}       DrUmm3rsRUL#Z
#       ${INVALID_USERNAME}     dummy@google.com
#       ${INVALID_PASSWORD}     dum-drummer
#
#       *** Tests ***
#       Valid User Can Log In
#           Go To Page  LoginPage
#           Enter Username  ${VALID_USERNAME}
#           Enter Password  ${VALID_PASSWORD}
#           Click the Submit Button
#           Current Page Should Be  MainPage
#
#       Invalid User Cannot Log In
#           Go To Page  LoginPage
#           Enter Username  ${INVALID_USERNAME}
#           Enter Password  ${INVALID_PASSWORD}
#           Click the Submit Button
#           Login Should Have Failed
#       ----------------------------------------------------------------------------------------------------------------
#
#       Sample MyApp.robot:
#       This [optional] file should reference all your page object resources and provide keywords for setup and/or
#       teardown of tests throughout the application. Without it, your test files will need to reference all the page
#       object resources they may need to interact with directly.
#       ----------------------------------------------------------------------------------------------------------------
#       *** Settings ***
#       Library         Selenium2Library
#       Resource        LoginPage.robot
#       Resource        MainPage.robot
#
#       *** Variables ***
#       ${BROWSER}      chrome
#
#       *** Keywords ***
#       Open Browser
#           [Documentation]     Replace the Selenium2Library version with one that doesn't need to be told what to do.
#           Selenium2Library.Open Browser  about:blank  ${BROWSER}
#       ----------------------------------------------------------------------------------------------------------------
#
#       Sample LoginPage.robot:
#       This file should provide meaningful keywords for each of the user operations that can be done on the login page.
#       ----------------------------------------------------------------------------------------------------------------
#       *** Settings ***
#       Library                 Selenium2Library
#
#       *** Variables ***
#       ${username_input}       input[@id='username']
#       ${password_input}       input[@id='password']
#       ${submit_button}        input[@type='submit']
#
#       ${title_text}           Welcome to the official website of Neil Peart
#       ${failed_login_text}    Unknown username and/or password
#
#       *** Keywords ***
#       Get Page Object Path
#           [Return]    /login
#
#       Should Be Current Page
#           [Documentation]     Implementing because the title is what's important. The URL may have extra bits.
#           Title Should Be  ${title_text}
#
#       Enter User Name
#           [Arguments]  ${value}
#           Input Text  ${username_input}  ${value}
#
#       Enter Password
#           [Arguments]  ${value}
#           Input Text  ${password_input}  ${value}
#
#       Click the Submit Button
#           Click Button  ${submit_button}
#
#       Login Should Have Failed
#           Alert Should be Present  ${failed_login_test}
#           Current Page Should Be  LoginPage
#       ----------------------------------------------------------------------------------------------------------------
#
#       MainPage.robot
#       This file would provide keywords for all the user operations that can be done on the "main" page...
#       ----------------------------------------------------------------------------------------------------------------
#       *** Settings ***
#       Library                 Selenium2Library
#
#       *** Variables ***
#       Get Page Object Path
#           [Return]    /main
#
#       # `Should Be Current Page` is not needed because the URL being ${PAGEOBJECTS_ROOT}/main is enough to prove it
#       ----------------------------------------------------------------------------------------------------------------
#   ====================================================================================================================
#   ****                 Tests should not need to directly execute keywords defined below this line                 ****
#   ====================================================================================================================
Should Be Current Page
    [Documentation]     *Should not be called directly by tests!*
    ...                 This is the default implementation of the page objects `Should Be Current Page`, called only if
    ...                 the page object doesn't implement the keyword.
    [Arguments]         ${resource_name}  ${query}=
    ${path}=  run keyword  get path for page  ${resource_name}  ${query}
    location should be  ${path}

Get Path For Page
    [Documentation]     *Should not be called directly by tests!*
    ...                 Assembles the path to go to for the specified page object resource and query string.
    [Arguments]         ${resource_name}  ${query}=
    ${path}=  run keyword  ${resource_name}.get page object path
    [Return]  ${PAGEOBJECTS_ROOT}${path}${query}
