import argparse
import logging
import os
import re
import robot

# use psutil for os memory reporting
import psutil

# need to remove a directory of files, etc.
import shutil

# used for custom log output/results from the robot framework runs
from rl_logging.logging import combine_logs

from utils import to_camel_case, set_log_level, clean_logs, ENVIRONMENTS

script_dir = os.path.dirname(os.path.realpath(__file__))
extractors_dir = os.path.normpath(os.path.join(script_dir, '../Extractors'))
logs_dir = os.path.normpath(os.path.join(script_dir, '../logs'))


def get_extractor_files(env, orgs):
    """
    Given an environment and a list of orgs, return a list of valid extractor file paths present locally, grouped by
    organization
    :param env: (string)  The environment to use
    :param orgs: (array)  List of given organizations
    :return: (array)  List of valid extractor file paths
    """
    # directory where we will look for the extractor robot files
    env_extractor_dir = os.path.join(extractors_dir, env)

    # place to store the files we will return
    files = []

    if not orgs:
        logging.debug('No organizations provided, using all extractor files available in folder: {0}'
                      .format(env_extractor_dir))

        # no orgs specified, so loop all org folders and grab all the files, grouped by org
        for folder in os.listdir(env_extractor_dir):
            folder_path = os.path.join(env_extractor_dir, folder)

            if os.path.isdir(folder_path):
                # create an organization object to return
                current_org = {"name": folder, "files": []}

                # create an array to hold all of the files for this organization
                current_files = []

                for file in os.listdir(folder_path):
                    extractor_path = os.path.join(env_extractor_dir, folder, file)
                    logging.debug('Extractor file found : {0}'.format(extractor_path))
                    current_files.append(extractor_path)

                # only add files if they exist
                if len(current_files) > 0:
                    # append this organizations files into the returned files list
                    current_org["files"] = current_files
                    files.append(current_org)

    else:
        for org in orgs:
            # create an organization object to return
            current_org = {"name": org, "files": []}

            # create an array to hold all of the files for this organization
            current_files = []

            # get the path for the extractor files for this particular organization
            extractor_env_org_path = os.path.join(env_extractor_dir, to_camel_case(org))

            # if the path exists, grab files from it
            if os.path.exists(extractor_env_org_path):
                for file in os.listdir(extractor_env_org_path):
                    extractor_path = os.path.join(extractor_env_org_path, file)
                    logging.debug('Extractor file found for organization {0}: {1}'.format(org, extractor_path))
                    current_files.append(extractor_path)

            # also mark if there are not found extractors
            if len(current_files) == 0:
                logging.error('No extractors found for environment {0} and organization {1}'.format(env, org))
            else:
                # append this organizations files into the returned files list
                current_org["files"] = current_files
                files.append(current_org)

    return files


