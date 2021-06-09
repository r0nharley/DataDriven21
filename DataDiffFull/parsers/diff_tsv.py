from collections import namedtuple
from importlib import import_module

from robot.libraries.BuiltIn import BuiltIn

from utility import get_value, is_number


DataPoint = namedtuple('DataPoint', ['title', 'base', 'compare', 'diff_percent', 'status', 'passing'])


def load_from_tsv(file):
    """
    Loads a tsv file into a dictionary of values.
    Requires that the tsv file contain at least three values per line
    A fourth value, if present, in a line is considered to be a color
    :param file: the path to the tsv value
    :return: a dictionary of the data from the tsv
    """
    data = {}
    with open(file, 'r') as fp:
        tsv_content = fp.read()
    tsv_data = tsv_content.split('\n')
    for line in tsv_data:
        parts = line.split('\t')
        # skip if tsv is not formatted properly
        if len(parts) < 3:
            continue
        if parts[0] not in data:
            data[parts[0]] = {}
        data[parts[0]][parts[1]] = parts[2]
        if len(parts) >= 4:
            data[parts[0]]['{}:{}'.format(parts[1], 'Color')] = parts[3]
    return data


def diff_data(base_data, compare_data, base_env_name, compare_env_name, settings):
    """
    Compares two sets of data and records whether data present in both exceeds the allowed diff percent or not.
    Additionally records when data in present in only one of the dictionaries.
    :param base_data: the dictionary for the base data
    :param compare_data: the dictionary for the compare data
    :param base_env_name: name to use for the base data, typically an environment (i.e. Staging)
    :param compare_env_name: name to use for the compare data, typically an environment (i.e. Production)
    :param settings: settings to use in the diff
    :return: an array of results
    """
    diff_results = []
    for base_data_key in base_data:
        for base_data_subkey in base_data[base_data_key]:
            title = '{0}: {1}'.format(base_data_key, base_data_subkey)
            base = get_value(base_data[base_data_key][base_data_subkey])
            if base_data_key in compare_data and base_data_subkey in compare_data[base_data_key]:
                compare = get_value(compare_data[base_data_key][base_data_subkey])
                if base == compare:
                    if is_number(base):
                        diff_percent = 0
                        status = 'equal'
                    else:
                        diff_percent = None
                        status = 'match'
                    passing = True
                else:
                    if is_number(base) and is_number(compare):
                        threshold = settings.threshold_overrides[base_data_key][base_data_subkey] if \
                            base_data_key in settings.threshold_overrides \
                            and base_data_subkey in settings.threshold_overrides[base_data_key] \
                            else settings.threshold_percent
                        denominator = compare if base == 0 else base
                        diff_percent = abs(100.0 * (base - compare) / denominator)
                        passing = diff_percent <= threshold
                        status = '{0} {1}'.format('within' if passing else 'exceeds', '{}%'.format(threshold))
                    else:
                        diff_percent = None
                        passing = False
                        status = 'different'

            else:
                compare = None
                diff_percent = None
                status = 'in {} only'.format(base_env_name)
                passing = False
            diff_results.append(DataPoint(title=title, base=base, compare=compare, diff_percent=diff_percent,
                                          status=status, passing=passing))
    for compare_data_key in compare_data:
        for compare_data_subkey in compare_data[compare_data_key]:
            if compare_data_key not in base_data or compare_data_subkey not in base_data[compare_data_key]:
                title = '{0}: {1}'.format(compare_data_key, compare_data_subkey)
                diff_results.append(DataPoint(title=title, base=None,
                                              compare=get_value(compare_data[compare_data_key][compare_data_subkey]),
                                              diff_percent=None, status='in {} only'.format(compare_env_name),
                                              passing=False))
    return diff_results


def format_data_string(value, size=0):
    """
    Formats value as a string.
    :param value: value to be formatted as a string
    :param size: if value is numeric, the desired string length
    :return: formatted string
    """
    if is_number(value):
        return_format = '{{:{0}.1f}}'.format(size if size > 0 else '')
        return return_format.format(value)
    if value:
        return value
    return ''


