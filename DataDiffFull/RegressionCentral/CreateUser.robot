*** Settings ***
Library  Selenium2Library

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot


*** Variables ***
${DjangoAdmin} =  ${START_URL_DB_ADMIN}/admin/login/?next=/admin/
${DjangoAdminOrganizations} =  ${START_URL_DB_ADMIN}/admin/customer/organization/
${UserNamefield} =  //input[@id='id_username']
${LoginBTN} =  //input[@value='Log in']
${AddUserBTN} =  //a[@href='/admin/auth/user/add/']
${AddUserPageConfirm} =  //h1[contains(.,'Add user')]
${NewUserName} =  //input[@name='username']
${NewUserPSW} =  //input[@name='password1']
${NewUserPSWConfirm} =  //input[@name='password2']
${ConfirmChangeUserPage} =  //h1[contains(.,'Change user')]
${NewUserFirstName} =  //input[@id='id_first_name']
${NewUserLastName} =  //input[@id='id_last_name']
${NewUserEmail} =  //input[@id='id_email']
${StaffStatusCheckbox} =  //input[@id='id_is_staff']
${SuperUserCheckbox} =  //input[@id='id_is_superuser']
${ViewSiteLink2LightBlueADM} =  //a[contains(.,'View site')]
${DeleteUser} =  //a[@class='deletelink']
${DeleteUserLandPage} =  //h1[contains(.,'Are you sure?')]
${DeleteUserConfirm} =  //input[@type='submit']
${OrganizationsBTN} =  //a[contains(.,'Organizations')]
${DjangoAdminUserPageHeading} =  //h1[contains(.,'Select user to change')]
${DjangoLogoutBTN} =  //a[contains(.,'Log out')]
${DjangoLogoutConfirmationHeading} =  //h1[contains(.,'Logged out')]
${DjangoAdminHeading} =  //h1[contains(.,'Site administration')]
${DjangoAdminOrgsHeading} =  //h1[contains(.,'Select organization to change')]
${DjangoAdminChangeOrgHeading} =  //h1[contains(.,'Change organization')]
${DjangoAdminChangeOrgAddUserSearch} =  //input[@id="id_users_input"]
${DjangoAdminChangeOrgAddALLUserBTN} =  //a[@id="id_users_add_all_link" and @class="selector-chooseall active"]
${DjangoResultsPages} =  //p[@class="paginator"]/*
${DjangoSaveBTN} =  //input[@name='_save']
${DjangoOrgUsersSelect} =  //select[@id="id_users_from"]


*** Keywords ***
CreateUserTest
    Set Test Variable  ${Passwordfield}  //input[@id='id_password']
    Navigate to Django Admin
    Log in Admin User to Django Admin
    Create New User  %{ROBOT_WORKER_USERNAME}  %{ROBOT_WORKER_PASSWORD}  RegressionTest  Worker  %{ROBOT_WORKER_USERNAME}  True  True
    Create New User  %{ROBOT_WORKER_USERNAME2}  %{ROBOT_WORKER_PASSWORD2}  RegressionTest2  Worker  %{ROBOT_WORKER_USERNAME2}  True  True
    Navigate to Organizations
    Navigate to Change Organization  ${ORG_SLUG}
    Add User to Organization  %{ROBOT_WORKER_USERNAME}
    Navigate to Change Organization  ${ORG_SLUG}
    Add User to Organization  %{ROBOT_WORKER_USERNAME2}
    Log out of Django Admin


Add User to Organization
    [Arguments]  ${username}
    input text  ${DjangoAdminChangeOrgAddUserSearch}  ${username}
    Click Element  ${DjangoOrgUsersSelect}//option[@title="${username}"]
    Click Element  ${DjangoAdminChangeOrgAddALLUserBTN}
    Save Organization

Click the log in button
    click element  ${LoginBTN}

Confirm logged in
    wait until element is visible  ${DjangoAdminHeading}  ${page_request_timeout}

