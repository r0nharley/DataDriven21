*** Settings ***
Resource  ${EXECDIR}/RegressionCentral/PageObjects/Dashboard.robot

*** Variables ***
${Blurbs_XPath}                      //div[contains(@class, "rl-blurb") and .//div[contains(@ng-if, "blurb.linkSlug")]]
${Selected_Topic_XPath}              //div[contains(@class, "rl-menu-btn")]//span[contains(@class, "rl-selected-name")]


*** Keywords ***
Navigate To Leasing & Rents Summary Dashboard And Get Blurds
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Summary
    [Return]  ${Blurbs_XPath}

Verify Go to Dashboard Link Button
    [Arguments]  ${Blurb_XPath}
    CommonPage.Wait Until Loading Bar Is Not Visible
    ${Blurb_Name}=  Get Text  xpath=${Blurb_XPath}/div[@class="rl-title"]
    Click Element  xpath=${Blurb_XPath}/div[contains(text(), "Go to Dashboard")]
    Element Should Be Visible  xpath=${Selected_Topic_XPath}
    ${Topic_Name}=  Get Text  xpath=${Selected_Topic_XPath}
    Should Be Equal As Strings  ${Blurb_Name}  ${Topic_Name}
    # Go back to summary page
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Summary