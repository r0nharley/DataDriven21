import os
import logging
import re
import requests

ENVIRONMENTS = ['Prod', 'Staging', 'Staging-Blue', 'Staging-Green', 'Test', 'Local', 'KnownGood', 'Validation',
                'Integration', 'Verification', 'Genesis-Stag-Diff', 'KnownGood-RTP', 'KnownGood-GenesisRTP']

ENV_APP_URL_MAPPINGS = {
    'Staging': 'https://staging.rentlytics.com',
    'Staging-Blue': 'https://staging.rentlytics.com',
    'Staging-Green': 'https://staging-green.rentlytics.com',
    'Prod': 'https://secure.rentlytics.com',
    'Test': 'https://test.rentlytics.com',
    'Local': 'http://192.168.99.100',
    'Validation': 'https://validation.rentlytics.com',
    'Integration': 'https://integration.rentlytics.com',
    'Verification': 'https://verification.rentlytics.com',
    'Genesis-Stag-Diff': 'https://genesis-stag-diff.rentlytics.com'
}

ENV_ADMIN_URL_MAPPINGS = {
    'Staging': 'https://genesis.staging.rentlytics.com',
    'Prod': 'https://genesis.production.rentlytics.com',
    'Test': 'https://rl-genesis-test.herokuapp.com',
    'Local': 'http://192.168.99.100:8000',
    'Validation': 'https://rl-genesis-validation.herokuapp.com',
    'Integration': 'https://rl-genesis-integration.herokuapp.com',
    'Verification': 'https://rl-genesis-verification.herokuapp.com',
    'Genesis-Stag-Diff': 'https://genesis.staging.rentlytics.com'
}


def to_spinal_case(value):
    return '-'.join(value.lower().split())


def to_camel_case(value):
    return ''.join(x for x in value.title() if not x.isspace())


def camel_to_spinal_case(value):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1-\2', value)
    return re.sub('([a-z0-9])([A-Z])', r'\1-\2', s1).lower()


def clean_slug(value):
    return value.replace('---', '-').replace('(', '').replace(')', '').replace('-&', '').replace(',', '')


def remove_dashboard_prefixes(value):
    return value.replace('standard-all-', '').replace('standard-mds-', '').replace('standard-sds-', '')


def check_arguments_set(env1, env2):
    """
    :param env1: The environment argument
    :param env2: The comparison environment argument
    :return: (Boolean) True if the arguments are set correctly, False otherwise
    """
    if env1 is None or env2 is None:
        logging.error(
            'You did not specify two environments, --env1 and --env2 must both be set at run time'
        )
        return False
    if env1 == env2:
        logging.error(
            'You requested a diff of the same environment, {0}. The diff tests will not be generated.'.format(env1)
        )
        return False
    return True


def set_log_level(level, level_setting_overrides={}):
    """
    Set the logging configuration
    :param level: (str)  Log level
    :param level_setting_overrides: (dict) optional param for specifying log levels for specific apps
    """
    if level == 'DEBUG':
        logging_level = logging.DEBUG
    elif level == 'INFO':
        logging_level = logging.INFO
    else:
        logging_level = logging.WARNING
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=logging_level)
    for key in level_setting_overrides:
        logging.getLogger(key).setLevel(level_setting_overrides[key])


def clean_logs(log_dir):
    """
    Remove output.xml from a given log directory. This file can be huge and is used by RobotFramework to build log.html
    and report.html, but is not necessary once the HTML files haven been created
    :param log_dir:  Path to a log directory
    """
    if not os.path.exists(log_dir):
        logging.error('Directory does not exist: {0}'.format(log_dir))
        return
    try:
        logging.info('Cleaning log directory')
        os.remove(os.path.join(log_dir, 'output.xml'))
    except OSError:
        pass


def validate_credentials():
    """
    Check if the ROBOT_ADMIN_USERNAME and ROBOT_ADMIN_PASSWORD environment variables are set and set global variables
    if they are
    :return:  (str, str)  Validated username and password
    """
    try:
        username = os.environ['ROBOT_ADMIN_USERNAME']
        password = os.environ['ROBOT_ADMIN_PASSWORD']
        return username, password
    except KeyError, e:
        logging.critical('The env vars ROBOT_ADMIN_USERNAME and ROBOT_ADMIN_PASSWORD must be defined!')
        exit(1)


def login(env, username, password):
    """
    Attempt to log in the test user to the given URL
    ROBOT_ADMIN_USERNAME and ROBOT_ADMIN_PASSWORD must be declared as environment variables
    :param env: (str)  The environment to use to log in the test user
    :param username: (str)  Username to use to login
    :param password: (str)  Password to use to login
    :return:  (str, array)  Sessionid, List of organizations accessible to the test user
    """
    base_url = ENV_ADMIN_URL_MAPPINGS[env]
    url = '{0}/api/v1/user'.format(base_url)
    logging.info('Attempt to log in user {0} to {1}'.format(username, url))
    r = requests.post(
        url,
        data={
            'username': username,
            'password': password
        }
    )
    r.raise_for_status()
    logging.info('Login successful')

    sessionid = r.cookies['sessionid']
    organizations = r.json()['organizations']
    return sessionid, organizations


def get_valid_orgs(user_orgs, given_orgs, username):
    """
    Returns a list of organizations accessible to the test user
    :param user_orgs: (array)  List of organizations accessible to the test user
    :param given_orgs: (str)  Comma separated list of desired organizations
    :param username: (str)  Username used to fetch the orgs
    :return: (array)  List of desired orgs that are valid and accessible, or all test user orgs if given_orgs is empty
    """
    if not given_orgs:
        logging.info('No orgs were provided, processing all orgs accessible to {0}'.format(username))
        return user_orgs

    given_orgs = given_orgs.split(',')
    given_orgs = [x.strip() for x in given_orgs]
    valid_orgs = []
    for given_org in given_orgs:
        low_go = given_org.lower()
        valid_org = next((org for org in user_orgs if org['name'].lower() == low_go or org['slug'] == low_go), None)
        if valid_org:
            valid_orgs.append(valid_org)
        else:
            logging.error(
                'The given org {0} is either not valid or not accessible to the test user {1}'.format(
                    given_org, username
                )
            )
    return valid_orgs