Click Add User
    click element  ${AddUserBTN}
    wait until element is visible  ${AddUserPageConfirm}  ${page_request_timeout}

Click Organization
    Click Element ${OrganizationsBTN}

Confirm The New Users PW
    [Arguments]  ${password}
    input password  ${NewUserPSWConfirm}  ${password}

Click Add User Save Button
    click element  ${DjangoSaveBTN}
    wait until element is visible  ${ConfirmChangeUserPage}  ${page_request_timeout}

Confirm Change User Page
    element should be visible  ${ConfirmChangeUserPage}

Check Staff Status Checkbox
    click element  ${StaffStatusCheckbox}

Check SuperStatus Checkbox
    click element  ${SuperUserCheckbox}

Click Change User Save Button
    click element  ${DjangoSaveBTN}
    wait until element is visible  ${DjangoAdminUserPageHeading}  ${page_request_timeout}

Create New User
    [Arguments]  ${username}  ${password}  ${firstname}  ${lastname}  ${email}  ${is_staff}=False  ${is_superuser}=False
    Click Add User
    Enter The New UserName  ${username}
    Enter The New Users PW  ${password}
    Confirm The New Users PW  ${password}
    Click Add User Save Button
    Confirm Change User Page
    Enter New User First Name  ${firstname}
    Enter New User Last Name  ${lastname}
    Enter New User Email Address  ${email}
    Run Keyword if  ${is_staff}  Check Staff Status Checkbox
    Run Keyword if  ${is_superuser}  Check SuperStatus Checkbox
    Click Change User Save Button

Enter Admin Username
    input text  ${UserNamefield}  %{ROBOT_ADMIN_USERNAME}

Enter Admin Password
    input password  ${Passwordfield}  %{ROBOT_ADMIN_PASSWORD}

Enter New User First Name
    [Arguments]  ${firstname}
    input text  ${NewUserFirstName}  ${firstname}

Enter New User Last Name
    [Arguments]  ${lastname}
    input text  ${NewUserLastName}  ${lastname}

Enter New User Email Address
    [Arguments]  ${email}
    input text  ${NewUserEmail}  ${email}

Enter The New UserName
    [Arguments]  ${username}
    input text  ${NewUserName}  ${username}

Enter The New Users PW
    [Arguments]  ${password}
    input password  ${NewUserPSW}  ${password}

Log in Admin User to Django Admin
    Enter Admin Username
    Enter Admin Password
    Click the log in button
    Confirm logged in

Log out of Django Admin
    click element  ${DjangoLogoutBTN}
    wait until element is visible  ${DjangoLogoutConfirmationHeading}

Navigate to Django Admin
    go to  ${DjangoAdmin}
    maximize browser window

Navigate to Organizations
    go to  ${DjangoAdminOrganizations}
    wait until element is visible  ${DjangoAdminOrgsHeading}  ${page_request_timeout}

Navigate to Change Organization
    [Arguments]  ${organization}
    # must already be on the organizations listing page
    # loop each of the pages in the results, and look for the org specified
    ${org_listing} =  Set Variable  td[@class="field-slug" and text()='${organization}']
    @{Pages} =  Get Webelements  xpath=${DjangoResultsPages}
    :FOR  ${page}  IN  @{Pages}
    \   click element  ${page}
    \   wait until element is visible  ${DjangoAdminOrgsHeading}  ${page_request_timeout}
    \   ${status}=  Run Keyword And Return Status  Element Should Be Visible  //${org_listing}
    \   Exit For Loop If  ${status}
    Element Should Be Visible  //${org_listing}
    Click Element  //tr[./${org_listing}]/th[@class="field-name"]/a
    wait until element is visible  ${DjangoAdminChangeOrgHeading}  ${page_request_timeout}

Save Organization
    Click Element  ${DjangoSaveBTN}
    wait until element is visible  ${DjangoAdminOrgsHeading}  ${page_request_timeout}
