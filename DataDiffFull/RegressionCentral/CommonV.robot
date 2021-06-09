*** Settings ***
Library  Selenium2Library
Library  DiffLibrary
Library  OperatingSystem
Library  DiffLibrary
Library  ${EXECDIR}/diff.py

# library needed for Mailtrap integration
Library  ${EXECDIR}/rl_lib
# Library needed for End Web Test
Library  ${EXECDIR}/parsers/robot_framework_commands.py

*** Variables ***
# set a default incase the calling robot doesn't supply it
${INCLUDE_SCREENSHOTS} =  False

# default page_request_timeout (waiting for refresh to load), in seconds
${page_request_timeout} =  120

##
# time in seconds to wait for a quick action that pops something up, that doesn't require external page interactions
# (confirmation alerts, etc.)
${quick_action_timeout} =  5

${OverviewExecutiveDashboard} =  ${START_URL}/bi/overview-executive
${OverviewExecutiveDashboardDetailsView} =  ${START_URL}/bi/overview-executive/details
${OverviewExecutiveDashboardMenuHeading} =   //span[contains(.,'Overview')]
${RetryWaitingPeriod} =  15s

@{chrome_arguments}    --disable-infobars    --headless    --disable-gpu    --disable-dev-shm-usage    --no-sandbox
@{download_folder}      ${EXECDIR}/download

*** Keywords ***
Set Chrome Options
    [Documentation]    Set Chrome options for headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    : FOR    ${option}    IN    @{chrome_arguments}
    \    Call Method    ${options}    add_argument    ${option}
    [Return]    ${options}

Begin Web Test with HeadlessChrome
    Remove Directory    @{download_folder}    recursive=True
    ${chrome_options}=    Set Chrome Options
    Create Webdriver    Chrome    executable_path=${EXECDIR}/Resources/webdrivers/chromedriver_241_linux    chrome_options=${chrome_options}
    ${S2L}    get library instance    Selenium2Library
    ${webdriver}    Call Method    ${S2L}    _current_browser
    Enable Download In Headless Chrome    ${webdriver}    @{download_folder}

Begin Web Test
    Open Browser  about:blank  ${BROWSER}

Begin Web Test Functional
    Get Environment Variable   ${REMOTE_URL}  ''
    Get Environment Variable   ${DESIRED_CAPABILITIES}  ''
    run keyword if  '${REMOTE_URL}' == '${EMPTY}'  Open Browser  about:blank  ${BROWSER}  ELSE  Open Browser  about:blank  ${BROWSER}  remote_url=${REMOTE_URL}  desired_capabilities=${DESIRED_CAPABILITIES}

End Web Test
    ##
    # The default function Selenium2Library.Close Browser, has a known issue
    # when called more than once in a python application, of not always closing
    # all of the processing threads and then erroring. Created a new function
    # rl_close_browser in ${EXECDIR}/parsers/robot_framework_commands.py, that
    # adds a couple lines of code to solve this problem.
    Rl Close Browser

Check Page Ready
    [Arguments]  ${element_reference}  ${timeout}
    Wait until element is visible  ${element_reference}  ${timeout}

Click Element in Content
    [Arguments]  ${element_reference}  ${content}
    ${url} =  robot_framework_commands.Get Element Attribute from Content  ${element_reference}  href  ${content}
    go to  ${url}

Has Data Difference
    copy file  ./HasDataProd/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${output_dir}/HasDataProd/HasData${ORG_NAME}/Results/${FILENAME}.txt
    copy file  ./HasDataStage/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${output_dir}/HasDataStage/HasData${ORG_NAME}/Results/${FILENAME}.txt
    diff kpis  ./HasDataProd/HasData${ORG_NAME}/Results/${FILENAME}.txt  ./HasDataStage/HasData${ORG_NAME}/Results/${FILENAME}.txt  ${DASHBOARD_NAME}

Load Homepage
    go to  ${START_URL}
    Screenshot if Specified

##
# Given a URL and an element xpath, try to load the page up to twice until the element is visible
# ${URL}=False - will reload the current page.
# ${element_to_wait_for}=False - will not wait for additional elements before determining the page is loaded.
Load Page and Wait for Element up to X Times
    [Arguments]  ${URL}=False  ${item_to_wait_for}=False
    Wait Until Keyword Succeeds  2x  ${RetryWaitingPeriod}  Load Page and Wait for Element  ${URL}  ${item_to_wait_for}

##
# Given a URL and an element xpath, go to the page and wait for it to load.
# ${URL}=False - will reload the current page.
# ${element_to_wait_for}=False - will not wait for additional elements before determining the page is loaded.
Load Page and Wait for Element
    [Arguments]  ${URL}=False  ${element_to_wait_for}=False
    ${is_url}=  Convert to Boolean  ${URL}
    ${is_element}=  Convert to Boolean  ${element_to_wait_for}
    Run Keyword if  ${is_url}  go to  ${URL}
    Run Keyword if  not ${is_url}  Reload Page
    Screenshot if Specified
    Run Keyword if  ${is_element}  wait until element is visible  ${element_to_wait_for}  ${page_request_timeout}
    Screenshot if Specified

##
# Given a keyword and optional arguments for that keyword, will attempt to run the keyword, and on a Fail, will
# reload the page and try to run the keyword a second time.
# Some argument details:
# ${startup_keyword} - If, on reload, you also need to run an additional keyword to re-set the stage, before running
# ${keyword1}, specify an additional keyword here. The keyword cannot take arguments, though you may include tags
# (tagged inputs) in the keyword name. Set ${startup_keyword}=False otherwise.
# You can optionally provide NONE for some of the arguments as described below.
# ${URL}=False - will reload the current page.
# ${element_to_wait_for}=False - will not wait for additional elements before determining the page is loaded.
# ${startup_keyword}=False - Will not try to load a startup keyword on reload
Run Keyword and Reload Page and Rerun on Fail
    [Arguments]  ${URL}  ${item_to_wait_for}  ${startup_keyword}  ${keyword1}  @{keyword_args}
    ${status}=  Run Keyword And Return Status  ${keyword1}  @{keyword_args}
    Run Keyword if  ${status}==False  Log to Console  Reloading Page and Rerun Keyword '${keyword1}'
    Sleep  ${RetryWaitingPeriod}
    Run Keyword if  ${status}==False  Load Page and Wait for Element  ${URL}  ${item_to_wait_for}
    ${has_startup_keyword}=  Convert to Boolean  ${startup_keyword}
    Run Keyword if  ${status}==False and ${has_startup_keyword}  ${startup_keyword}
    Run Keyword if  ${status}==False  ${keyword1}  @{keyword_args}

# captures a screen shot, if the global variable ${INCLUDE_SCREENSHOTS} is set to true
Screenshot if Specified
    Run Keyword If  ${INCLUDE_SCREENSHOTS}  Capture Page Screenshot


Download should be done
    [Arguments]  ${directory}
    ${files}  List Files In Directory  ${directory}
    Length Should Be  ${files}  1  Should be only one file in the download folder
    Should Not Match Regexp  ${files[0]}  (?i).*\\.tmp  Chrome is still downloading a file
    ${file}  Join Path  ${directory}  ${files[0]}
    Log  File was successfully downloaded to ${file}
    [Return]    ${file}