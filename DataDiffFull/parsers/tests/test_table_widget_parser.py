import os

from RobotFramework.parsers.table_widget_parser import TableWidgetParser


def get_test_file_path(filename):
    """
    Gets the path to a file in the table-widget fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', 'table-widget', filename)


def execute_table_widget_parser_test(filename_root, sorted_table_series=''):
    """
    Compares the output of the table widget parser with the expected results
    :param filename_root: Base filename of the files containing the html to be parsed and the expected results
    :param sorted_table_series: name of the series, if any, by which the table is sorted
    """
    file_location = get_test_file_path('{0}.html'.format(filename_root))
    with open(file_location, 'r') as fp:
        table_widget_html = fp.read()
    file_location = get_test_file_path('{0}_expected.tsv'.format(filename_root))
    with open(file_location, 'r') as fp:
        table_widget_expected_tsv = fp.read()
    table_widget_parser = TableWidgetParser(table_widget_html, sorted_table_series)
    assert table_widget_parser.convert_to_tsv() == table_widget_expected_tsv


def test_table_widget_parser_with_single_columns_as_unique_key():
    """
    Tests a simple table widget with one column as the unqiue key for a row
    """
    execute_table_widget_parser_test('bh-management_operations_single-property_detailed-resident-records')


def test_table_widget_parser_with_two_columns_as_unique_key():
    """
    Tests a table widget with two columns as the unqiue key for a row
    """
    execute_table_widget_parser_test('bh-management_operations_future-occupancy_future-move-ins-records')


def test_table_widget_parser_with_sorted_series():
    """
    Tests a table widget with a sorted series
    """
    execute_table_widget_parser_test('bh-management_overview_vacant-unit-exceptions_units-listed-as-not-ready-chart2',
                                     'Listed Make Ready Date')
