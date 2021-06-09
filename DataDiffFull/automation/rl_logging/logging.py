# logging utility function used with automation and the robot framework

import json
import time
import os
import jinja2
import uuid
import shutil


class HTMLFormatter:
    """
    This is a formatter class, specifically for taking a standard data set, and outputting it in an HTML format.
    """

    def __init__(self, data, file_path=""):
        """
        Initialize the formatter prior to running "format"

        :param data: A standardized python data object
        :param file_path: (optional) If supplied, generated content will be saved to the file path, otherwise, returned
        as a string
        """
        self.data = data
        self.file_path = file_path

        # a place to keep track of parent pointers, using id
        self.parents = {}

        self.next_index = 0

        # get the template directory
        script_dir = os.path.dirname(os.path.realpath(__file__))
        template_dir = os.path.join(script_dir, "templates/html/").replace("\\", "/")

        # get a reference for all of the html templates we will be using
        self.templates = jinja2.Environment(
            loader=jinja2.FileSystemLoader(template_dir)
        )

    def get_object_index(self):
        """
        Helper function to return an unique integer, used to label and keep track of objects and what parent they point
        to.

        :return: Integer index value that hasn't been used yet
        """
        next_index = self.next_index
        self.next_index = self.next_index + 1
        return next_index

    def format(self):
        """
        Format's the provided data into an HTML version of it. Uses "formatter" as a recursive function, to build out
        the HTML/DOM. Uses the data and file_path variables stored in self from the initialization function.

        :return:
        """
        data = self.data
        file_path = self.file_path

        return_output = ""

        # pass the needed data to the templater as a context
        context = {"data": data, "time": time, "content": self.formatter(data, None)}

        # use the templater to generate the output content
        output = self.templates.get_template("rl_log.html").render(context)

        return_output = output

        if file_path != "":
            log_file = open(file_path, 'w')
            log_file.write(output)
            log_file.close()
            return_output = True

        return return_output

    def formatter(self, data, parent):
        """
        A recursive building function, to build out HTML output for the elements in the data.

        :param data: The data that should be used for this formatting run.
        :return:
        """

        # give each object a new id, and store the parent, for reference
        data["id"] = self.get_object_index()
        self.parents[data["id"]] = parent

        tests_output = ""
        keywords_output = ""

        if "tests" in data:
            for test in data["tests"]:
                tests_output = tests_output + self.formatter(test, data)

        if "keywords" in data:
            for keyword in data["keywords"]:
                keywords_output = keywords_output + self.format_keyword(keyword, data)

            keywords_output = "<div class=\"keywords\">{0}</div>".encode("utf-8").format(keywords_output)

        if data["message_count"] > 0:
            logging_content = self.format_logging(data, parent)

        # setup the templater data
        context = {
            "data": data,
            "collapse_badge_content": self.collapse_badge(),
            "status_badge_content": self.status_badge(data["status"]),
            "error_content": self.format_errors(data),
            "tests_content": tests_output,
            "keywords_content": keywords_output,
            "logging_content": self.format_logging(data, parent)
        }

        # use the templater to generate the content
        output = self.templates.get_template("rl_log_test_item.html").render(context)

        return output

    def format_errors(self, data):
        """
        A helper function, used with "formatter", to format just the errors/failures

        :param data: The data to format on
        :return: HTML in string output
        """

        output = ""

        if data["type"] == "Test":

            if "message" in data["error"] and data["error"]["message"] != "":
                error = data["error"]
                output = output + self.format_error(error)

        else:
            if len(data["errors"]):

                for error in data["errors"]:
                    output = output + self.format_error(error)

        # now, only generate output if there is error output
        if output != "":
            output_front = "<div class=\"errors-container\"><div class=\"heading\">"
            output_middle = "<div>Errors:</div></div><div class=\"errors\">"
            output = "{2}{1}{3}{0}</div></div>".encode("utf-8").format(output,
                                                                       self.collapse_badge(),
                                                                       output_front,
                                                                       output_middle)

        return output

    def format_error(self, error):
        suite = ""

        is_first = 0
        for i in error["suites"]:
            if is_first:
                suite = suite + " -> "
            else:
                is_first = 1
            suite = suite + i

        context = {
            "message": error["message"],
            "suite": suite,
            "test": error["test"],
            "keyword": error["keyword"]
        }

        return self.templates.get_template("rl_log_error.html").render(context)

    def format_logging(self, data, parent):
        """
        Used to format the log messages into html

        :param data: An array of log message items
        :return: HTML as a string
        """
        # loop through the log message items, use a template to generate html output, and return that output
        output = ""
        log_file_path = ""

        if data["message_count"] > 0:
            # has log messages, so now build the url to the file that contains them. Need to find the first parent up
            # the chain that is a suite, and then trace all suites up to the root
            # setup a stack to store the suite references in the right order
            suite_parents = []
            current_parent = parent

            while current_parent is not None:
                # only process if the current parent is a suite
                if "type" in current_parent and current_parent["type"] == "Suite":
                    suite_parents.insert(0, current_parent["log_uuid"])

                current_parent = self.parents[current_parent["id"]]

            if len(suite_parents) > 0:
                # we have the file chain. Now, add the last file name reference and convert the list to a web path
                suite_parents.append("{0}.json".format(data["log_uuid"]))

                log_file_path = "rl_log_messages"
                for i in suite_parents:
                    log_file_path = os.path.join(log_file_path, i)

            context = {
                "log_file_path": log_file_path.replace("\\", "/")
            }

            output = self.templates.get_template("rl_log_messages.html").render(context)

        return output

    def format_keyword(self, data, parent):
        """
        Recursive function for generating HTML for a keyword, which can have children keywords

        :param data: The data to process as a keyword
        :return:
        """

        # give each object a new id, and store the parent, for reference
        data["id"] = self.get_object_index()
        self.parents[data["id"]] = parent

        # get the generated content for the keywords recursively, to add to the context for the current keyword output.
        current_keyword_content = ""

        for keyword in data["keywords"]:
            current_keyword_content = current_keyword_content + self.format_keyword(keyword, data)

        collapse_badge_content = ""

        if current_keyword_content != "" or data["message_count"] > 0:
            collapse_badge_content = self.collapse_badge()

        context = {
            "name": data["keyword"],
            "status_badge_content": self.status_badge(data["status"]),
            "keywords": current_keyword_content,
            "collapse_badge_content": collapse_badge_content,
            "logging_content": self.format_logging(data, parent)
        }

        return self.templates.get_template("rl_log_keyword.html").render(context)

    def collapse_badge(self):
        """
        Creates the expand-collapse element, for each suite/test

        :return:
        """

        return "<a href='javascript:void(0);' class='badge hide-show'>+</a>"

    def status_badge(self, status):
        """
        Creates the Pass/Fail indicator, for each suite/test/keyword
        :param status:
        :return:
        """

        return "<div class=\"badge {0}\">{1}</div>".encode("utf-8").format(status.lower(), status)


