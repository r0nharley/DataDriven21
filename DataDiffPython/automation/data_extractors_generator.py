"""
Requires that mappings_generator.py already be run, and that the generated file is in the right place.
"""
from collections import namedtuple
import argparse
import json
import os
import logging
import requests

from utils import to_camel_case, remove_dashboard_prefixes, set_log_level, validate_credentials, login, \
    ENV_APP_URL_MAPPINGS, ENV_ADMIN_URL_MAPPINGS, get_valid_orgs, ENVIRONMENTS

script_dir = os.path.dirname(os.path.realpath(__file__))
template_file = os.path.normpath(os.path.join(script_dir, '../Resources/Templates/OrgExtractor.robot'))
extractors_dir = os.path.normpath(os.path.join(script_dir, '../Extractors'))
mappings_file = os.path.normpath(os.path.join(script_dir, '../Resources/Mappings/dashboards_widgets.json'))

TEST_CASES_PLACEHOLDER = '#TEST_CASES'
VARIABLES_PLACEHOLDER = '#VARIABLES'
TEST_PREFIX = 'DataExtractors.Extract Data'

OrganizationData = namedtuple('OrganizationData', ['name', 'slug', 'app_url', 'api_url', 'env', 'id'])

sessionid = None


def get_dashboard_slugs(org_data):
    """
    Fetch all dashboards that the test user has access to for a given URL and organization
    Discard any dashboards starting with "Unreleased"
    :param org_data: (OrganizationData)  The organization data
    :return:  (array)  List of dashboard slugs
    """
    # get the topics from the organization
    r = requests.get(
        '{0}/api/v1/topics'.format(org_data.api_url),
        headers={
            'cookie': 'sessionid={}'.format(sessionid),
            'organization-id': org_data.id
        }
    )
    r.raise_for_status()
    topics = r.json()
    # Discards any unwanted dashboards
    discard_slugs = ['unreleased', 'custom', 'beta']
    dashboard_slugs = [topic['slug'] for topic in topics if not any(x in topic['slug'].lower() for x in discard_slugs)]
    return dashboard_slugs


def get_sorted_items_output(dashboard_type, widget_types, dashboard_slug, type):
    """

    :param dashboard_type: (str) Can be 'visualization' or 'details'
    :param widget_types: (dict) Contains 'kpis', 'charts' and 'tables' keys
    :param dashboard_slug: (str)
    :param type: (str) Either 'charts' or 'tables'
    :return: The variable name to use for the extractor and the line output
    """
    widget_sorted_items_var_name = '{{{0}-{1}-sort-items-{2}}}'.format(
        remove_dashboard_prefixes(dashboard_slug),
        dashboard_type,
        type
    ).upper()
    widget_sorted_items = [
        c['sortedItem'].replace('#', '\\#') if c['sortedItem'] else 'None' for c in widget_types[type]
    ]
    if not widget_sorted_items:
        widget_sorted_items = ['empty_placeholder']
    widget_sorted_items_output = '\t'.join(widget_sorted_items)
    widget_sorted_items_line_output = '@{0}\t{1}'.format(widget_sorted_items_var_name, widget_sorted_items_output)
    return widget_sorted_items_var_name, widget_sorted_items_line_output


