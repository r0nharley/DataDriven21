from collections import namedtuple
import logging
import json
import os

from utils import *


KPI_TYPES = ['indicator']
TABLE_TYPES = ['pivot', 'tablewidget']
CHART_TYPES = ['chart/column', 'chart/line', 'chart/pie', 'chart/bar', 'chart/scatter', 'sunburst',
               'chart/area']
IGNORED_TYPES = ['richtexteditor']
DashboardData = namedtuple('DashboardData', ['slug', 'type', 'kpis', 'charts', 'tables'])

script_dir = os.path.dirname(os.path.realpath(__file__))
stored_mappings_dir = os.path.normpath(os.path.join(script_dir, '../Resources/dashboard_mappings'))


def can_extract_dashboards_category(category, actual_dashboard_list):
    output = False

    # if the category is either in the actual dashboard list, or nothing is in the list, process the category
    if len(actual_dashboard_list) == 0 or category in actual_dashboard_list:
        # Discard any dashboards starting with "Unreleased"
        if not category.startswith('.') and not category.lower().startswith('unreleased'):
            output = True

    return output


def can_extract_dashboards_topic(topic, actual_topics_list):
    output = False

    # if the topic is either in the actual topic list, or nothing is in the list, process the topic
    if len(actual_topics_list) == 0 or topic in actual_topics_list:
        if not topic.startswith('.'):
            output = True

    return output


# checks the data mappings, and if they are found and should be included, updates the mapping file
def extract_dashboard_mapping(config):
    # pull the config items we need
    dashboards = config["dashboards"]
    actual_dashboard_list = config["actual_dashboard_list"]
    actual_topics_list = config["actual_topics_list"]
    dashboards_dir = config["dashboards_dir"]
    mappings_file = config["mappings_file"]

    for category in dashboards:
        if can_extract_dashboards_category(category, actual_dashboard_list):
            category_path = os.path.join(dashboards_dir, category)

            for topic in os.listdir(category_path):
                if can_extract_dashboards_topic(topic, actual_topics_list):
                    extract_dashboard_mapping_data(category, topic, category_path, mappings_file)


def extract_dashboard_mapping_data(category, topic, category_path, mappings_file):
    topic_path = os.path.join(category_path, topic)

    # if this is a Summary topic, grab the mapping, otherwise, look for dash files
    if topic == "Summary":
        dashboard_data = extract_summary_dashboards_data(category, topic)

        if dashboard_data is not None:
            update_mappings(dashboard_data, mappings_file)
    else:
        for dashfile in os.listdir(topic_path):
            dashboard_data = extract_dashboards_dashfile_data(dashfile, category, topic, topic_path)

            if dashboard_data is not None:
                update_mappings(dashboard_data, mappings_file)


def extract_dashboards_dashfile_data(dashfile, category, topic, topic_path):
    dashboard_data = None

    if (dashfile.startswith('viz_') or dashfile.startswith('details_')) and dashfile.endswith('.dash'):
        dashfile_type = 'visualization' if dashfile.startswith('viz_') else 'details'
        dashfile_path = os.path.join(topic_path, dashfile)
        logging.debug('Processing {0}...'.format(dashfile_path))
        dashboard_data = get_dash_file_data(dashfile_path, dashfile_type, category, topic)

    return dashboard_data


def extract_dashboards_data(dashboards_dir, dashboards_list, topics_list, mappings_file):
    """
    Create or update a dashboards widgets mapping file, which provides a simple representation of all
    widgets present on each dashboard.
    :param dashboards_dir: (str)  Path to the dashboards directory
    """
    logging.info('Updating all mappings...')

    dashboards = os.listdir(dashboards_dir)
    if not dashboards:
        logging.critical('No dashboards found.')
        exit(1)

    # get the list of dashboards to use. If empty, us all
    actual_dashboard_list = []
    if dashboards_list != "":
        actual_dashboard_list = dashboards_list.split(",")

    # get the list of topics to use. If empty, us all
    actual_topics_list = []
    if topics_list != "":
        actual_topics_list = topics_list.split(",")

    extract_dashboard_mapping({
        "dashboards": dashboards,
        "actual_dashboard_list": actual_dashboard_list,
        "actual_topics_list": actual_topics_list,
        "dashboards_dir": dashboards_dir,
        "mappings_file": mappings_file,
    })

    logging.info('Updating all mappings - DONE')
    logging.info('Mappings path: {}'.format(mappings_file))


def extract_summary_dashboards_data(category, topic):
    dashboard_data = None

    # lookup the category and dashboard, and if it exists, return that data
    dashboard_data_file_path = "{0}/{1}-{2}.json".format(stored_mappings_dir, category, topic)
    if os.path.exists(dashboard_data_file_path):
        with open(dashboard_data_file_path, 'r') as f:
            dashboard_data = json.load(f)

            dashboard_data = DashboardData(slug=dashboard_data["slug"],
                                           type=dashboard_data["type"],
                                           kpis=dashboard_data["kpis"],
                                           charts=dashboard_data["charts"],
                                           tables=dashboard_data["tables"])

    return dashboard_data