def get_uuid(uuids):
    """
    Returns a unique UUID, and keeps track of past ones, so we always return one that hasn't yet been returned.
    :return: String representing a unique UUID
    """
    current_uuid = str(uuid.uuid4())

    # keep looping and getting a unique id, until we found one we haven't used before
    while current_uuid in uuids:
        current_uuid = str(uuid.uuid4())

    # now, store that uuid, so we remember we've used it already
    uuids.append(current_uuid)

    return current_uuid


def format_log_data(data, format="variable", file_path="", formatter=HTMLFormatter):
    """
    Use this function to take our data from the robot runs, format them into a single output file. Log messages will
    be saved as separate files, referenced by the single output file, due to potential size and resource issues with the
    log messages.

    :param data: A python variable representing the data, or a full file path to a json file that represents the data.
    :param format: (optional) The format you want as output. The following are allowed: json, html, custom . If an
    empty string is supplied, the data is returned as a variable.
    :param file_path: (optional) If a full file path is supplied, output will be saved as that file. Otherwise,
    returned as a string or variable, depending on what format is supplied. The log messages will only be copied if a
    file path is provided due to potential resource issues with that data.
    :param formatter: (optional) Used if you provide format=custom, as the formatter class to use for formatting the
    output that is returned
    :return: Either True if a file path is supplied, a string of the data if a format is supplied, or a variable with
    the data if no format is supplied
    """
    # set a default output and data for the function
    output = ""

    # if data is a file, open it as data
    if isinstance(data, str):
        data_file_path = data
        data = deserialize_json(data_file_path)

    if format == "json":
        if file_path == "":
            # no file path supplied, so assume they want the results returned as a json string
            output = json.dump(data)
        else:
            # they provided a file, write the data as json to file
            log_file = open(file_path, 'w+')
            json.dump(data, log_file)
            log_file.close()

            output = True
    elif format == "html":
        # use our default html formatter
        formatter_obj = HTMLFormatter(data, file_path)
        output = formatter_obj.format()

    elif format == "custom":
        # just run the provided formater
        formatter_obj = formatter(data, file_path)
        output = formatter_obj.format()

    else:
        # assume anything else means they just want the variable back
        output = data

    return output


def copy_log_messages(source_path, destination_path):
    """
    Given a source and destinatio paths, copy the top-level suite folder for the log messages, from the source, to the
    destination. If the destination doesn't already exist, it will be created.

    :param source_path: (String) Source path name for a specific suite log messages
    :param destination_path: The base path where the origin_path should be copied to
    :return:
    """
    output = False
    if os.path.exists(source_path):
        shutil.copytree(source_path, destination_path)
        output = True
    else:
        raise Exception("Source path doesn't exist, or destination path already exists")

    return output


