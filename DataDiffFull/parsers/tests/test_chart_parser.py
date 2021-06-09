import os

from RobotFramework.parsers.chart_parser import ChartParser


def get_test_file_path(chart_type, filename):
    """
    Gets the path to a file in the fixtures folder
    :param chart_type: the chart type's subdirectory in the fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', chart_type, filename)


def execute_chart_parser_test(chart_type, filename_root):
    """
    Compares the output of the chart parser with the expected results
    :param chart_type: the chart type's subdirectory in the fixtures folder
    :param filename_root: Base filename of the files containing the html to be parsed and the expected results
    """
    file_location = get_test_file_path(chart_type, '{0}.html'.format(filename_root))
    with open(file_location, 'r') as fp:
        chart_svg = fp.read()
    file_location = get_test_file_path(chart_type, '{0}_expected.tsv'.format(filename_root))
    with open(file_location, 'r') as fp:
        chart_expected_tsv = fp.read()
    chart_parser = ChartParser(chart_svg)
    assert chart_parser.convert_to_tsv() == chart_expected_tsv


def test_area_chart_parser():
    """
    Tests a multi-series area chart with the navigator present
    """
    execute_chart_parser_test('area-chart', 'usrg_usrg-custom_pmp-dashboard_future-occupancy-change-by-property')


def test_line_chart_parser():
    """
    Tests a couple of multi-series line charts
    """
    execute_chart_parser_test('line-chart', 'demo_operations_future-occupancy_change-by-property')
    execute_chart_parser_test('line-chart', 'demo_marketing_traffic-counts_traffic-cohort-summary-by-date')


def test_line_chart_parser_navigator_present():
    """
    Tests a line chart with the navigator present
    """
    execute_chart_parser_test('line-chart', 'bh-management_operations_future-occupancy_change-by-property')
