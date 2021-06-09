import argparse
from collections import namedtuple
import json
import os

from utils import *

script_dir = os.path.dirname(os.path.realpath(__file__))
mappings_file = os.path.normpath(os.path.join(script_dir, '../Resources/Mappings/dashboards_widgets.json'))

WidgetData = namedtuple('WidgetData', ['org', 'dashboard', 'dashboard_type', 'type', 'id'])
slugs_expect_no_data = []


def get_subdirectories(dir):
    return [name for name in os.listdir(dir) if os.path.isdir(os.path.join(dir, name))]


def get_kpi_expectation(org_dir, dashboard_dir, dashboard_type_dir, widget_file_handle):
    data_expected = []
    no_data_expected = []
    kpi_id = 0
    all_data = widget_file_handle.readlines()
    for line in all_data:
        if 'primary' in line:
            kpi_id += 1
            widget_data = WidgetData(org_dir, dashboard_dir, dashboard_type_dir, 'kpi', int(kpi_id))
            dashboard_slug = remove_dashboard_prefixes(dashboard_dir)
            if 'NO_VALUE' in line and dashboard_slug not in slugs_expect_no_data:
                data_expected.append(widget_data)
            elif 'NO_VALUE' not in line and dashboard_slug in slugs_expect_no_data:
                no_data_expected.append(widget_data)
    return data_expected, no_data_expected


def get_non_kpi_expectation(org_dir, dashboard_dir, dashboard_type_dir, widget_file, widget_file_handle):
    data_expected = []
    no_data_expected = []
    first_line = widget_file_handle.readline()
    widget_type = 'chart' if widget_file.startswith('chart') else 'table'
    widget_id = widget_file.replace(widget_type, '').replace('.tsv', '')
    widget_data = WidgetData(org_dir, dashboard_dir, dashboard_type_dir, widget_type, int(widget_id))
    dashboard_slug = remove_dashboard_prefixes(dashboard_dir)
    if 'Has\tNo Results' in first_line and dashboard_slug not in slugs_expect_no_data:
        data_expected.append(widget_data)
    elif 'Has\tNo Results' not in first_line and dashboard_slug in slugs_expect_no_data:
        no_data_expected.append(widget_data)
    return data_expected, no_data_expected


def get_widget_expectation(org_dir, dashboard_dir, dashboard_type_dir, widget_file, widget_file_path):
    with open(widget_file_path) as widget_file_handle:
        if widget_file == 'kpis.tsv':
            data_expected, no_data_expected = get_kpi_expectation(
                org_dir, dashboard_dir, dashboard_type_dir, widget_file_handle
            )
        else:
            data_expected, no_data_expected = get_non_kpi_expectation(
                org_dir, dashboard_dir, dashboard_type_dir, widget_file, widget_file_handle
            )
    return data_expected, no_data_expected


def get_dashboards_expectations(data_path):
    """
    Iterate through extracted data for a given environment and return two list of widgets
    :param data_path: Path of extracted data for a given environment
    :return: widgets_data_expected, widgets_no_data_expected: a list of widget with no results when data was actually
    expected, a second list of widgets with data when no data was actually expected
    """
    widgets_data_expected = []
    widgets_no_data_expected = []
    for org_dir in get_subdirectories(data_path):
        org_path = os.path.join(data_path, org_dir)
        for dashboard_dir in get_subdirectories(org_path):
            dashboard_path = os.path.join(org_path, dashboard_dir)
            for dashboard_type_dir in get_subdirectories(dashboard_path):
                dashboard_type_path = os.path.join(dashboard_path, dashboard_type_dir)
                for widget_file in os.listdir(dashboard_type_path):
                    widget_file_path = os.path.join(dashboard_type_path, widget_file)
                    data_expected, no_data_expected = get_widget_expectation(
                        org_dir, dashboard_dir, dashboard_type_dir, widget_file, widget_file_path
                    )
                    widgets_data_expected = widgets_data_expected + data_expected
                    widgets_no_data_expected = widgets_no_data_expected + no_data_expected
    return widgets_data_expected, widgets_no_data_expected


def get_mapping(mappings, widget):
    try:
        mapping = mappings[widget.dashboard][widget.dashboard_type]['{}s'.format(widget.type)][widget.id-1]
        return mapping.encode('ascii', 'ignore')
    except:
        return '<Unable to Lookup>'


def print_widgets(env, mappings, widgets):
    print 'Org\tDashboard URL\tWidget Title\tWidget Type\tWidget ID'
    for widget in widgets:
        dashboard_url = '{0}/{1}/bi/{2}/{3}'.format(ENV_APP_URL_MAPPINGS[env], camel_to_spinal_case(widget.org),
                                                    remove_dashboard_prefixes(widget.dashboard), widget.dashboard_type)
        print u'{}\t{}\t{}\t{}\t{}'.format(widget.org, dashboard_url,
                                           get_mapping(mappings, widget), widget.type, widget.id)


def convert_to_tsv(widgets_data_expected, widgets_no_data_expected, env):
    with open(mappings_file, 'r') as f:
        mappings = json.load(f)
    print 'List of widgets with NO DATA, when DATA IS actually EXPECTED:'
    print_widgets(env, mappings, widgets_data_expected)
    print 'List of widgets WITH DATA, when NO DATA is actually EXPECTED:'
    print_widgets(env, mappings, widgets_no_data_expected)


def main(log_level, env, slugs):
    set_log_level(log_level)
    global slugs_expect_no_data
    if slugs:
        slugs = slugs.split(',')
        slugs_expect_no_data = [x.strip() for x in slugs]
    extracted_data_dir = os.path.normpath(os.path.join(script_dir, '../ExtractedData/{}'.format(env)))
    widgets_data_expected, widgets_no_data_expected = get_dashboards_expectations(extracted_data_dir)
    convert_to_tsv(widgets_data_expected, widgets_no_data_expected, env)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Searches through widget extracted data from dashboards and identifies'
                                     ' widgets that are currently showing no results.')
    parser.add_argument('-e',
                        '--env',
                        choices=['Prod', 'Staging', 'Test', 'Local', 'Validation'],
                        default='Test',
                        help='The environment\'s extracted data to search')
    parser.add_argument('-s', '--slugs', type=str, help='Explicit list of dashboard slugs for which no data is '
                                                        'expected. Enter as a string, comma separated.')
    parser.add_argument('-l', '--log', choices=['INFO', 'DEBUG'], help='Log level')
    args = parser.parse_args()
    main(args.log, args.env, args.slugs)