def combine_logs_process_log(data, log_path, file_path, uuids, test_suite_name):
    """
    A helper function for combine_logs. Processes a single log file and adds it to the data

    :param data: The data object from combine_logs
    :param log_path: A log path to use for logs to add to the data
    """

    log = os.path.join(log_path, "rl_log.json")

    # convert the file json into an object we can work with
    current_test_suite = deserialize_json(log)

    data["tests"].append(current_test_suite)

    # accumulate how many total tests there are
    data["total_tests"] = data["total_tests"] + current_test_suite["total_tests"]

    # if the current suite failed, mark the new top-level suite as failed as well
    if current_test_suite["status"] == "FAIL":
        data["status"] = "FAIL"

        # accumulate how many failed tests there are
        data["total_failures"] = data["total_failures"] + current_test_suite["total_failures"]

        for error in current_test_suite["errors"]:
            ##
            # the top-level suite will want to know what the name of the suite that error-ed was, so add it to
            # an array like a stake trace
            error["suites"].insert(0, test_suite_name)

            data["errors"].append(error)

    ##
    # now, copy the log message top-level suite folder to be in the same directory as the new output file, if a
    # file path is provided
    if file_path != "" and current_test_suite["has_messages"] > 0:
        ##
        # there are messages, but since we are combining logs, want to make sure the same uuid hasn't been used
        # twice for top-level objects, so check
        destination_uuid = current_test_suite["log_uuid"]
        if current_test_suite["log_uuid"] in uuids:
            # this uuid has already been used, so assign a new one
            destination_uuid = get_uuid(uuids)

        copy_log_messages(os.path.join(log_path, "rl_log_messages", current_test_suite["log_uuid"]),
                          os.path.join(os.path.dirname(file_path),
                                       "rl_log_messages", data["log_uuid"], destination_uuid))

        # now, in the data, also assign the correct uuid
        current_test_suite["log_uuid"] = destination_uuid

        # also, mark that the top-level suite has log messages
        data["has_messages"] = data["has_messages"] + current_test_suite["has_messages"]


def combine_logs(test_suite_name, log_paths, format="variable", file_path="", formatter=HTMLFormatter):
    """
    Use this function to take our json output files from the robot runs, and combine them into a single data file.
    If no file_path if provided, data is returned by the function as a python variable.

    :param test_suite_name: The string name for the top-level test suite that will be created
    :param log_paths: An array of log file paths, representing test suite logs, to combine into one
    :param format: (optional) The format you want as output. The following are allowed: json, html, custom . If an
    empty string is supplied, the data is returned as a variable.
    :param file_path: (optional) If a file path is supplied, output will be saved as that file. Otherwise, returned as
    a string or variable, depending on what format is supplied. The log messages will only be copied if a file path is
    provided due to potential resource issues with that data.
    :param formatter: (optional) Used if you provide format=custom, as the formatter class to use for formatting the
    output that is returned
    :return: Either True if a file path is supplied, a string of the data if a format is supplied, or a variable with
    the data if no format is supplied
    """

    # set a default output and data for the function
    output = ""
    data = {}

    # create a place to store uuid's that have been used
    uuids = []

    # ensure we have an empty rl_log_messages folder, so we don't mix old and new data
    folder_path = os.path.join(os.path.dirname(file_path), "rl_log_messages")

    if os.path.exists(folder_path):
        # it exists, so remove it so we don't combine old and new data
        shutil.rmtree(folder_path)

    # if only one log file is provided, load that as the final data, as there is no need to create another higher-level
    # test suite of the same thing
    if len(log_paths) == 1:
        log = os.path.join(log_paths[0], "rl_log.json")
        data = deserialize_json(log)

        ##
        # now, copy the log message top-level suite folder to be in the same directory as the new output file, if a file
        # path is provided
        if file_path != "" and data["has_messages"] > 0:
            copy_log_messages(os.path.join(log_paths[0], "rl_log_messages", data["log_uuid"]),
                              os.path.join(os.path.dirname(file_path), "rl_log_messages", data["log_uuid"]))

            uuids.append(data["log_uuid"])
    else:
        # create a new data structure to store the results into
        data = {"name": test_suite_name,
                "status": "PASS",
                "errors": [],
                "statistics": "",
                "tests": [],
                "type": "Suite",
                "starttime": "",
                "endtime": "",
                "total_tests": 0,
                "total_failures": 0,
                "log_uuid": get_uuid(uuids),
                "has_messages": 0,
                "message_count": 0}

        # each log if a file path representing a test suite in json form
        for log_path in log_paths:
            combine_logs_process_log(data, log_path, file_path, uuids, test_suite_name)

    # we now have the combined data as "data", and the log messages saved if a file_path was provided

    # now, format the data for return

    output = format_log_data(data, format, file_path, formatter)

    return output


def deserialize_json(file_path):
    """
    Given a file path of json data, deserializes it into a python object, and returns it.

    :param file_path:
    :return:
    """
    current_file = open(file_path, 'r')
    data = json.load(current_file)
    current_file.close()

    return data
