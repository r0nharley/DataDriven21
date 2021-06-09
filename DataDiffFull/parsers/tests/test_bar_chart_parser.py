import os

from RobotFramework.parsers.bar_chart_parser import BarChartParser


def get_test_file_path(filename):
    """
    Gets the path to a file in the column-chart fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', 'bar-chart', filename)


def execute_bar_chart_parser_test(filename_root):
    """
    Compares the output of the column chart parser with the expected results
    :param filename_root: Base filename of the files containing the html to be parsed and the expected results
    """
    file_location = get_test_file_path('{0}.html'.format(filename_root))
    with open(file_location, 'r') as fp:
        bar_chart_svg = fp.read()
    file_location = get_test_file_path('{0}_expected.tsv'.format(filename_root))
    with open(file_location, 'r') as fp:
        bar_chart_expected_tsv = fp.read()
    bar_chart_parser = BarChartParser(bar_chart_svg)
    assert bar_chart_parser.convert_to_tsv() == bar_chart_expected_tsv


def test_bar_chart_parser():
    """
    Tests a typical bar chart
    """
    execute_bar_chart_parser_test('bh-management_overview_lease-data-exceptions_rent-exceptions-summary')


def test_bar_chart_parser_with_last_xaxis_label_not_fully_visible():
    """
    Tests a bar chart with a label not fully visible (showing "..." at the end
    :return:
    """
    execute_bar_chart_parser_test('bh-management_overview_lease-data-exceptions_lease-data-exceptions-summary')


def test_bar_chart_parser_with_yaxis_labels_that_wrap():
    """
    Tests a bar chart with labels that span more than one line
    :return:
    """
    execute_bar_chart_parser_test(
        'bh-management_overview_lease-data-exceptions_lease-data-exceptions-summary_wrapping-labels'
    )


def test_bar_chart_parser_with_one_data_in_one_series():
    """
    Tests a bar chart where all the data is in one series
    :return:
    """
    execute_bar_chart_parser_test('bh-management_marketing_overview_top-10-sources-of-applications')
