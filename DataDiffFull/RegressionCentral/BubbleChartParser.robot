*** Settings ***
Library  Selenium2Library
Library  String

*** Keywords ***

Parse Bubble Chart ${CHART} ${FILE}
    Set Test Variable  ${chart_series_xpath}  ${CHART}//*[name()="g" and @class="highcharts-series-group"]/*[name()="g"]
    ${chart_series_count} =  Get Matching Xpath Count  ${chart_series_xpath}
    :FOR  ${series_index}  IN RANGE  1  ${chart_series_count}+1
    \    Set Test Variable  ${series_xpath}  ${chart_series_xpath}[${series_index}]
    \    ${series_class}  Get Element Attribute  xpath=${series_xpath}@class
    \    ${is_not_marker_series}=  Run Keyword And Return Status  Should Not Contain  ${series_class}  highcharts-markers
    \    ${is_not_navigator_series}=  Run Keyword And Return Status  Should Not Contain  ${series_class}  highcharts-navigator-series
    \    Run Keyword If  ${is_not_marker_series}  Run Keyword If  ${is_not_navigator_series}  Process Series  ${CHART}  ${FILE}  ${series_xpath}


Process Series
    [Arguments]  ${CHART}  ${FILE}  ${SERIES_XPATH}
    # A bubble chart can have overlapping bubbles.  Unfortunately this results, in times, in the hover action activating for the wrong bubble.
    # To make sure we always are hovering over the desired bubble, we will first move all bubbles to (0, 0), and then one-by-one,
    # move bubbles to (100, 100), hover over them, record data from the tooltip, and move the bubble back to (0, 0).
    Set Test Variable  ${series_point_xpath}  ${SERIES_XPATH}/*[contains(@class, "highcharts-point")]
    @{series_points} =  Get Webelements  xpath=${series_point_xpath}

    # Move all of the bubble points to (0, 0).  In doing this, we are giving the bubble an id of "point<index>".
    Set Test Variable  ${point_index}  0
    :FOR  ${point}  IN  @{series_points}
    \    ${point_index}=  Execute Javascript  return ${point_index}+1
    \    Set Test Variable  ${point_id}  point${point_index}
    \    Assign Id To Element  ${point}  ${point_id}
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("cx", 0)
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("cy", 0)
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("d", "M 0.1 0.1 A 9 9 0 1 1 0 0 Z")

    # One-by-one move each of the bubble points to (100, 100), mouse over the point, extract info from the tooltip, and move point back to (0, 0)
    Set Test Variable  ${point_index}  0
    Set Test Variable  ${tooltip}  ${CHART}//div[contains(@class, "highcharts-label highcharts-tooltip")]
    :FOR  ${point}  IN  @{series_points}
    \    ${point_index}=  Execute Javascript  return ${point_index}+1
    \    Set Test Variable  ${point_id}  point${point_index}
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("cx", 100)
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("cy", 100)
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("d", "M 100.1 100.1 A 9 9 0 1 1 100 100 Z")
    \    Mouse Over  ${point}
    \    Wait Until Page Contains Element  ${tooltip}  60
    \    ${x_label}=  Get Text  ${tooltip}//div[@class="rl-tooltip-last-element"]/span[2]
    \    ${y1_label}=  Get Text  ${tooltip}//div[@class="rl-tooltip-first-element"]/span[1]
    \    ${y2_label}=  Get Text  ${tooltip}//div[@class="rl-tooltip-middle-element"]/span[1]
    \    ${xy1_value}=  Get Text  ${tooltip}//div[@class="rl-tooltip-first-element"]/span[2]
    \    ${xy2_value}=  Get Text  ${tooltip}//div[@class="rl-tooltip-middle-element"]/span[2]
    \    Append To File  ${FILE}  ${x_label}\t${y1_label}\t${xy1_value}\n
    \    Append To File  ${FILE}  ${x_label}\t${y2_label}\t${xy2_value}\n
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("cx", 0)
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("cy", 0)
    \    Execute Javascript  document.getElementById("${point_id}").setAttribute("d", "M 0.1 0.1 A 9 9 0 1 1 0 0 Z")