*** Settings ***
Library  Selenium2Library


Resource   ${EXECDIR}/RegressionCentral/CreateUser.robot
Resource   ${EXECDIR}/RegressionCentral/DeleteUser.robot


*** Variables ***
${UserMenu} =  //button[contains(.,'Regression ChangePW')]
${UserEmail} =  RegressionTest3@rentlytics.com
${UpdatePasswordHeader} =  //h2[contains(.,'Update Password')]
${HeaderSettingsButton} =  //span[contains(.,'Settings')]
${CurrentPassword} =  //input[@id='currentPwd']
${NewPassword} =  //input[@id='newPwd']
${NewPasswordConfirm} =  //input[contains(@ng-model,'confirmNewPassword')]
${UpdatePassWordButton} =  //button[@class='rl-btn rl-btn-primary btn-sm pull-right']
${PasswordMissmatchMessage} =  //div[contains(@class,'alert alert-warning')]
${LoadingContainer} =  //div[contains(@class,'rl-loading-container')]
${RPLogout} =  //div[contains(@class,'rl-logout float-right')]
${passwordfield} =  name=password
${emailfield} =  name=email
${signinbuttonxpath} =  //button[@type='submit']
${signinbutton} =  xpath=${signinbuttonxpath}
${rentlyticslogo} =  //div[@class='rl-logo float-left active']
${KPIDisplay} =  //div[@id='kpi1']
${PWChangeSucessful} =  //li[contains(.,'Password changed successfully.')]
${DjandoPWChangeBTN} =  //input[@value='Change password']
${DjangoPWChangeFormBTN} =  //a[@href='../password/']
${DjangoPWChangeField1} =  //input[@id='id_password1']
${DjangoPWChangeField2} =  //input[@id='id_password2']
${ChgPwdSubmit} =  //button[@type='submit']
${LoginAgain} =  //a[contains(.,'Log in again')]



*** Keywords ***
ChangePassword
    Clean PW Start
    Sign in For PW Change
    User Menu
    Click Change Password Button
    Verify the Change Password Menu is displayed
    Enter Current Password
    Enter New Password
    Click update password
    Sign out
    Sign in with the new password
    Change the password back

Sign in For PW Change
    go to  ${START_URL}/bi/overview-executive/visualization
    maximize browser window
    Click element   ${emailfield}
    Input password  ${emailfield}  %{ROBOT_WORKER_CNG_PASSWORD_USER}
    Click element  ${passwordfield}
    Input password  ${passwordfield}  %{ROBOT_WORKER_PASSWORD}
    Click Button  ${signinbutton}
    wait until element is not visible   ${LoadingContainer}  20
    ${LoginError}=  run keyword and return status   element should be visible  ${PasswordMissmatchMessage}
    run keyword if  ${LoginError}   print login error message to console
    wait until element is visible  ${rentlyticslogo}  20

User Menu
    wait until element is visible  ${KPIDisplay}  60
    wait until element is visible  ${UserMenu}  60
    click element  ${UserMenu}
    wait until element is visible  ${HeaderSettingsButton}  10

Click Change Password Button
    click element  ${HeaderSettingsButton}

Verify the Change Password Menu is displayed
    wait until element is visible  ${UpdatePasswordHeader}  10

Enter Current Password
    Input password  ${CurrentPassword}  %{ROBOT_WORKER_PASSWORD}

Enter New Password
    Input password  ${NewPassword}  %{ROBOT_WORKER_CNG_PASSWORD1}

Click update password
    click button  ${UpdatePassWordButton}

Sign out
    wait until element is visible  ${RPLogout}  10
    click element  ${RPLogout}

Sign in with the new password
    Click element  ${emailfield}
    Input Text  ${emailfield}  %{ROBOT_WORKER_CNG_PASSWORD_USER}
    Click element  ${passwordfield}
    Input password  ${passwordfield}  %{ROBOT_WORKER_CNG_PASSWORD1}
    click element  ${ChgPwdSubmit}
    wait until element is visible  //div[@class='rl-logo float-left active']  20

Change the password back
    wait until element is visible  ${UpdatePasswordHeader}  10
    Input password  ${CurrentPassword}  %{ROBOT_WORKER_CNG_PASSWORD1}
    Input password  ${NewPassword}  %{ROBOT_WORKER_PASSWORD}
    click element  ${UpdatePassWordButton}


Clean PW Start
    CreateUser.Navigate to Django Admin
    CreateUser.Enter Admin Username
    CreateUser.Enter Admin Password
    CreateUser.Click the log in button
    CreateUser.Confirm logged in
    DeleteUser.Navigate to Users Page
    input text  ${SearchforUserField}  %{ROBOT_WORKER_CNG_PASSWORD_USER}
    DeleteUser.Click user search button
    wait until element is visible  //a[contains(.,'%{ROBOT_WORKER_CNG_PASSWORD_USER}')]  20
    click element  //a[contains(.,'%{ROBOT_WORKER_CNG_PASSWORD_USER}')]
    wait until element is visible  ${DjangoPWChangeFormBTN}
    click element  ${DjangoPWChangeFormBTN}
    Input password  ${DjangoPWChangeField1}  %{ROBOT_WORKER_PASSWORD}
    Input password  ${DjangoPWChangeField2}  %{ROBOT_WORKER_PASSWORD}
    click element  ${DjandoPWChangeBTN}
    wait until element is visible  ${PWChangeSucessful}


Clean PW Finish
    CreateUser.Navigate to Django Admin
    CreateUser.Log out of Django Admin
    Click element   ${LoginAgain}
    CreateUser.Enter Admin Username
    CreateUser.Enter Admin Password
    CreateUser.Click the log in button
    CreateUser.Confirm logged in
    DeleteUser.Navigate to Users Page
    input text  ${SearchforUserField}  %{ROBOT_WORKER_CNG_PASSWORD_USER}
    DeleteUser.Click user search button
    wait until element is visible  //a[contains(.,'%{ROBOT_WORKER_CNG_PASSWORD_USER}')]  20
    click element  //a[contains(.,'%{ROBOT_WORKER_CNG_PASSWORD_USER}')]
    wait until element is visible  ${DjangoPWChangeFormBTN}
    click element  ${DjangoPWChangeFormBTN}
    Input password  ${DjangoPWChangeField1}  %{ROBOT_WORKER_PASSWORD}
    Input password  ${DjangoPWChangeField2}  %{ROBOT_WORKER_PASSWORD}
    click element  ${DjandoPWChangeBTN}
    wait until element is visible  ${PWChangeSucessful}

Change Password Teardown
    Run Keyword If Test Failed  Clean PW Finish



