import argparse
import logging
import os
import re
import robot

from utils import to_camel_case, check_arguments_set, set_log_level, clean_logs, ENVIRONMENTS

script_dir = os.path.dirname(os.path.realpath(__file__))
compare_tests_dir = os.path.normpath(os.path.join(script_dir, '../Compare'))
logs_dir = os.path.normpath(os.path.join(script_dir, '../logs'))


def get_compare_files(env1, env2, orgs):
    """
    Given an environment and a list of orgs, return a list of valid test file paths present locally
    :param env1: (string)  The reference environment
    :param env2: (string)  The environment to be compared against the reference
    :param orgs: (array)  List of given organizations
    :return: (array)  List of valid test paths
    """
    files = []
    if not orgs:
        logging.debug('No org provided, using all {0}-{1} test files available in folder: {2}'.format(
            env1, env2, compare_tests_dir
        ))
        files = [os.path.join(compare_tests_dir, f) for f in os.listdir(compare_tests_dir)
                 if os.path.isfile(os.path.join(compare_tests_dir, f)) and '-{0}-{1}-'.format(env1, env2) in f]
    else:
        for org in orgs:
            test_path = os.path.join(
                compare_tests_dir, '{0}-{1}-{2}-Compare.robot'.format(to_camel_case(org), env1, env2)
            )
            if os.path.isfile(test_path):
                logging.debug('Compare file found for organization {0}: {1}'.format(org, test_path))
                files.append(test_path)
            else:
                logging.error('No compare file found for environments {0}/{1} and organization {2}'.format(
                    env1, env2, org
                ))
    return files


def compare_data(env1, env2, orgs):
    """
    Run robot comparison processes for organizations diff'ing between two environments
    :param env1: (string)  The reference environment
    :param env2: (string)  The environment to be compared against the reference
    :param orgs: (str)  Comma separated list of organization names
    """
    if orgs:
        orgs = [x.strip() for x in orgs.split(',')]
    files = get_compare_files(env1, env2, orgs)
    if not files:
        logging.critical('No comparison test files found.')
        exit(1)

    exit_status = 0
    for file in files:
        # Get the name of the data compare file
        p = re.compile('^(.+/)*(.+).robot$')
        org_name = p.search(file).group(2)
        logging.info('Comparing data for org {0} on envs {1}/{2}...'.format(org_name, env1, env2))
        # Create the log directory
        current_log_dir = os.path.join(logs_dir, 'comparison', '{0}-{1}'.format(env1, env2), org_name)
        if not os.path.exists(current_log_dir):
            os.makedirs(current_log_dir)
        # Create a stdout comparison log file and run the comparison
        stdout = os.path.join(current_log_dir, 'stdout.log')
        stdout_file = open(stdout, 'w+')
        status = robot.run(file, stdout=stdout_file, outputdir=current_log_dir)
        if status != 0:
            logging.error('Data comparison ended with errors, please consult the logs for more details')
            exit_status = status
        stdout_file.close()
        clean_logs(current_log_dir)
        logging.info('Data compared, log files location: {0}'.format(current_log_dir))
    exit(exit_status)


def main(log_level, env1, env2, orgs):
    set_log_level(log_level)

    # allow KnownGood to be mapped to RTP, to be backwards compatible
    if env1 == "KnownGood":
        env1 = "KnownGood-RTP"

    if env2 == "KnownGood":
        env2 = "KnownGood-RTP"

    if not check_arguments_set(env1, env2):
        return
    if not os.path.exists(compare_tests_dir):
        logging.error('Compare folder ({0}) does not exist.  Nothing to compare.'.format(compare_tests_dir))
        return
    compare_data(env1, env2, orgs)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Compare all extracted data for a list of organizations between two given environments.  Expects '
                    'compare files to exist for the organizations and environments in /Compare.  '
                    'compare_tests_generator.py should be ran before this script.'
    )
    parser.add_argument('--env1',
                        choices=ENVIRONMENTS,
                        help='The environment whose data will be considered the reference.')
    parser.add_argument('--env2',
                        choices=ENVIRONMENTS,
                        help='The environment whose data will be compared to the reference.')
    parser.add_argument('-o', '--orgs', type=str, help='Explicit list of organizations as a string, comma separated.')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    args = parser.parse_args()
    main(args.log, args.env1, args.env2, args.orgs)
