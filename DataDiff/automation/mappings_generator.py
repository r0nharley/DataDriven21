import logging
import argparse
import os
import shutil
import sys
import tempfile

from sh import git
from urlparse import urlparse, urlunparse
from mappings_dashboard_data import *


script_dir = os.path.dirname(os.path.realpath(__file__))
mappings_dir = os.path.normpath(os.path.join(script_dir, '../Resources/Mappings'))
mappings_file = os.path.join(mappings_dir, 'dashboards_widgets.json')


def get_sisense_cloned_repo():
    """
    Clone the Sisense repo to a temporary directory and return its path
    :return: (str)  Path of the temp dir
    """
    for env_var in ['GITHUB_REPO', 'GITHUB_USERNAME', 'GITHUB_PASSWORD', 'GIT_BRANCH_NAME']:
        if env_var not in os.environ:
            logging.critical(
                'Env var {0} is not set! Please run "source automation/pull_secrets.sh" first.'.format(env_var)
            )
            exit(1)

    repo = os.environ['GITHUB_REPO']
    branch = os.environ['GIT_BRANCH_NAME']
    logging.info('Fetching Sisense Git repo from {0}, branch {1}...'.format(repo, branch))
    temp_dir = tempfile.mkdtemp()
    try:
        repo_url = list(urlparse(repo))
        repo_url[1] = "{username}:{password}@{netloc}".format(
                username=os.environ['GITHUB_USERNAME'],
                password=os.environ['GITHUB_PASSWORD'],
                netloc=repo_url[1]
        )

        repo_url = urlunparse(repo_url)
        logging.info('Cloning repository in temp dir {0}...'.format(temp_dir))
        git.clone(repo_url, temp_dir, _tty_out=False, _tty_in=False)
        os.chdir(temp_dir)
        git.checkout(branch, _tty_out=False, _tty_in=False)

        logging.info('Fetching Sisense Git repo - DONE')
        return temp_dir
    except:
        logging.critical('Unexpected error: {0}'.format(sys.exc_info()[0]))
        exit(2)


def clean_temp_dashboards(temp_path):
    """
    Delete a given directory
    :param temp_path: (str)  Path to the temporary directory to delete
    """
    logging.info('Removing Sisense temp dir: {0}'.format(temp_path))
    shutil.rmtree(temp_path)


def get_valid_path(path):
    """
    Check if a given path is valid. Raise an exception if not.
    :param path: (str)  The path to validate. Can be absolute or relative
    :return: (str)  The validated path
    """
    if os.path.isdir(path):
        valid_dir = path
    elif os.path.isdir(os.path.join(script_dir, path)):
        valid_dir = os.path.join(script_dir, path)
    else:
        logging.critical('{0} is not a valid directory'.format(path))
        exit(3)
    return valid_dir


def main(log_level, dashboards_path=None, dashboards_list="", topics_list=""):
    set_log_level(log_level, {'sh': logging.WARNING})

    if not os.path.exists(mappings_dir):
        os.makedirs(mappings_dir)

    # Empty the content of the mapping file or create it
    with open(mappings_file, "w"):
        pass

    clean_temp = False
    if dashboards_path:
        dashboards_dir = get_valid_path(dashboards_path)
    else:
        clean_temp = True
        sisense_temp_dir = get_sisense_cloned_repo()
        dashboards_dir = os.path.join(sisense_temp_dir, 'dashboards')

    extract_dashboards_data(dashboards_dir, dashboards_list, topics_list, mappings_file)

    if clean_temp:
        clean_temp_dashboards(sisense_temp_dir)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create all dashboards widgets mappings based on Sisense dashboards '
                                                 'definition files that are not "Unreleased".')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    parser.add_argument('-p', '--path',
                        help='Path to a local Sisense dashboards folder. Fetch from Sisense Git repo if not provided.')

    # allow a list of dashboards to be supplied
    parser.add_argument('-d',
                        '--dashboards',
                        default="",
                        type=str,
                        help='A comma-delimited list of dashboards to create mappings for. '
                             'i.e. "BH Custom,Abacus Custom"')

    # allow a list of topics to be supplied
    parser.add_argument('-t',
                        '--topics',
                        default="",
                        type=str,
                        help='A comma-delimited list of topics to create mappings for. '
                             'i.e. "BH Custom,Abacus Custom"')

    args = parser.parse_args()
    main(args.log, args.path, args.dashboards, args.topics)
