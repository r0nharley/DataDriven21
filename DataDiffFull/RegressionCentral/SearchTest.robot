*** Settings ***
Library  Selenium2Library


*** Variables ***
${BISearchMetricsBtn} =  //span[contains(.,'Search Metrics')]
${BISearchField} =  //input[contains(@placeholder,'  What are you looking for?')]
${BISearchBtn} =  //button[@class='rl-search-button']
${Top3ResultsTxt} =  //div[contains(@ng-show,'topResults.length')]
${MoreResults} =  //div[contains(@ng-show,'otherResults.length')]
${ChartInDash} =  //div[@id="chart1"]
${NoResultsTxt} =  //div[contains(@class,'rl-no-results')]
${ExeDash} =  ${START_URL}/bi/overview-executive/visualization
${RentSearchResult} =  //div[contains(.,'Current Rent & Loss to Lease by Property')]


*** Keywords ***
BISearchTesting
    Navigate to a Dashboard
    Click the search metrics button
    Enter a Search term that yields no results
    Verify that the no results page is displayed
    Enter a valid search Term
    Verify that results are returned

Click the search metrics button
    click element  ${BISearchMetricsBtn}
    wait until element is visible  ${BISearchField}  10

Enter a Search term that yields no results
    input text  ${BISearchField}  NoResultsSearchTest
    click element  ${BISearchBtn}

Enter a valid search Term
    input text  ${BISearchField}  Rent
    click element  ${BISearchBtn}

Navigate to a Dashboard
    go to  ${ExeDash}
    wait until element is visible  ${ChartInDash}  90

Verify that the no results page is displayed
    wait until element is visible  ${NoResultsTxt}  30

Verify that results are returned
    wait until element is visible  ${RentSearchResult}  90
    wait until element is visible  ${Top3ResultsTxt}  90
    wait until element is visible  ${MoreResults}   90
