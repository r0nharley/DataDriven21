*** Settings ***

Library  Selenium2Library

*** Variables ***

${rentlyticslogo} =  xpath=//div[contains(@class,'rl-logo pull-left')]
${invalidcred} =  xpath=//div[@class='alert alert-warning']
${noemailorpass} =  xpath=//div[@class='alert alert-warning']
${invalidpassword} =  name=password
${signinbuttonxpath} =  //button[@ng-click='submitForm()']
${signinbutton} =  xpath=${signinbuttonxpath}
${passwordfield} =  name=password
${emailfield} =  name=email
${forgotpassword} =  //div[contains(@class,'rl-toggle-link pull-left')]
${resetpasswordheader} =  //h3[contains(.,'reset password')]
${passwordresetfield} =  //input[@placeholder='Email Address']
${passwordresetrequirement} =  //div[@ng-if='hasWarning']
${sendresetemail} =  //button[contains(.,'Send Reset Email')]
${resetemailconfirm} =  //div[@class='alert alert-success']
${backtologinlink} =  //div[@class='rl-toggle-link pull-left']
${loginscreen} =  //h3[contains(.,'sign in & start to explore')]



*** Keywords ***
User Signin Extended
    Load Page
    Maximize Signin Window
    Signin Button No Credentials
    No Email or Password Error Message
    Click Email Address field
    Enter Email Address
    Click Password field
    Enter Invalid Password
    Invalid username/password message displayed
    Click Forgot Password
    Reset Password screen displayed
    Click Password Reset field
    Enter an invalid Reset Password Email
    Click Send Reset Email
    Valid email message required displayed
    Click Password reset field again
    Enter a valid Reset Password Email
    Click Send Reset Email 2
    Password reset email sent prompt
    Click back to log in button
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

Signin Button No Credentials
    wait until keyword succeeds  2 min  3 sec  xpath should match x times  ${signinbuttonxpath}  1
    Click Button  ${signinbutton}

No Email or Password Error Message
    element should be visible  ${noemailorpass}

Click Email Address field
    Click element  ${emailfield}

Enter Email Address
    Input Text  ${emailfield}  ${USERNAME}

Click Password field
    Click element  ${passwordfield}

Enter Invalid Password
    Input text  ${invalidpassword}  ${BADPASSWORD}

Invalid username/password message displayed
    element should be visible  ${invalidcred}

Click Forgot Password
    Click element  ${forgotpassword}

Reset Password screen displayed
    element should be visible  ${resetpasswordheader}

Click Password Reset field
    Click element  ${passwordresetfield}

Enter an invalid Reset Password Email
    Input text  ${passwordresetfield}  ${BADPASSWORD}

Click Send Reset Email
    Click element  ${sendresetemail}

Valid email message required displayed
    element should be visible  ${passwordresetrequirement}

Click Password reset field again
    Click element  ${passwordresetfield}

Enter a valid Reset Password Email
    Input text  ${passwordresetfield}  ${USERNAME}

Click Send Reset Email 2
    Click element  ${sendresetemail}

Password reset email sent prompt
    wait until element is visible  ${resetemailconfirm}  10

Click back to log in button
    Click element  ${backtologinlink}

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
    wait until element is visible  ${rentlyticslogo}  30