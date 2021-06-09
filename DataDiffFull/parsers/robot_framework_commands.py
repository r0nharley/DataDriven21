from robot.libraries.BuiltIn import BuiltIn

from bs4 import BeautifulSoup
from lxml import html

##
# References to the selenium web driver, used to shut it down properly in order
# to avoid a known issue with the driver, when closing the driver/connection is
# called more than once in a python application
import signal
from selenium import webdriver

from chart_parser import ChartParser
from bar_chart_parser import BarChartParser
from column_chart_parser import ColumnChartParser
from pie_chart_parser import PieChartParser
from pivot_table_parser import PivotTableParser
from table_widget_parser import TableWidgetParser
from rl_lib.mailtrap import Mailtrap


##
# If "element" (as an xpath reference) has no match in "content" (HTML or XML), throws an error.
def element_should_be_visible_in_content(element, content):
    xml_content = html.fromstring(content)
    elements = xml_content.xpath(element)

    if len(elements) == 0:
        raise Exception("Element '{0}' is not visible in content".format(element))


##
# For "element" (as an xpath reference) in "content" (HTML or XML), returns all matching elements as an array of
# dictionary objects
def get_elements_from_content(element, content):
    xml_content = html.fromstring(content)
    elements = xml_content.xpath(element)

    return elements


##
# For "element_reference" (as an xpath reference) in "content" (HTML or XML), and an element attribute (string), returns
# the value of the attribute for the first matching element
def get_element_attribute_from_content(element_reference, attribute, content):
    output = None
    element = get_element_from_content(element_reference, content)

    if element is not None:
        output = get_element_from_content_attribute(element, attribute)

    return output


##
# For "element" (as an xpath reference) in "content" (HTML or XML), returns the first matching element as a
# dictionary object
def get_element_from_content(element, content):
    elements = get_elements_from_content(element, content)
    output = None

    if len(elements) > 0:
        output = elements[0]

    return output


##
# Given an lxml element object (as obtained from lxml.element.xpath), and an attribute name (string), return the value
# of the attribute
def get_element_from_content_attribute(element, attribute):
    return element.get(attribute)


def has_no_results(widget_soup):
    """
    Whether or not the "No Results" message is displayed
    :param widget_soup: beautiful soup object for the widget
    :return: whether or not the no data element is present
    """
    return len(widget_soup.select('.rl-no-data')) > 0


def parse_chart(chart, sorted_chart_series=''):
    """
    A pseudo factory method used in Robot Framework to parse a chart.  Determines the type of chart based on class
    attributes.
    :param chart: a selenium WebElement that contains the root div of a chart widget
    :param sorted_chart_series: name of the series, if any, by which the chart is sorted
    :return: the data from the chart formatted as tsv
    """
    builtin = BuiltIn()
    soup = BeautifulSoup(chart.get_attribute('outerHTML'), 'html.parser')
    chart_classes = soup.div['class']
    svg = soup.find('svg')
    svg_html = '{0}'.format(svg)

    try:
        if has_no_results(soup):
            return 'Chart\tHas\tNo Results'
        elif 'chart-area' in chart_classes:
            parser = ChartParser(svg_html, sorted_chart_series)
        elif 'chart-bar' in chart_classes:
            parser = BarChartParser(svg_html)
        elif 'chart-column' in chart_classes:
            parser = ColumnChartParser(svg_html, sorted_chart_series)
        elif 'chart-line' in chart_classes:
            parser = ChartParser(svg_html, sorted_chart_series)
        elif 'chart-pie' in chart_classes:
            parser = PieChartParser(svg_html)
        else:
            builtin.log('Skip Test: Unknown Chart Type')
            return 'Chart Type\tIs\tUnsupported'

        return parser.convert_to_tsv()
    except Exception as e:
        builtin.log('\nWarning: Unable to Parse Chart\n\tError: {}'.format(e))
        return 'Chart\tIs\tNot Parsed'


def parse_table(table, sorted_table_column=''):
    """
    Method used in Robot Framework to parse a table.
    :param table: a selenium WebElement that contains the root div of a table
    :param sorted_table_column: name of the column, if any, by which the table is sorted
    :return: the data from the table formatted as tsv
    """
    builtin = BuiltIn()
    soup = BeautifulSoup(table.get_attribute('outerHTML'), 'html.parser')
    table_html = table.get_attribute('outerHTML')

    try:
        if has_no_results(soup):
            return 'Table\tHas\tNo Results'
        elif len(soup.select('.rl-left-container > .rl-frozen-corner > table > tbody > tr > td')) > 0:
            parser = PivotTableParser(table_html)
        else:
            parser = TableWidgetParser(table_html, sorted_table_column)

        return parser.convert_to_tsv()
    except Exception as e:
        builtin.log('\nWarning: Unable to Parse Table\n\tError: {}'.format(e))
        return 'Table\tIs\tNot Parsed'


def rl_close_browser():
    """
    This function properly closes the selenium web driver and kills all associated
    threads. The selenium driver has a known issue, when being called more than once
    in the same python application, of not always closing all connecting processing
    threads, and then error when it attempts to close the browser. This function
    replaces Selenium2Library.Close Browser , and explicitly sends the termination
    signal to all processes of the browser driver to shutdown, which does the trick.
    """
    driver = webdriver.PhantomJS()
    driver.service.process.send_signal(signal.SIGTERM)
    driver.quit()


# searches emails in Mailtrap, for particular criteria. See comments in mailtrap.Mailtrap for details.
def search_emails_from_mailtrap(criteria):
    mailtrap_obj = Mailtrap()
    results = mailtrap_obj.search_messages(criteria)

    return results


def enable_download_in_headless_chrome(driver, download_dir):
    driver.command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')

    params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': download_dir}}
    driver.execute("send_command", params)