def get_widget_title(widget):
    """
    Return the title of a widget
    :param widget: (dict) Widget description from a dashboard file
    :return: (string) The title of the widget
    """
    if widget['title'] != '':
        return widget['title']
    else:
        return widget['metadata']['panels'][0]['items'][0]['jaql']['title']


def get_widget_sorted_item(widget):
    """
    Return the item on which the widget must be sorted, if any
    :param widget: (dict) Widget description from a dashboard file
    :return: (string) The title of sorted item
    """
    for panel in widget['metadata']['panels']:
        for item in panel['items']:
            if 'sort' in item['jaql']:
                return item['jaql']['title']
    return None


def get_dashboard_ordered_widget_ids(dashfile_data):
    """
    Return the list of widget IDs in the order of appearance from the layout object
    :param dashfile_data: (dict) The content of a dashboard definition file (.dash)
    :return: (array) List of widget IDs
    """
    ordered_widget_ids = []
    for column in dashfile_data['layout']['columns']:
        for cell in column['cells']:
            for subcell in cell['subcells']:
                for element in subcell['elements']:
                    ordered_widget_ids.append(element['widgetid'])
    return ordered_widget_ids


def get_ordered_titles(dashfile_data):
    """
    Return the list of widget titles present on the given dashboard, following the order defined in the dashboard layout
    :param dashfile_data: (dict) The content of a dashboard definition file (.dash)
    :return: (array) Ordered list of the widget titles present on the dashboard for kpis, charts and tables
    """
    ordered_widget_ids = get_dashboard_ordered_widget_ids(dashfile_data)

    kpis_id_title_mapping = {}
    charts_id_title_mapping = {}
    tables_id_title_mapping = {}
    kpi_titles = []
    chart_titles = []
    table_titles = []

    # Create a local mapping between the widget ID and its title, the mapping is specific to the widget type
    for widget in dashfile_data['widgets']:
        widget_id = widget['oid']
        widget_title = get_widget_title(widget)
        widget_sorted_item = get_widget_sorted_item(widget)
        if widget['type'] in KPI_TYPES:
            kpis_id_title_mapping[widget_id] = widget_title
        elif widget['type'] in CHART_TYPES:
            charts_id_title_mapping[widget_id] = {
                'title': widget_title,
                'sortedItem': widget_sorted_item
            }
        elif widget['type'] in TABLE_TYPES:
            tables_id_title_mapping[widget_id] = {
                'title': widget_title,
                'sortedItem': widget_sorted_item
            }
        elif widget['type'] not in IGNORED_TYPES:
            logging.warning('The widget type {0} is unknown and will not be processed.'.format(widget['type']))
            continue

    # Sort the titles following the order of the widgets in the layout
    for ordered_widget_id in ordered_widget_ids:
        if ordered_widget_id in kpis_id_title_mapping:
            kpi_titles.append(kpis_id_title_mapping[ordered_widget_id])
        elif ordered_widget_id in charts_id_title_mapping:
            chart_titles.append(charts_id_title_mapping[ordered_widget_id])
        elif ordered_widget_id in tables_id_title_mapping:
            table_titles.append(tables_id_title_mapping[ordered_widget_id])

    return [kpi_titles, chart_titles, table_titles]


def get_dash_file_data(dashfile_path, dashfile_type, category, topic):
    """
    Return all necessary data related to a dashboard definition file
    :param dashfile_path: (str)  The path to a sisense .dash file
    :param dashfile_type: (str)  The type of dashboard (either visualization or details)
    :param category: (str)  The category name of the dashboard
    :param topic: (str)  The topic name of the dashboard
    :return: (DashboardData)
    """
    with open(dashfile_path, 'r') as f:
        data = json.load(f)
    kpi_titles, chart_titles, table_titles = get_ordered_titles(data)

    dashboard_slug = clean_slug('-'.join([to_spinal_case(category), to_spinal_case(topic)]))

    return DashboardData(slug=dashboard_slug,
                         type=dashfile_type,
                         kpis=kpi_titles,
                         charts=chart_titles,
                         tables=table_titles)


def update_mappings(dashboard_data, mappings_file):
    """
    Update the dashboard kpi mappings file
    Add a dict object which key is the dashboard name and values are the dashboard's KPI titles
    This mapping is used by diff_kpis to name the kpis that are compared
    :param dashboard_data: (DashboardData) Data relevant to a particular dashboard
    """
    logging.info('update_mappings')
    with open(mappings_file, 'r') as f:
        try:
            data = json.load(f)
        except ValueError:
            data = {}

    if dashboard_data.slug not in data:
        data[dashboard_data.slug] = {}
    table_data = [{'title': t['title'].replace('\"', ''), 'sortedItem': t['sortedItem']} for t in dashboard_data.tables]
    data[dashboard_data.slug][dashboard_data.type] = {
        'kpis': dashboard_data.kpis,
        'charts': dashboard_data.charts,
        'tables': table_data
    }

    with open(mappings_file, 'w') as f:
        f.write(json.dumps(data, indent=4))
