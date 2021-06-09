import argparse
import logging
import os
import robot

from utils import set_log_level, validate_credentials, login, get_valid_orgs, clean_logs, ENV_APP_URL_MAPPINGS, \
    ENV_ADMIN_URL_MAPPINGS

script_dir = os.path.dirname(os.path.realpath(__file__))
logs_dir = os.path.normpath(os.path.join(script_dir, '../logs'))


def functional_tests(env, orgs, screenshots=0):
    """
    Run robot functional tests for all given organizations.
    :param env: (str)  The environment for which the extractors should be located
    :param orgs: (str)  Comma separated list of organization names
    """
    if not orgs:
        logging.critical('No valid organizations were provided.')
        exit(1)
    exit_status = 0

    for org in orgs:
        logging.info('Running functional tests for org {0} on env {1}...'.format(org['name'], env))
        current_log_dir = os.path.join(logs_dir, 'functional', env, org['slug'])
        if not os.path.exists(current_log_dir):
            os.makedirs(current_log_dir)
        # Create a stdout extraction log file and run the functional tests
        stdout = os.path.join(current_log_dir, 'stdout.log')
        stdout_file = open(stdout, 'w+')
        functional_tests_file = get_functional_tests_file(env)
        status = robot.run(functional_tests_file, stdout=stdout_file, outputdir=current_log_dir, variable=[
            'org_slug:{0}'.format(org['slug']),
            'app_url:{0}'.format(ENV_APP_URL_MAPPINGS[env]),
            'admin_url:{0}'.format(ENV_ADMIN_URL_MAPPINGS[env]),
            'include_screenshots:{0}'.format(screenshots)

        ])
        if status != 0:
            logging.error('Some or all functional tests failed for org {0}'.format(org['name']))
            exit_status = status
        stdout_file.close()
        clean_logs(current_log_dir)
        logging.info('Functional tests done, log file location: {0}'.format(current_log_dir))
    exit(exit_status)


def get_functional_tests_file(env):
    if env == 'Prod':
        return os.path.normpath(
            os.path.join(script_dir, '../RegressionCentral/FunctionalTestsProd.robot'))
    elif env == 'Validation':
        return os.path.normpath(
            os.path.join(script_dir, '../RegressionCentral/FunctionalTestsValidation.robot'))
    return os.path.normpath(os.path.join(script_dir, '../RegressionCentral/FunctionalTests.robot'))


def main(log_level, env, orgs, screenshots=0):
    set_log_level(log_level, {'requests': logging.WARNING})
    username, password = validate_credentials()
    sessionid, user_orgs = login(env, username, password)
    valid_orgs = get_valid_orgs(user_orgs, orgs, username)
    functional_tests(env, valid_orgs, screenshots)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Executes all functional tests for a given environment and a list of organizations.'
    )
    parser.add_argument('-e',
                        '--env',
                        choices=['Prod', 'Staging', 'Test', 'Local', 'Validation'],
                        default='Staging',
                        help='The environment on which the functional tests will be run.')
    parser.add_argument('-o', '--orgs', type=str, help='Explicit list of organizations as a string, comma separated.')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    parser.add_argument(
        '-s',
        '--screenshots',
        action='store_true',
        help='Whether or not to include screenshots, true or false'
    )
    args = parser.parse_args()
    main(args.log, args.env, args.orgs, args.screenshots)
