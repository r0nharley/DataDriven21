import argparse
import os
from collections import namedtuple

from utils import *

script_dir = os.path.dirname(os.path.realpath(__file__))
template_file = os.path.normpath(os.path.join(script_dir, '../Resources/Templates/OrgCompare.robot'))
compare_dir = os.path.normpath(os.path.join(script_dir, '../Compare'))

TEST_CASES_PLACEHOLDER = '#TEST_CASES'
TEST_PREFIX = 'DataDiff.Compare Data'

WidgetExtractor = namedtuple('WidgetExtractor', ['dashboard_name', 'dashboard_type', 'filename'])

##
# Ignoring these widgets because their data is not stable. This is a workaround and not a long term solution.
# WidgetExtractor('leasing-rents-rent-roll-expirations', 'visualization', 'chart10') - some of the returned data varied
# by just over 5%. Since we have a different chart of the same type on page that is being tests, can ingore this one.
IGNORED_DASHBOARD_WIDGETS = [
    WidgetExtractor('standard-all-marketing-conversion-funnel', 'visualization', 'chart3'),
    WidgetExtractor('standard-all-marketing-conversion-funnel', 'visualization', 'chart7'),
    WidgetExtractor('standard-all-marketing-conversion-funnel', 'visualization', 'chart13'),
    WidgetExtractor('standard-all-marketing-conversion-funnel', 'visualization', 'chart14'),
    WidgetExtractor('standard-all-marketing-leasing-results', 'visualization', 'chart2'),
    WidgetExtractor('standard-all-marketing-leasing-results', 'visualization', 'chart4'),
    WidgetExtractor('standard-all-marketing-overview', 'details', 'table2'),
    WidgetExtractor('standard-all-marketing-overview', 'visualization', 'chart5'),
    WidgetExtractor('standard-all-marketing-overview', 'visualization', 'chart6'),
    WidgetExtractor('standard-all-marketing-traffic-counts', 'visualization', 'chart5'),
    WidgetExtractor('standard-all-marketing-traffic-counts', 'visualization', 'chart6'),
    WidgetExtractor('standard-all-marketing-traffic-counts', 'visualization', 'chart7'),
    WidgetExtractor('standard-all-marketing-traffic-counts', 'visualization', 'chart8'),
    WidgetExtractor('standard-all-marketing-traffic-counts', 'visualization', 'chart9'),
    WidgetExtractor('standard-all-operations-delinquency', 'visualization', 'chart5'),
    WidgetExtractor('standard-all-operations-delinquency', 'visualization', 'chart6'),
    WidgetExtractor('standard-all-operations-delinquency', 'visualization', 'chart7'),
    WidgetExtractor('standard-all-operations-delinquency', 'visualization', 'chart8'),
    WidgetExtractor('standard-all-operations-delinquency', 'visualization', 'chart9'),
    WidgetExtractor('standard-all-operations-delinquency', 'visualization', 'kpis'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'details', 'table1'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'details', 'table3'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart1'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart10'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart11'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart12'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart13'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart2'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart3'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart4'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart7'),
    WidgetExtractor('standard-all-operations-future-occupancy', 'visualization', 'chart9'),
    WidgetExtractor('standard-all-operations-leases', 'visualization', 'chart1'),
    WidgetExtractor('standard-all-operations-leases', 'visualization', 'chart2'),
    WidgetExtractor('standard-all-operations-leases', 'visualization', 'chart3'),
    WidgetExtractor('standard-all-operations-leases', 'visualization', 'kpis'),
    WidgetExtractor('standard-all-operations-occupancy', 'visualization', 'chart1'),
    WidgetExtractor('standard-all-operations-occupancy', 'visualization', 'chart21'),
    WidgetExtractor('standard-all-operations-occupancy', 'visualization', 'chart22'),
    WidgetExtractor('standard-all-operations-occupancy', 'visualization', 'chart4'),
    WidgetExtractor('standard-all-operations-occupancy', 'visualization', 'chart5'),
    WidgetExtractor('standard-all-operations-occupancy', 'visualization', 'kpis'),
    WidgetExtractor('standard-all-operations-rent-per-sq-ft', 'visualization', 'chart2'),
    WidgetExtractor('standard-all-operations-rent-per-sq-ft', 'visualization', 'chart6'),
    WidgetExtractor('standard-all-operations-rent-per-sq-ft', 'visualization', 'chart7'),
    WidgetExtractor('standard-all-operations-rent-per-sq-ft', 'visualization', 'chart9'),
    WidgetExtractor('standard-all-operations-rents', 'visualization', 'chart2'),
    WidgetExtractor('standard-all-operations-rents', 'visualization', 'chart6'),
    WidgetExtractor('standard-all-operations-rents', 'visualization', 'chart7'),
    WidgetExtractor('standard-all-operations-rents', 'visualization', 'kpis'),
    WidgetExtractor('standard-all-operations-single-property', 'visualization', 'chart12'),
    WidgetExtractor('standard-sds-finances-capex', 'details', 'table1'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart1'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart11'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart13'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart2'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart3'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart4'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'chart5'),
    WidgetExtractor('standard-sds-finances-capex', 'visualization', 'kpis'),
    WidgetExtractor('standard-sds-overview-executive', 'details', 'table1'),
    WidgetExtractor('standard-sds-overview-executive', 'visualization', 'kpis'),
    WidgetExtractor('standard-sds-overview-lease-data-exceptions', 'details', 'table3'),
    WidgetExtractor('standard-sds-overview-lease-data-exceptions', 'details', 'table6'),
    WidgetExtractor('standard-sds-overview-lease-data-exceptions', 'visualization', 'chart2'),
    WidgetExtractor('standard-sds-overview-property-groupings', 'visualization', 'kpis'),
    WidgetExtractor('standard-sds-overview-property-groupings', 'visualization', 'table1'),
    WidgetExtractor('standard-sds-overview-vacant-unit-exceptions', 'details', 'table1'),
    WidgetExtractor('standard-sds-overview-vacant-unit-exceptions', 'details', 'table4'),
    WidgetExtractor('standard-sds-overview-vacant-unit-exceptions', 'details', 'table6'),
    WidgetExtractor('standard-sds-overview-vacant-unit-exceptions', 'visualization', 'chart1'),
    WidgetExtractor('standard-sds-overview-vacant-unit-exceptions', 'visualization', 'chart2'),
    WidgetExtractor('standard-all-marketing-leasing-results', 'visualization', 'chart6'),
    WidgetExtractor('standard-all-marketing-leasing-results', 'visualization', 'chart7'),
    WidgetExtractor('leasing-rents-rent-roll-expirations', 'visualization', 'chart10'),
    WidgetExtractor('leasing-rents-rent-roll-expirations', 'visualization', 'kpis'),
    WidgetExtractor('leasing-rents-rent-roll-expirations', 'visualization', 'table2'),
    WidgetExtractor('leasing-rents-rent-roll-expirations', 'visualization', 'chart2'),
    WidgetExtractor('leasing-rents-rent-roll-expirations', 'visualization', 'chart3'),
    WidgetExtractor('leasing-rents-rent-roll-expirations', 'details', 'table5'),
    WidgetExtractor('leasing-rents-summary', 'visualization', 'chart5'),
    WidgetExtractor('leasing-rents-summary', 'visualization', 'chart7')
]


def create_compare_tests(env1, env2, env1basepath, env2basepath):
    """
    Create the compare test files for two different environment, requires the data to have already be extracted using
    the org_tests_generator.py
    :param env1: (str)  The environment
    :param env2: (str)  The comparison environment
    :param env1basepath: (str)  The environment 1 folder base path
    :param env2basepath: (str)  The environment 2 folder base path
    """
    path_regression_central = script_dir.replace('automation', 'RegressionCentral')
    path_known_good = os.path.normpath(os.path.join(path_regression_central, "KnownGood"))

    ##
    # environment may contain the value KnownGood-<process or pipeline reference>, so split out KnownGood from the
    # process reference
    env1_info = env1.split("-")
    env2_info = env2.split("-")

    # set the paths either to the root of known good, or to where the ExtractedData folder is
    path_env1 = path_known_good if env1_info[0] == 'KnownGood' \
        else os.path.normpath(os.path.join(env1basepath, "ExtractedData"))
    path_env2 = path_known_good if env2_info[0] == 'KnownGood' \
        else os.path.normpath(os.path.join(env2basepath, "ExtractedData"))
    path_env1_base = env1basepath
    path_env2_base = env2basepath

    env1_orgs = os.listdir('{0}/{1}/'.format(path_env1, env1))
    env2_orgs = os.listdir('{0}/{1}/'.format(path_env2, env2))

    # extract the list of common organization between env1 and evn2
    orgs = []
    for org in env1_orgs:
        if org not in env2_orgs:
            logging.warn('The organization {0} is not present in {1}, so it won\'t be tested'.format(org, env2))
        else:
            orgs.append(org)
    for org in env2_orgs:
        if org not in env1_orgs:
            logging.warn('The organization {0} is not present in {1}, so it won\'t be tested'.format(org, env1))

    # Load the test template
    with open(template_file, 'r') as f:
        template_data = f.read()

    # Create the Compare folder
    if not os.path.exists(compare_dir):
        os.makedirs(compare_dir)

    if not orgs:
        logging.critical('No common orgs extracted data found between {0} and {1}'.format(env1, env2))
        exit(2)

    for org in orgs:
        logging.info('Creating compare file for {0} and {1} for organization: {2}'.format(env1, env2, org))

        # retrieve list of extracted data for env1 and env2
        data1 = os.listdir('{0}/{1}/{2}'.format(path_env1, env1, org))
        data2 = os.listdir('{0}/{1}/{2}'.format(path_env2, env2, org))

        # extract the list of common dashboards between env1 and env2
        dashboards = []
        for file in data1:
            if file not in data2:
                logging.warn(
                    'The file {0} is not present in {1}, so it won\'t be tested for '
                    'organization {2}'.format(file, env2, org)
                )
            else:
                dashboards.append(file)
        for file in data2:
            if file not in data1:
                logging.warn(
                    'The file {0} is not present in {1}, so it won\'t be tested for '
                    'organization {2}'.format(file, env1, org)
                )

        all_test_cases = []
        for dashboard_name in dashboards:
            for type in ['visualization', 'details']:
                dashboard_path = '{0}/{1}/{2}/{3}/{4}'.format(path_env1, env1, org, dashboard_name, type)
                if os.path.exists(dashboard_path):
                    files = os.listdir(dashboard_path)
                    for filename in files:
                        widget = WidgetExtractor(dashboard_name, type, filename.replace('.tsv', ''))
                        if widget in IGNORED_DASHBOARD_WIDGETS:
                            logging.info('Ignoring {}'.format(os.path.join(dashboard_path, filename)))
                        else:
                            all_test_cases.append(
                                'Compare Data {1} {2} {5}\n\t{0} {1} {2} {3} {4} {5} {6} {7}\n'.format(
                                    TEST_PREFIX, dashboard_name, type, '${ENV1}', '${ENV2}',
                                    filename, path_env1_base, path_env2_base
                                )
                            )

        all_test_cases_output = '{0}\n'.format('\n'.join(all_test_cases))

        # Update the test cases declarations for the test output file
        output = template_data.replace(TEST_CASES_PLACEHOLDER, all_test_cases_output)

        # Update the variables for the test output file
        output = output.replace('%env1%', str(env1))
        output = output.replace('%env2%', str(env2))
        output = output.replace('%name%', str(org))

        # Create the new test file
        test_file_path = os.path.join(compare_dir, '{0}-{1}-{2}-Compare.robot'.format(org, env1, env2))
        with open(test_file_path, 'w') as f:
            f.write(output)


def main(log_level, env1, env2, env1basepath, env2basepath):
    set_log_level(log_level, {'requests': logging.WARNING})

    # allow KnownGood to be mapped to RTP, to be backwards compatible
    if env1 == "KnownGood":
        env1 = "KnownGood-RTP"

    if env2 == "KnownGood":
        env2 = "KnownGood-RTP"

    if not check_arguments_set(env1, env2):
        exit(1)
    if not os.path.exists(compare_dir):
        os.makedirs(compare_dir)
    create_compare_tests(env1, env2, env1basepath, env2basepath)


if __name__ == '__main__':
    # set a default in case not environment paths are provided
    script_dir_base = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), "../"))

    parser = argparse.ArgumentParser(description='Create compare files for all organizations for two given '
                                                 'environments.  Expects that tsv for the organizations exists in'
                                                 '/ExtractedData/<env>/<org>.  extract_all_data.py should be ran '
                                                 'before this script.')
    parser.add_argument('--env1',
                        choices=ENVIRONMENTS,
                        help='The environment whose data will be considered the reference in the difference '
                             'comparison. KnownGood is the source of truth in the testing environments, it is created '
                             'and saved from a known good test run. There are separate known goods for different '
                             'pipelines. Allowed values: KnownGood, KnownGood-RTP, KnownGood-GenesisRTP. If KnownGood '
                             'is supplied, it will be treated as KnownGood-RTP .')
    parser.add_argument('--env2',
                        choices=ENVIRONMENTS,
                        help='The environment whose data will be compared to the reference in the difference '
                             'comparison. KnownGood is the source of truth in the testing environment, it is created '
                             'and saved from a known good test run. There are separate known goods for different '
                             'pipelines. Allowed values: KnownGood, KnownGood-RTP, KnownGood-GenesisRTP. If KnownGood '
                             'is supplied, it will be treated as KnownGood-RTP .')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    parser.add_argument('-env1basepath', '--env1basepath',
                        help='The path to the extracted data parent folder for environment 1', default=script_dir_base)
    parser.add_argument('-env2basepath', '--env2basepath',
                        help='The path to the extracted data parent folder for environment 2', default=script_dir_base)
    args = parser.parse_args()

    main(args.log, args.env1, args.env2, args.env1basepath, args.env2basepath)