def extract_data(env, orgs, specified_files, include_in_logs):
    """
    Run robot extractions processes for all organizations with an extractor available for a given org.
    :param env: (str)  The environment for which the extractors should be located
    :param orgs: (str)  Comma separated list of organization names
    :param specified_files: (str)  (optional) If you only want to run only selected extraction robot files, provide a
    comma-delimited list of the file paths here.
    """
    ##
    # set the top-level test suite name for the combined tests. Otherwise,
    # it will be auto set as a concatenation of the names of all the sub
    # suites, which is hard to read and long.
    top_level_test_suite_name = "Extract ALL Organization Data"

    if orgs:
        ##
        # set the top_level_test_suite_name to include the name of the
        # organizations in the suite.
        top_level_test_suite_name = "Extract {0} Data".format(orgs)

        orgs = orgs.split(',')
        orgs = [x.strip() for x in orgs]

    # if specified extractor robot files were provide, just run them
    if specified_files:
        ##
        # loop the files, and parse out the org name from the file name, since we aren't supplying the org name when
        # specifying specific robot files to run.

        # store the orgs for reference
        current_orgs = {}

        files = []

        for file in specified_files.split(","):
            p = re.compile('^(.+/)*([^-]+)(.+).robot$')

            # will ensure the script acts the same in windows as well
            if os.sep == "\\":
                p = re.compile('^(.+\\\\)*([^-]+)(.+).robot$')

            current_org_name = p.search(file).group(2)

            if current_org_name not in current_orgs:
                current_orgs[current_org_name] = {"name": current_org_name, "files": []}

            current_orgs[current_org_name]["files"].append(file)

        # now, add the orgs to the returned files list
        for current_org in current_orgs:
            files.append(current_orgs[current_org])

    else:
        files = get_extractor_files(env, orgs)

    if not files:
        logging.critical('No extraction test files found.')
        exit(1)

    ##
    # collect a list of folders and files where we will pull output.xml files, so we can create one set of report/log
    # later, with organizations as the top-level test suite reference, that has everything, but isn't too cluttered, and
    # can delete the temporary files/folders afterwards.
    output_folders = []
    output_files = []

    ##
    # store references to the base logging folder, where we will combine all
    # of the separate robot runs into a single set of files.
    current_log_dir_base = os.path.join(logs_dir, 'extraction', env)

    # create the folder if it doesn't already exist
    if not os.path.exists(current_log_dir_base):
        os.makedirs(current_log_dir_base)

    # reference to the final rl_log.json file that will be used for final result output
    all_output_log = os.path.join(current_log_dir_base, 'rl_log.html')

    # Create a stdout extraction log file for the extraction
    stdout_all = os.path.join(current_log_dir_base, 'stdout.log')
    stdout_file = open(stdout_all, 'w+')
    stdout_file.close()

    # create a stderror file to log standard error too
    stderr_all = os.path.join(current_log_dir_base, 'stderr.log')
    stderr_file = open(stderr_all, 'w+')
    stderr_file.close()

    # default exit code
    exit_status = 0

    # loop the orgs in the returned files. org.name is the org name, org.files are the files for that org.
    for org in files:
        # extract from the current org
        status = extract_data_by_org(env, org, output_folders, output_files, stdout_all, stderr_all, include_in_logs)

        # log based on the status of the last robot run
        if status != 0:
            exit_status = status

    ##
    # combine all the output log files into one set of reports/logs, with
    # organizations as the top-level test suite reference, that has everything,
    # but isn't too cluttered.
    combine_logs(top_level_test_suite_name, output_folders, "html", all_output_log)

    # clean up the workspace
    clean_workspace(output_folders)

    exit(exit_status)


def clean_workspace(output_folders):
    # then, delete all the other reports/logs, except for the one master set
    for folder in output_folders:
        ##
        # now, delete the log files for this current robot run, now that they
        # have been recorded in our master files, and are no longer needed.
        shutil.rmtree(folder)


def extract_data_by_org(env, org, output_folders, output_files, stdout_all, stderr_all, include_in_logs):
    # set a default exit status
    exit_status = 0

    # log which organization we are currently processing
    logging.info('Extracting data for organization {0} on env {1}...'.format(org["name"], env))

    ##
    # collect all the output.xml robot run files for this org, so we can combine them into a single org-level
    # test suite later
    current_output_folders = []

    # setup the org log directory for storing logging files for the org-level test suite
    current_org_log_dir = os.path.join(logs_dir, 'extraction', env, to_camel_case(org["name"]))

    # create the org-level log dir if needed
    if not os.path.exists(current_org_log_dir):
        os.makedirs(current_org_log_dir)

    ##
    # store the list of org-level log directories, for deleting later, since they are temporary until all the
    # robot logs are generated
    output_folders.append(current_org_log_dir)

    # get a reference to the process for getting os ram usage
    process = psutil.Process(os.getpid())

    # store how many fails and passes we have
    pass_count = 0
    fail_count = 0

    for file in org["files"]:
        # grab the extractor name, without .robot at the end, from the file path, from a pattern match
        p = re.compile('^(.+/)*(.+).robot$')

        # will ensure the script acts the same in windows as well
        if os.sep == "\\":
            p = re.compile('^(.+\\\\)*(.+).robot$')

        # store the extractor name
        extractor_name = p.search(file).group(2)

        # log which extractor we are currently processing
        logging.info('Extracting data using extractor {0} ...'.format(file))

        # Create the log directory
        current_log_dir = os.path.join(logs_dir, 'extraction', env, to_camel_case(org["name"]), extractor_name)

        # if the extractor folder doesn't exist, create it
        if not os.path.exists(current_log_dir):
            os.makedirs(current_log_dir)

        extract_file_results = extract_data_by_org_extract_file(
            file,
            include_in_logs,
            current_log_dir,
            stdout_all,
            stderr_all
        )
        pass_count = pass_count + extract_file_results["pass_count"]
        fail_count = fail_count + extract_file_results["fail_count"]
        exit_status = extract_file_results["exit_status"]

        # add the current log folder and file to the lists of ones to combine later
        current_output_folders.append(current_log_dir)

        # Log that the extraction completed
        logging.info('Data extracted, log files location: {0}'.format(current_log_dir))

        # if we have had 3 or more failed tests in a row, fast fail the entire run
        if fail_count >= 3 and pass_count == 0:
            break

    ##
    # we have processed all the robot extract files for this org, now combine all the log files into an org-level test
    # suite.

    # set the name for the org-level test suite as it will appear in the reports/logs.
    current_test_suite_name = "Extract {0} Data".format(org["name"])

    # the reference to our combined log file
    current_output_file = os.path.join(current_org_log_dir, "rl_log.json")

    combine_logs(current_test_suite_name, current_output_folders, "json", current_output_file)

    # store this org-level test suite output.xml file, for combining later
    output_files.append(current_output_file)

    return exit_status


