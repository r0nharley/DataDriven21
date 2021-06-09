*** Settings ***
Library  Selenium2Library

Resource   ${EXECDIR}/RegressionCentral/CreateUser.robot


*** Variables ***
${SearchforUserField} =  //input[@id='searchbar']
${SearchforUserButton} =  //input[@type='submit']
${YesImSureButton} =  //input[contains(@type,'submit')]
${DjangoUserPage} =  ${START_URL_DB_ADMIN}/admin/auth/user/
${UserActionDropdownArrow} =  //select[@name='action']
${SelectDeleteOption} =  //option[@value='delete_selected']
${DeleteUserGoButton} =  //button[contains(.,'Go')]
${SelectUsertoDeleteCheckbox} =  //input[@type='checkbox']


*** Keywords ***
DeleteUserTest
    CreateUser.Navigate to Django Admin
    CreateUser.Log in Admin User to Django Admin
    Navigate to Users Page
    Delete User  %{ROBOT_WORKER_USERNAME}
    Delete User  %{ROBOT_WORKER_USERNAME2}

Click user search button
    click element  ${SearchforUserButton}
    wait until element is visible  ${SelectUsertoDeleteCheckbox}  10

Click checkbox next to user name
    click element  ${SelectUsertoDeleteCheckbox}

Click Go Button
    click element  ${DeleteUserGoButton}

Click Yes I'm Sure button
    click element  ${YesImSureButton}

Delete User
    [Arguments]  ${username}
    Search for User  ${username}
    Click checkbox next to user name
    Expand Action Dropdown
    Select Delete Selected Users
    Click Go Button
    Verify Are you Sure Page
    Click Yes I'm Sure button
    wait until element is visible  ${DjangoAdminUserPageHeading}  ${page_request_timeout}

Enter users name in search
    [Arguments]  ${username}
    input text  ${SearchforUserField}  ${username}

Expand Action Dropdown
    click element  ${UserActionDropdownArrow}
    wait until element is visible  ${SelectDeleteOption}  10

Select Delete Selected Users
    click element  ${SelectDeleteOption}

Search for User
    [Arguments]  ${username}
    Enter users name in search  ${username}
    Click user search button

Navigate to Users Page
    go to  ${DjangoUserPage}

Verify Are you Sure Page
    wait until element is visible  ${YesImSureButton}  20
    wait until element is visible  ${YesImSureButton}  10
