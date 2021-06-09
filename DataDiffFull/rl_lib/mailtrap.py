import os
from datetime import datetime

import requests
import json


# a helper class to facilitate using the Mailtrap API to verify emails received
class Mailtrap:
    # Store the ids of the inboxes in mailtrap
    INBOX_IDs = {
        "staging": 54811,
        "development": 54810,
        "valueadd-dev": 123796
    }

    message_search_criteria_defaults = {
        "subject": "",
        "sender_email": "",
        "sent_to_emails": "",
        "sent_min_datetime": None,
        "sent_max_datetime": None,
        "subject_contains": ""
    }

    def __init__(self):
        # the base url for the Mailtrap REST APIs
        self.base_url = "https://mailtrap.io"

    def check_message(self, message, search_criteria):
        new_result = self.format_message(message)
        meets_criteria = self.check_message_sent_to_emails(search_criteria, new_result)
        meets_criteria = meets_criteria and self.check_message_sender_email(search_criteria, new_result)
        meets_criteria = meets_criteria and self.check_message_subject_contains(search_criteria, new_result)
        meets_criteria = meets_criteria and self.check_message_subject(search_criteria, new_result)
        meets_criteria = meets_criteria and self.check_message_sent_min_datetime(search_criteria, new_result)
        meets_criteria = meets_criteria and self.check_message_sent_max_datetime(search_criteria, new_result)

        if meets_criteria:
            return new_result

    def check_message_sent_max_datetime(self, search_criteria, new_result):
        return search_criteria["sent_max_datetime"] is None or \
               new_result["sent"] <= search_criteria["sent_max_datetime"]

    def check_message_sent_min_datetime(self, search_criteria, new_result):
        return search_criteria["sent_min_datetime"] is None or \
               new_result["sent"] >= search_criteria["sent_min_datetime"]

    def check_message_subject(self, search_criteria, new_result):
        return search_criteria["subject"] == "" or search_criteria["subject"] == new_result["subject"]

    def check_message_sent_to_emails(self, search_criteria, new_result):
        return search_criteria["sent_to_emails"] == "" or \
               search_criteria["sent_to_emails"].lower() == new_result["sent_to_emails"].lower()

    def check_message_sender_email(self, search_criteria, new_result):
        return search_criteria["sender_email"] == "" or \
               search_criteria["sender_email"].lower() == new_result["sender_email"].lower()

    def check_message_subject_contains(self, search_criteria, new_result):
        return search_criteria["subject_contains"] == "" or \
               search_criteria["subject_contains"] in new_result["subject"]

    def format_message(self, message):
        new_result = {}
        new_result["id"] = message["id"]
        new_result["subject"] = message["subject"]
        new_result["sent"] = datetime.fromtimestamp(message["sent_at_timestamp"])
        new_result["sender_email"] = message["from_email"]
        new_result["sender_name"] = message["from_name"]
        new_result["sent_to_emails"] = message["to_email"]
        new_result["sent_to_names"] = message["to_name"]
        new_result["size_in_bytes"] = message["email_size"]
        new_result["was_read"] = message["is_read"]
        new_result["message"] = self.get_email_content(message["html_path"], message["txt_path"])
        return new_result

    def get_results(self, messages, search_criteria):
        # now, we have an array of possible messages, but now we need to check each, and it it meets our criteria,
        # return it in the results
        results = []

        for message in messages:
            result = self.check_message(message, search_criteria)

            if result is not None:
                results.append(result)

        return results

    def search_messages(self, criteria):
        """
        Search for messages in Mailtrap, based on a dictionary object of criteria.
        Criteria can include any of the following:
        sender_email: (string) Senders email
        sent_to_emails: (string) The emails the message was sent to
        sent_min_datetime - message was sent at or after this datetime (in UTC)
        sent_max_datetime - message was sent at or before this datetime stamp (in UTC)
        subject_contains - text that the subject line will contain
        subject - the text the subject line should exactly match to
        :return: data - An array of dictionary objects that each contain the following:

        """
        # set search criteria including defaults
        search_criteria = {}
        search_criteria.update(self.message_search_criteria_defaults)
        search_criteria.update(criteria)

        url = "{0}/api/v1/inboxes/{1}/messages?search={2}".format(
            self.base_url,
            self.INBOX_IDs[os.environ.get("MAILTRAP_INBOX")],
            search_criteria["sent_to_emails"]
        )

        headers = {
            "Api-Token": os.environ.get("MAILTRAP_API_TOKEN"),
            "Content-Type": "application/json"
        }

        response = requests.get(url, headers=headers)

        if response.ok:
            messages = json.loads(response.content)

            return self.get_results(messages, search_criteria)
        else:
            response.raise_for_status()

    def get_email_content(self, http_path, txt_path):
        response = self.get(http_path)
        if response.ok and response.content is not None and response.content != "":
            return response.content

        response = self.get(txt_path)
        if response.ok:
            return response.content
        else:
            response.raise_for_status()

    def get(self, path):
        url = self.base_url + path
        headers = {
            "Api-Token": os.environ.get("MAILTRAP_API_TOKEN"),
            "Content-Type": "application/json"
        }

        return requests.get(url, headers=headers)