def update_orgs_extractors(env, orgs):
    """
    Update the extractor files for all orgs that the test user has access to for a given environment
    :param env: (str)  The environment to use
    :param orgs: (array)  The list of valid organizations to use
    """
    if not orgs:
        logging.critical('The list of valid organizations is empty, no extractor files will be created')
        exit(2)

    logging.info(
        'Creating extractor files for environment: {0} (this process can be long, please be patient)'.format(env)
    )
    # Load the org extractor template
    with open(template_file, 'r') as f:
        template_data = f.read()

    # Load the dashboards widgets mappings
    with open(mappings_file, 'r') as f:
        mappings = json.load(f)

    extractor_env_path = os.path.join(extractors_dir, env)
    if not os.path.exists(extractor_env_path):
        os.makedirs(extractor_env_path)

    dashboard_querystring = '?filter=1' if env in ['Test', 'Validation'] else '?'

    for org in orgs:
        org_data = OrganizationData(
            name=to_camel_case(org['name']),
            slug=org['slug'],
            app_url=ENV_APP_URL_MAPPINGS[env],
            api_url=ENV_ADMIN_URL_MAPPINGS[env],
            env=env,
            id=str(org['id'])
        )
        logging.debug('Updating extractors for org: {}...'.format(org_data.name))

        ##
        # create one extract folder for each organization, to store off the many extractor files, for better
        # organization
        extractor_env_org_path = os.path.join(extractor_env_path, org_data.name)
        if not os.path.exists(extractor_env_org_path):
            os.makedirs(extractor_env_org_path)

        # Fetch all dashboard slugs for the given organization
        dashboard_slugs = get_dashboard_slugs(org_data)

        for dashboard_slug in dashboard_slugs:
            try:
                dashboard = mappings[dashboard_slug]
            except KeyError, e:
                logging.warn('The dashboard {0} is not present in the mapping file, so it won\'t be extracted for '
                             'organization {1}'.format(dashboard_slug, org_data.name))
                continue

            # set a place to store the variables and test cases for the slug
            all_variables = []
            all_test_cases = []

            for dashboard_type in dashboard:
                widget_types = mappings[dashboard_slug][dashboard_type]
                chart_sorted_items_var_name, chart_sorted_items_line_output = get_sorted_items_output(
                    dashboard_type, widget_types, dashboard_slug, 'charts'
                )
                all_variables.append(chart_sorted_items_line_output)
                table_sorted_items_var_name, table_sorted_items_line_output = get_sorted_items_output(
                    dashboard_type, widget_types, dashboard_slug, 'tables'
                )
                all_variables.append(table_sorted_items_line_output)

                all_test_cases.append(
                    # Two spaces are required between arguments (don't ask, this is RobotFramework logic)
                    '\t{0}  {1}  {2}  {3}  {4}  {5}  {6}  {7}  ${8}  ${9}'.format(
                        TEST_PREFIX,
                        dashboard_slug,
                        remove_dashboard_prefixes(dashboard_slug),
                        dashboard_type,
                        dashboard_querystring,
                        len(widget_types['kpis']),
                        len(widget_types['charts']),
                        len(widget_types['tables']),
                        chart_sorted_items_var_name,
                        table_sorted_items_var_name
                    )
                )

            # format the variables and test cases
            all_variables_output = '{0}\n'.format('\n'.join(all_variables))
            all_test_cases_output = '{0}\n'.format('\n'.join(all_test_cases))

            # Update the variables declarations for the extractor output file
            output = template_data.replace(VARIABLES_PLACEHOLDER, all_variables_output)

            # Update the test cases declarations for the extractor output file
            output = output.replace(TEST_CASES_PLACEHOLDER, all_test_cases_output)

            # Update the variables for the extractor output file
            for key, val in org_data._asdict().iteritems():
                output = output.replace('%{0}%'.format(key), str(val))

            # Create the new extractor robot file for this slug and write it
            current_file_name = '{0}-{1}.robot'.format(org_data.name, dashboard_slug)
            extractor_file_path = os.path.join(extractor_env_org_path, current_file_name)
            with open(extractor_file_path, 'w') as f:
                f.write(output)

            # log which extractor we just created a robot file for
            logging.info('Updated extractor: {}'.format(extractor_file_path))

    logging.debug('Creating extractor files for environment: {0} - DONE'.format(env))
    logging.debug('Extractors path: {}'.format(os.path.join(extractors_dir, env)))


def main(log_level, env, orgs):
    set_log_level(log_level, {'requests': logging.WARNING})
    if not os.path.exists(extractors_dir):
        os.makedirs(extractors_dir)
    username, password = validate_credentials()
    logging.info('!!! This will create extractor files based on the organizations and dashboards accessible to the '
                 'user {0}'.format(username))
    logging.info('!!! Please make sure this user has the proper organizations and dashboard permissions set up for '
                 'the given environment!')
    global sessionid
    sessionid, user_orgs = login(env, username, password)
    valid_orgs = get_valid_orgs(user_orgs, orgs, username)
    update_orgs_extractors(env, valid_orgs)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create extractor files for all organizations for a given '
                                                 'environment.  Expects that /Resources/Mappings/dashboard_widgets.json'
                                                 ' exists.  mappings_generator.py should be ran before this script.')
    parser.add_argument('-e',
                        '--env',
                        choices=ENVIRONMENTS,
                        default='Staging',
                        help='The environment used to fetch the dashboard associated to each org')
    parser.add_argument('-o', '--orgs', type=str, help='Explicit list of organizations as a string, comma separated')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    args = parser.parse_args()
    main(args.log, args.env, args.orgs)
