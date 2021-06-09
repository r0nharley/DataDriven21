*** Settings ***
Library  String
Resource  ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot

*** Variables ***
${Chart_XPath} =  //div[@id="__id__"]
${Rect_XPath} =  /*[name()="svg"]/*[@class="highcharts-series-group"]/*[name()="g"][1]/*[name()="rect"]
${DrElement} =  //div[@id="__id__"]//*[name()="svg"]/*[@class="highcharts-series-group"]/*[name()="g"][1]/*[name()="rect"]

*** Keywords ***    
Select Property From Chart
    [Arguments]  ${Chart_Id}=chart1
    ${DrElement}=  Replace String  ${DrElement}  __id__  ${Chart_Id}
    Execute Javascript  document.getElementById("${Chart_Id}").scrollIntoView()
    Click Element  xpath=${DrElement}[1]
    
Get Number Of Bars On Chart
    [Arguments]  ${Chart_Id}
    ${Chart_XPath}=  Replace String  ${Chart_XPath}  __id__  ${Chart_Id}
    ${All_Rect_Count}=  Get Matching Xpath Count  xpath=${Chart_XPath}/${Rect_XPath}
    [Return]  ${All_Rect_Count}
