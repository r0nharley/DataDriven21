import os

from RobotFramework.parsers.pivot_table_parser import PivotTableParser


def get_test_file_path(filename):
    """
    Gets the path to a file in the pivot-table fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', 'pivot-table', filename)


def execute_pivot_table_parser_test(filename_root, sorted_table_series=''):
    """
    Compares the output of the pivot table parser with the expected results
    :param filename_root: Base filename of the files containing the html to be parsed and the expected results
    :param sorted_table_series: name of the series, if any, by which the table is sorted
    """
    file_location = get_test_file_path('{0}.html'.format(filename_root))
    with open(file_location, 'r') as fp:
        pivot_table_html = fp.read()
    file_location = get_test_file_path('{0}_expected.tsv'.format(filename_root))
    with open(file_location, 'r') as fp:
        pivot_table_expected_tsv = fp.read()
    pivot_table_parser = PivotTableParser(pivot_table_html, sorted_table_series)
    assert pivot_table_parser.convert_to_tsv() == pivot_table_expected_tsv


def test_pivot_table_parser_with_one_frozen_row_and_one_frozen_column():
    """
    Tests a simple pivot table
    """
    execute_pivot_table_parser_test('bh-management_overview_executive_operational-executive-summary')


def test_pivot_table_parser_with_multiple_frozen_rows_and_columns_with_colspan_and_rowspan():
    """
    Tests a complex pivot table with multiple frozen rows/columns and cells in the header that span
    Note that the html only has the frozen rows plus 8 other rows (otherwise the tsv is far too large to compare)
    """
    execute_pivot_table_parser_test('bh-management_finances_by-month_actual-per-unit-and-budget-variance-details')


def test_pivot_table_parser_with_multiple_frozen_rows_and_columns_with_colspan_and_rowspan():
    """
    Tests a complex pivot table with multiple frozen rows/columns and cells in the header that span
    Note that the html only has the frozen rows plus 8 other rows (otherwise the tsv is far too large to compare)
    """
    execute_pivot_table_parser_test('bh-management_overview_vacant-unit-exceptions_quick-turn-needed',
                                    'Turn Around Days')
