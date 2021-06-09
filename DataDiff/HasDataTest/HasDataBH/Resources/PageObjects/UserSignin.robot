*** Settings ***

Library  Selenium2Library

*** Variables ***

${rentlyticslogo} =  xpath=//div[contains(@class,'rl-logo pull-left')]
${signinbuttonxpath} =  //button[@ng-click="submitForm()"]
${signinbutton} =  xpath=${signinbuttonxpath}
${passwordfield} =  name=password
${emailfield} =  name=email
${loginscreen} =  //h3[contains(.,'sign in & start to explore')]

*** Keywords ***
User Signin Extended
    Load Page
    Maximize Signin Window
    Wait for login screen
    Click Email Address field 2
    Enter Email Address 2
    Click Password field 2
    Enter Valid Password 2
    Signin Button
    Rentlytics Logo Displayed


Load Page
    go to  ${START_URL}

Maximize Signin Window
    maximize browser window

Wait for login screen
    wait until element is visible  ${loginscreen}  5

Click Email Address field 2
    Click element  ${emailfield}

Enter Email Address 2
    Input Text  ${emailfield}  ${USERNAME}

Click Password field 2
    Click element  ${passwordfield}

Enter Valid Password 2
    Input text  ${passwordfield}  ${PASSWORD}

Signin Button
    Click Button  ${signinbutton}

Rentlytics Logo Displayed
    wait until element is visible  ${rentlyticslogo}  10
