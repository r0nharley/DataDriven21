from importlib import import_module
import mock
import os

from RobotFramework.parsers.diff_tsv import diff_tsvs


def get_test_file_path(filename):
    """
    Gets the path to a file in the column-chart fixtures folder
    :param filename: Name of the file
    :return: Path to the file
    """
    return os.path.join('parsers', 'tests', 'fixtures', 'diff-tsv', filename)


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_passing_diff_equal(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    file_path = get_test_file_path('base_data_numeric.tsv')
    diff_tsvs(file_path, file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title              base      compare   percent   status', console=True),
        mock.call('x_value: y_value     100.0     100.0       0.0   equal ', console=True)
    ]
    mock_built_in_fail.assert_not_called()


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_passing_diff_within(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_numeric.tsv')
    compare_file_path = get_test_file_path('compare_data_numeric_within_range.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title              base      compare   percent   status   ', console=True),
        mock.call('x_value: y_value     100.0     104.0       4.0   within 5%', console=True)
    ]
    mock_built_in_fail.assert_not_called()


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_failing_diff_exceeds(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_numeric.tsv')
    compare_file_path = get_test_file_path('compare_data_numeric_exceeds_range.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title              base      compare   percent   status    ', console=True),
        mock.call('x_value: y_value     100.0     106.0       6.0   exceeds 5%', console=True)
    ]
    mock_built_in_fail.assert_called_with('significant differences found!')


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_failing_diff_extra_result_in_base(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('two_results_numeric.tsv')
    compare_file_path = get_test_file_path('base_data_numeric.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title                base      compare   percent   status      ', console=True),
        mock.call('x_value: y_value       100.0     100.0       0.0   equal       ', console=True),
        mock.call('x_value_2: y_value     100.0                       in base only', console=True)
    ]
    mock_built_in_fail.assert_called_with('significant differences found!')


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_failing_diff_extra_result_in_compare(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_numeric.tsv')
    compare_file_path = get_test_file_path('two_results_numeric.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title                base      compare   percent   status         ', console=True),
        mock.call('x_value: y_value       100.0     100.0       0.0   equal          ', console=True),
        mock.call('x_value_2: y_value               100.0             in compare only', console=True)
    ]
    mock_built_in_fail.assert_called_with('significant differences found!')


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_passing_diff_match(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    file_path = get_test_file_path('base_data_date.tsv')
    diff_tsvs(file_path, file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title              base         compare      percent   status', console=True),
        mock.call('x_value: y_value   07/11/2017   07/11/2017             match ', console=True)
    ]
    mock_built_in_fail.assert_not_called()


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_failing_diff_not_match(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_date.tsv')
    compare_file_path = get_test_file_path('compare_data_date.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title              base         compare      percent   status   ', console=True),
        mock.call('x_value: y_value   07/11/2017   07/10/2017             different', console=True)
    ]
    mock_built_in_fail.assert_called_with('significant differences found!')


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_failing_if_at_least_one_diff(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_numeric_two.tsv')
    compare_file_path = get_test_file_path('compare_data_numeric_two.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title                base      compare   percent   status    ', console=True),
        mock.call('x_value: y_value       100.0     106.0       6.0   exceeds 5%', console=True),
        mock.call('x_value_2: y_value     100.0     100.0       0.0   equal     ', console=True)
    ]
    mock_built_in_fail.assert_called_with('significant differences found!')


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_passing_match_includes_colors(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_numeric_with_color.tsv')
    compare_file_path = get_test_file_path('base_data_numeric_with_color.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title                    base      compare   percent   status', console=True),
        mock.call('x_value: y_value           100.0     100.0       0.0   equal ', console=True),
        mock.call('x_value: y_value:Color   #ffffff   #ffffff             match ', console=True)
    ]
    mock_built_in_fail.assert_not_called()


@mock.patch('RobotFramework.parsers.diff_tsv.get_settings')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.log')
@mock.patch('robot.libraries.BuiltIn.BuiltIn.fail')
def test_diff_tsv_failing_match_different_colors(mock_built_in_fail, mock_built_in_log, mock_get_settings):
    mock_get_settings.return_value = import_module('RobotFramework.settings.default')
    base_file_path = get_test_file_path('base_data_numeric_with_color.tsv')
    compare_file_path = get_test_file_path('compare_data_numeric_with_color.tsv')
    diff_tsvs(base_file_path, compare_file_path)
    assert mock_built_in_log.mock_calls == [
        mock.call('', console=True),
        mock.call('title                    base      compare   percent   status   ', console=True),
        mock.call('x_value: y_value           100.0     100.0       0.0   equal    ', console=True),
        mock.call('x_value: y_value:Color   #ffffff   #000000             different', console=True)
    ]
    mock_built_in_fail.assert_called_with('significant differences found!')