def format_env(env_string):
    """
    Formats the environment name
    :param env_string: environment name
    :return: formatted environment name
    """
    formatted = env_string.lower()
    formatted = formatted.replace(' ', '')
    return formatted


def get_log_format(diffs, base_env_name, compare_env_name):
    """
    Gets the desired log format based on the max length of data for each item in the log
    :param diffs: an array of DataPoints with the data from the diff
    :param base_env_name: name to use for the base data, typically an environment (i.e. Staging)
    :param compare_env_name: name to use for the compare data, typically an environment (i.e. Production)
    :return: the log format as a string, the max length of the data field, the max length of the percent field
    """
    max_title_length = max(max([len(x.title) for x in diffs]), len('title'))
    max_base_length = max(max([len(format_data_string(x.base)) for x in diffs]), len(base_env_name))
    max_compare_length = max(max([len(format_data_string(x.compare)) for x in diffs]), len(compare_env_name))
    max_data_length = max(max_base_length, max_compare_length)
    max_diff_percent_length = max(max([len(format_data_string(x.diff_percent)) for x in diffs]), len('percent'))
    max_status_length = max(max([len(x.status) for x in diffs]), len('status'))

    log_format = '{{:{0}}}   {{:{1}}}   {{:{1}}}   {{:{2}}}   {{:{3}}}'.format(max_title_length, max_data_length,
                                                                               max_diff_percent_length,
                                                                               max_status_length)
    return [log_format, max_data_length, max_diff_percent_length]


def get_settings(base_env_name, compare_env_name):
    """
    Gets the settings file for the specific env vs env compare.  If non-existent, just gets the defaults
    :param base_env_name: name to use for the base data, typically an environment (i.e. Staging)
    :param compare_env_name: name to use for the compare data, typically an environment (i.e. Production)
    :return: the settings for the specific env vs env compare
    """
    try:
        settings = import_module('settings.{}_vs_{}'.format(format_env(compare_env_name), format_env(base_env_name)))
    except Exception as e:
        settings = import_module('settings.default')

    return settings


def log_diffs(builtin, diffs, base_env_name, compare_env_name):
    """
    Logs to the RobotFramework console the individual diffs
    :param builtin: the BuiltIn instance to which the function will log
    :param diffs: an array of DataPoints with the data from the diff
    :param base_env_name: name to use for the base data, typically an environment (i.e. Staging)
    :param compare_env_name: name to use for the compare data, typically an environment (i.e. Production)
    """
    builtin.log('', console=True)
    log_format, data_length, percent_length = get_log_format(diffs, base_env_name, compare_env_name)
    headers = log_format.format('title', base_env_name, compare_env_name, 'percent', 'status')
    builtin.log(headers, console=True)
    diffs.sort(key=lambda x: x.title)
    for diff in diffs:
        line = log_format.format(diff.title, format_data_string(diff.base, data_length),
                                 format_data_string(diff.compare, data_length),
                                 format_data_string(diff.diff_percent, percent_length), diff.status)
        builtin.log(line, console=True)


def diff_tsvs(base_file, compare_file, base_env_name='base', compare_env_name='compare'):
    """
    Custom Robot Framework method for comparing two tsv files
    Will fail the test if any of the data is outside of expectations
    :param base_file: path to the file containing the tsv data for the base
    :param compare_file: path to the file containing the tsv data to compare to the base
    :param base_env_name: name to use for the base data, typically an environment (i.e. Staging)
    :param compare_env_name: name to use for the compare data, typically an environment (i.e. Production)
    """
    builtin = BuiltIn()
    settings = get_settings(base_env_name, compare_env_name)
    base_data = load_from_tsv(base_file)
    compare_data = load_from_tsv(compare_file)
    diff_results = diff_data(base_data, compare_data, base_env_name, compare_env_name, settings)

    if not diff_results:
        builtin.pass_execution('Both tsvs are empty')
        return
    log_diffs(builtin, diff_results, base_env_name, compare_env_name)

    if not all(x.passing for x in diff_results):
        builtin.fail('significant differences found!')
