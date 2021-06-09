import os

from RobotFramework.parsers.column_chart_parser import ColumnChartParser


def get_test_file_path(filename):
    """
    Gets the path to a file in the column-chart fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', 'column-chart', filename)


def execute_column_chart_parser_test(filename_root, sorted_chart_series=''):
    """
    Compares the output of the column chart parser with the expected results
    :param filename_root: Base filename of the files containing the html to be parsed and the expected results
    :param sorted_chart_series: name of the series, if any, by which the chart is sorted
    """
    file_location = get_test_file_path('{0}.html'.format(filename_root))
    with open(file_location, 'r') as fp:
        column_chart_svg = fp.read()
    file_location = get_test_file_path('{0}_expected.tsv'.format(filename_root))
    with open(file_location, 'r') as fp:
        column_chart_expected_tsv = fp.read()
    column_chart_parser = ColumnChartParser(column_chart_svg, sorted_chart_series)
    assert column_chart_parser.convert_to_tsv() == column_chart_expected_tsv


def test_column_chart_parser_three_column_series():
    """
    Tests a column chart with three side-by-side series
    """
    execute_column_chart_parser_test('bh-management_operations_future-occupancy_future-occupancy-change-by-bedroom')


def test_column_chart_parser_one_column_positive_and_negative_values():
    """
    Tests a column chart with positive and negative values
    :return:
    """
    execute_column_chart_parser_test('demo_executive_overview_noi-budget-variance-by-property')


def test_column_chart_parser_stacked_column_chart_no_data_for_some_xaxis_values():
    """
    Tests a stacked column chart with blanks
    """
    execute_column_chart_parser_test('bh-management_operations_future-occupancy_future-move-ins-by-occupancy-status')


def test_column_chart_parser_stacked_column_chart_positive_and_negative_values_in_same_series():
    """
    Tests a stacked column chart with one series having positive and negative values
    """
    execute_column_chart_parser_test('demo_operations_single-property_avg-rent-by-lease-term')


def test_column_chart_parser_with_line_series():
    """
    Tests a column chart with a line series
    :return:
    """
    execute_column_chart_parser_test('livcor_finances_by-property_revenue-variance-by-property')


def test_column_chart_parser_two_column_series_with_line_series():
    """
    Tests a column chart with two side-by-side columns plus a line series
    """
    execute_column_chart_parser_test('livcor_finances_by-property_expenses-per-unit')


def test_column_chart_parser_stacked_column_with_line_series():
    """
    Tests a column chart with two side-by-side columns plus a line series
    """
    execute_column_chart_parser_test('bh-management_finances_budgeting-help_bad-debt-and-recovery-by-month')


def test_column_chart_conditionally_colored():
    """
    Tests a column chart with conditional colors
    """
    execute_column_chart_parser_test('bh-management_overview_executive_noi-budget-variance-by-property')


def test_column_chart_parser_grouped_axis():
    """
    Tests a column chart with a grouped axis this means there are two x axis, one on top and one on bottom
    """
    execute_column_chart_parser_test('demo_operations_future-occupancy_vacant-units-by-bedroom-rented-and-make-ready')


def test_column_chart_parser_with_yaxis_with_abbreviations():
    """
    Tests a column chart with positive and negative values
    :return:
    """
    execute_column_chart_parser_test(
        'bh-management_bh-custom_expenses-dashboard_total-monthly-expenses-other-property-costs'
    )


def test_column_chart_parser_with_sorted_series():
    """
    Tests a column chart with a sorted series
    :return:
    """
    execute_column_chart_parser_test('bh-management_marketing_leasing-results_cohort-move-ins-by-leasing-agent',
                                     'Move-Ins')


def test_column_chart_parser_with_sorted_series_and_navigator_present():
    """
    Tests a column chart with a sorted series and navigator present
    :return:
    """
    execute_column_chart_parser_test(
        'bh-management_marketing_conversion-funnel_cohort-cancel-and-denial-ratio-by-source', 'Cancellation Ratio'
    )


def test_column_chart_parser_with_sorted_series_and_navigator_not_present():
    """
    Tests a column chart with a sorted series and navigator not present
    :return:
    """
    execute_column_chart_parser_test('bh-management_operations_delinquency_dollars-delinquent-by-property',
                                     'Over 90 Days')
