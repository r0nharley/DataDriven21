import json
import uuid
import os
import json
from logging import get_uuid
import shutil


class log_listener:
    """
    log_listener is a listener that listens to all the goings on of the robot run, and to look for particular events and
    store/log them the way we want to. This way, we can get way from the the default logging mechanise with Robot
    Framework, which is resource intensive, and customize the result ouptuts.

    Most of the helper functions below are ones that the Robot Framework is design to look for, and correspond to key
    events or portions of the robot run.

    Log messages can take up too many resources when kept in memory, so they now get written out as JSON to their own
    file, one file for each object that has log messages, using a UUID for the file name. To make it easy to port them
    when combining logs, they are also stored under a folder, also named with a UUID, for the suite the are found in.
    That way, the suite folder can just be copied with only a simple duplicate check on the folder UUID name.
    "has_messages" is then used as an indicator for the suite that there are log message files to copy over, and
    "message_count" is an indicator that a particular data element has log messages associated with it.
    """
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, log_file_path):
        """
        This is the initialization function. Parameters can be based to the listener via the listener argument to the
        robot run call, in the format
        listener="<listener class name that must match exactly the python file name>:<argument 1>:<argument 2>..." ,
        where arguments must be encoded (recommend using str.encode(base64), and separated by colons.

        :param log_file_path: The file path to use for file logging
        """
        # store the file path for this robot run
        self.log_file_path = log_file_path.decode("base64")

        # create a structure to hold the data we will be collecting
        self.data = {"name": "",
                     "tests": [],
                     "status": "FAIL",
                     "errors": [],
                     "statistics": "",
                     "type": "Suite",
                     "starttime": "",
                     "endtime": "",
                     "total_tests": 0,
                     "total_failures": 0,
                     "log_uuid": "",
                     "has_messages": 0,
                     "message_count": 0}

        # store the index of the current test we are on during processing, as a reference
        self.current_test_index = 0

        # define a placeholder to record which keyword we are looking at, as we process errors
        self.current_test_error_keyword = ""

        self.current_keyword = None

        self.current_keyword_parent = None

        self.next_index = 0

        self.parent_pointers = {}

        self.current_suite = None

        self.uuids = []

        self.current_test = None

        # clear the rl_log_messages folder, if this is the first suite to be processed
        folder_path = os.path.join(self.log_file_path, "rl_log_messages")

        if os.path.exists(folder_path):
            # it exists, so remove it so we don't combine old and new data
            shutil.rmtree(folder_path)

    def start_suite(self, name, attrs):
        # set the correct parent and container to store the suite
        parent = None
        parent_container = self.data["tests"]

        if self.current_suite is not None:
            parent = self.current_suite
            parent_container = parent["tests"]

        self.current_suite = {
                                "name": name,
                                "tests": [],
                                "status": "FAIL",
                                "errors": [],
                                "statistics": "",
                                "type": "Suite",
                                "starttime": "",
                                "endtime": "",
                                "total_tests": 0,
                                "total_failures": 0,
                                "log_uuid": self.get_uuid(),
                                "id": self.get_object_index(),
                                "has_messages": 0,
                                "message_count": 0}

        # keep track of the parent pointers separately, so they don't get JSONified
        self.parent_pointers[self.current_suite["id"]] = parent

        parent_container.append(self.current_suite)

        # reset this reference
        self.current_test = None

    def end_suite(self, name, attrs):
        # grab the final suite status and any statistics
        self.current_suite["status"] = attrs["status"]
        self.current_suite["statistics"] = attrs["statistics"]
        self.current_suite["starttime"] = attrs["starttime"]
        self.current_suite["endtime"] = attrs["endtime"]

        # reset the current_suite and parent
        if self.parent_pointers[self.current_suite["id"]] is not None:
            self.current_suite = self.parent_pointers[self.current_suite["id"]]
        else:
            self.current_suite = None

    def start_test(self, name, attrs):
        # create the test entry and populate it with useful information
        self.current_test = {"name": name,
                             "type": "Test",
                             "status": "FAIL",
                             "error": {},
                             "keywords": [],
                             "starttime": "",
                             "endtime": "",
                             "log_uuid": self.get_uuid(),
                             "has_messages": 0,
                             "message_count": 0}

        self.current_suite["tests"].append(self.current_test)

        # store what keyword error-ed
        self.current_test_error_keyword = ""

        self.current_keyword = None

        self.current_keyword_parent = None

    def end_test(self, name, attrs):
        # add additional information about this test
        self.current_suite["tests"][self.current_test_index]["status"] = attrs["status"]
        self.current_suite["starttime"] = attrs["starttime"]
        self.current_suite["endtime"] = attrs["endtime"]

        # track how many tests are in this suite
        self.current_suite["total_tests"] = self.current_suite["total_tests"] + 1

        if attrs["status"] == "FAIL":
            # store the fail message both on the test, and on the suite
            message = {"message": attrs["message"],
                       "test": attrs["longname"],
                       "keyword": self.current_test_error_keyword,
                       "suites": [self.current_suite["name"]]}
            self.current_suite["tests"][self.current_test_index]["error"] = message
            self.current_suite["errors"].append(message)

            # track how many failed tests there are in this suite
            self.current_suite["total_failures"] = self.current_suite["total_failures"] + 1

        # increment which test we will be on next
        self.current_test_index = self.current_test_index + 1

        # reset this reference
        self.current_test = None

    def start_keyword(self, name, attrs):
        # default where we should store this new keyword into as the test
        current_keywords_list = self.current_suite["tests"][self.current_test_index]["keywords"]

        if self.current_keyword is not None:
            # if there is a current keyword, treat it as the parent
            self.current_keyword_parent = self.current_keyword

            # keep track of what list we should store this new keyword into, the test, or a parent keyword
            current_keywords_list = self.current_keyword_parent["keywords"]

        new_keyword = {"keyword": name,
                       "status": "",
                       "starttime": "",
                       "endtime": "",
                       "id": self.get_object_index(),
                       "keywords": [],
                       "log_uuid": self.get_uuid(),
                       "has_messages": 0,
                       "message_count": 0}

        # store the parent pointer separately, so we can generate JSON later without circular references.
        self.parent_pointers[new_keyword["id"]] = self.current_keyword_parent

        self.current_keyword = new_keyword

        current_keywords_list.append(self.current_keyword)

    def end_keyword(self, name, attrs):
        # update some items on the current keyword
        self.current_keyword["status"] = attrs["status"]
        self.current_keyword["starttime"] = attrs["starttime"]
        self.current_keyword["endtime"] = attrs["endtime"]

        # we are at the end of a keyword, so no new children. Set the current keyword to its parent
        self.current_keyword = self.parent_pointers[self.current_keyword["id"]]

        if self.current_keyword is not None:
            self.current_keyword_parent = self.parent_pointers[self.current_keyword["id"]]

        if attrs["status"] == "FAIL":
            self.current_test_error_keyword = name

    def log_message(self, message):
        """
        This function stores the log message in the collection of logged items. If we store in memory, because of how
        how we use logging, RAM will be eaten up. To avoid this, we want to write out to disk, in a way that we can
        link or retrieve it later, in connection to which suite, test, and keyword , it is associated with. In the same
        logging folder as self.log_file_path, we will create a folder rl_log_messages. Within this folder will be a
        folder for each suite, named <uuid> , where uuid is a unique identifier. Within that folder will be files named
        <uuid>.json, for each test/keyword combination, that has log messages , where uuid is a unique identifier. These
        uuid's will be stored as log_id , on the object it is associated with.

        :param message: String representing the log message
        """
        # build the json output for this message
        log_message_output = json.dumps(message)

        # used later to insert a comma into the output if it is not the first item being added
        prefix = ""

        # identify the suite folder where the file will be that stores this log message
        suite_folder_path = os.path.join(self.log_file_path, "rl_log_messages", self.current_suite["log_uuid"])

        # if the folder hasn't yet been created, create it
        if not os.path.exists(suite_folder_path):
            os.makedirs(suite_folder_path)

        # now, identify what file path this log message should be stored in
        log_file_name = ""

        if self.current_keyword:
            log_file_name = self.current_keyword["log_uuid"]

            # mark to the parent entities that there are log messages and how many
            self.current_keyword["has_messages"] = self.current_keyword["has_messages"] + 1
            self.current_test["has_messages"] = self.current_test["has_messages"] + 1
            self.current_suite["has_messages"] = self.current_suite["has_messages"] + 1

            # log this message with the actual element that it falls under
            self.current_keyword["message_count"] = self.current_keyword["message_count"] + 1
        elif self.current_test:
            log_file_name = self.current_suite["tests"][self.current_test_index]["log_uuid"]

            # mark to the parent entities that there are log messages and how many
            self.current_test["has_messages"] = self.current_test["has_messages"] + 1
            self.current_suite["has_messages"] = self.current_suite["has_messages"] + 1

            # log this message with the actual element that it falls under
            self.current_test["message_count"] = self.current_test["message_count"] + 1
        else:
            log_file_name = self.current_suite["log_uuid"]

            # mark to the parent entities that there are log messages and how many
            self.current_suite["has_messages"] = self.current_suite["has_messages"] + 1

            # log this message with the actual element that it falls under
            self.current_suite["message_count"] = self.current_suite["message_count"] + 1

        log_file_name = "{0}.json".format(log_file_name)

        log_file_path = os.path.join(suite_folder_path, log_file_name)

        # now, open the file to store the log messages, to append to it
        file_is_new = 1
        if os.path.exists(log_file_path):
            file_is_new = 0

        log_file = open(log_file_path, 'a+')

        try:
            if file_is_new == 1:
                # file is new, so add some items to it
                log_file.write("[]")
            else:
                # add the comma for good JSON, since this is not the first item being added
                prefix = ","

            # seek to the last position, the "]" character, and truncate to remove only that character
            log_file.seek(-1, 2)
            log_file.truncate()

            # now, append the our new entry to the end, with a closing "]"
            log_file.write("{0}{1}]".format(prefix, log_message_output))

            log_file.close()
        except Exception:
            # used just to close the file pointer before continuing
            log_file.close()
            raise

    def close(self):
        # if there is only one top-level suite, set that as the top-level data
        if len(self.data["tests"]) == 1 and self.data["tests"][0]["type"] == "Suite":
            self.data = self.data["tests"][0]

        # log the data we have been storing as a file in json format
        log_file_path = os.path.join(self.log_file_path, "rl_log.json")
        log_file = open(log_file_path, 'w+')
        json.dump(self.data, log_file)
        log_file.close()

    def get_object_index(self):
        """
        Helper function to return an unique integer, used to label and keep track of objects and what parent they point
        to.

        :return: Integer index value that hasn't been used yet
        """
        next_index = self.next_index
        self.next_index = self.next_index + 1
        return next_index

    def get_uuid(self):
        """
        Returns a unique UUID, and keeps track of past ones, so we always return one that hasn't yet been returned.
        :return: String representing a unique UUID
        """
        return get_uuid(self.uuids)