def extract_data_by_org_extract_file(file, include_in_logs, current_log_dir, stdout_all, stderr_all):
    # Used the stdout_all and strerr_all for the extraction, so they are all in one place
    stdout_file = open(stdout_all, 'a')
    stderr_file = open(stderr_all, 'a')

    return_results = {}
    return_results["pass_count"] = 0
    return_results["fail_count"] = 0
    return_results["exit_status"] = 0

    try:
        # record which extractor file is being used in the log
        stdout_file.write("Extracting Data using file {0} ...\n\n".format(file))

        # output os ram usage if specified
        if "SystemMemoryUsage" in include_in_logs:
            system_memory_usage = psutil.virtual_memory().used
            logging.info('System Memory Usage: {0} bytes'.format(system_memory_usage))
            stdout_file.write('System Memory Usage: {0} bytes\n\n'.format(system_memory_usage))

        # output process os ram usage if specified
        if "ProcessMemoryUsage" in include_in_logs:
            process_memory_usage = process.memory_info().rss
            logging.info('Process Memory Usage: {0} bytes'.format(process_memory_usage))
            stdout_file.write('Process Memory Usage: {0} bytes\n\n'.format(process_memory_usage))

        # run the extract robot file and extract data, passing in a listener with some parameters
        status = robot.run(file,
                           stdout=stdout_file,
                           stderr=stderr_file,
                           outputdir=current_log_dir,
                           output="NONE",
                           log="NONE",
                           report="NONE",
                           listener="rl_logging.log_listener:"+current_log_dir.encode("base64"))

        # add some spaces for easier reading of the log
        stdout_file.write("\n\n")

        # close the stdout for the current robot run, that we opened earlier
        stdout_file.close()
        stderr_file.close()

        # log based on the status of the last robot run
        if status != 0:
            return_results["fail_count"] = return_results["fail_count"] + 1
            logging.error('Data extraction ended with errors, please consult the logs for more details')
            return_results["exit_status"] = status
        else:
            return_results["pass_count"] = return_results["pass_count"] + 1

    except Exception:
        # error before closing the file descriptor, so close it now
        stdout_file.close()
        stderr_file.close()

        # throw the real robot.run error back up the chain
        raise

    return return_results


def main(log_level, env, orgs, files, include_in_logs):
    set_log_level(log_level)

    # default include_in_logs
    if include_in_logs is None:
        include_in_logs = []
    else:
        include_in_logs = include_in_logs.split(",")

    extract_data(env, orgs, files, include_in_logs)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Extract all data for a given environment and a list of organizations.  Expects that extractor '
                    'files exist in /Extractors/<env> for the organizations.  data_extractors_generator.py should be '
                    'ran before this script.'
    )
    parser.add_argument('-e',
                        '--env',
                        choices=ENVIRONMENTS,
                        default='Staging',
                        help='The environment from which the data will be extracted.')
    parser.add_argument('-o', '--orgs', type=str, help='Explicit list of organizations as a string, comma separated.')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    parser.add_argument('-f',
                        '--files',
                        type=str,
                        help="(optional) If you only want to run selected extraction robot files, "
                             "provide a comma delimited list of file paths.")
    parser.add_argument('-il', '--include_in_logs',
                        help='Include additional elements in the logs. A comma-delimited list of keywords. Allowed: '
                             'ProcessMemoryUsage, SystemMemoryUsage')
    args = parser.parse_args()
    main(args.log, args.env, args.orgs, args.files, args.include_in_logs)
