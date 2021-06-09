"""
Library to manipulate lists of dictionaries as well as read and write them into easily diffed TSV files.
"""
import csv
from datetime import date

import os
from robot.libraries.BuiltIn import BuiltIn

__all__ = [
    'write_tsv',
]


def write_tsv(exporter_name, filename, data):
    """
    Writes a list of dicts as tsv to the specified filename, tweaked according to rules in ${EXPORTER_RULES}.

    Available rules are:
    * ignore: iterable of field names to exclude from output
    * order_by: iterable of field names to order by

    :param exporter_name: The exporter name to apply rules for
    :param filename: The filename to write the TSV out to
    :param data: The data to include in the file
    """
    print("Writing TSV for exporter {}".format(exporter_name))

    # Create (or at least truncate) the file right away, whether there's data or not.
    dirname = os.path.dirname(filename)
    if not os.path.exists(dirname):
        print('Creating directory {}'.format(dirname))
        os.makedirs(dirname)

    with open(filename, 'w') as output_file:
        if data:
            field_names = sorted(data[0].keys())
            print('Available fields: {}'.format(field_names))

            order_by = get_exporter_rule(exporter_name, 'order_by')
            if order_by:
                field_names = list(order_by) + [name for name in field_names if name not in order_by]

            print('Ordering by {}'.format(order_by))
            data = sorted(data, key=lambda row: [row.get(name) for name in field_names])

            ignore = get_exporter_rule(exporter_name, 'ignore')
            if ignore:
                print('Ignoring fields {}'.format(ignore))
                field_names = [name for name in field_names if name not in ignore]
                data = [
                    {name: row.get(name) for name in field_names} for row in data
                ]

            today_placeholder = get_exporter_rule(exporter_name, 'today_placeholder')
            if today_placeholder:
                print("Replacing today's date with ${{TODAY}} for fields {}".format(today_placeholder))
                for row in data:
                    for field_name in today_placeholder:
                        if field_name in row and row[field_name] == str(date.today()):
                            row[field_name] = "${TODAY}"

            print('Writing {} rows to {}'.format(len(data), filename))
            writer = csv.DictWriter(output_file, fieldnames=field_names, delimiter='\t', lineterminator='\n')
            writer.writeheader()
            writer.writerows(data)
        else:
            print('Wrote empty file: {}'.format(filename))


def get_exporter_rule(exporter_name, rule_name):
    all_rules = BuiltIn().get_variable_value('&{EXPORTER_RULES}')
    if all_rules:
        exporter_rules = all_rules.get(exporter_name)
        if exporter_rules:
            return exporter_rules.get(rule_name)
