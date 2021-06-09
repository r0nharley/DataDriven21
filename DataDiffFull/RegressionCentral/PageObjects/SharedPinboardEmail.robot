*** Settings ***
Library  DateTime

Resource   ${EXECDIR}/RegressionCentral/CommonV.robot

*** Variables ***

*** Keywords ***
Verify Shared Pinboard Email
    [Arguments]  ${min_datetime}  ${max_datetime}  ${PinboardName}  ${ShareText}
    # search for the correct email
    ${search_criteria} =  Create Dictionary  sent_to_emails=%{ROBOT_WORKER_USERNAME2}  sender_email=help@rentlytics.com  subject_contains=Shared a Pinboard  sent_min_datetime=${min_datetime}  sent_max_datetime=${max_datetime}
    ${emails} =  Search Emails from Mailtrap  ${search_criteria}
    # check that there is one matching email found
    ${number_of_emails} =  Get Length  ${emails}
    Should Be Equal As Integers  ${number_of_emails}  1
    # Check that the email contains the pinboard link
    Element Should be Visible in Content  //a/b[text()='${PinboardName}']  ${emails}[0]["content"]
    # check that the email contains the optional comment
    Element Should be Visible in Content  //td/b[contains(text(), '${ShareText}')]  ${emails}[0]['content']
    # return the emails for other keywords to use
    [Return]  ${emails}

Click on Shared Pinboard Email Pinboard Link
    [Arguments]  ${emails}  ${PinboardName}
    CommonV.Click Element in Content  //a[./b[text()='${PinboardName}']]  ${emails}[0]['content']
