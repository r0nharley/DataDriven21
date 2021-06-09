import os

from RobotFramework.parsers.pie_chart_parser import PieChartParser


def get_test_file_path(filename):
    """
    Gets the path to a file in the pie-chart fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', 'pie-chart', filename)


def execute_pie_chart_parser_test(filename_root):
    """
    Compares the output of the pie chart parser with the expected results
    :param filename_root: Base filename of the files containing the html to be parsed and the expected results
    """
    file_location = get_test_file_path('{0}.html'.format(filename_root))
    with open(file_location, 'r') as fp:
        pie_chart_svg = fp.read()
    file_location = get_test_file_path('{0}_expected.tsv'.format(filename_root))
    with open(file_location, 'r') as fp:
        pie_chart_expected_tsv = fp.read()
    pie_chart_parser = PieChartParser(pie_chart_svg)
    assert pie_chart_parser.convert_to_tsv() == pie_chart_expected_tsv


def test_pie_chart_parser_with_legend():
    """
    Tests a pie chart with a legend displayed
    """
    execute_pie_chart_parser_test('bh-management_operations_occupancy_occupancy-breakdown')


def test_pie_chart_parser_no_legend_present():
    """
    Tests a pie chart with no legend displayed
    """
    execute_pie_chart_parser_test('bh-management_operations_rents_loss-to-lease-distribution')


def test_pie_chart_parser_no_legend_present_repeat_colors():
    """
    Tests a pie chart with no legend displayed and colors repeated for different slices
    """
    execute_pie_chart_parser_test('bh-management_finances_capex_capex-per-unit-exterior-line-items')


def test_pie_chart_parser_with_legend_labels_in_tspan():
    """
    Tests a pie chart with the legend labels in the tspan (versus in a text element within the tspan)
    """
    execute_pie_chart_parser_test('bh-management_operations_delinquency_outstanding-balance-by-amount-owed')
