import argparse
from collections import namedtuple
import re

from bs4 import BeautifulSoup

from area_series_parser import AreaSeriesParser
from bar_series_parser import BarSeriesParser
from column_series_parser import ColumnSeriesParser
from line_series_parser import LineSeriesParser

from utility import get_value, is_number

AxisPoint = namedtuple('AxisPoint', ['value', 'pixels'])


class ChartParser(object):
    """
    Base class for chart parsers containing utility methods needed by all child classes
    """
    def __init__(self, chart_svg_html, sorted_chart_series=''):
        """
        constructor / parses the key data out of the chart svg
        :param chart_svg_html: string containing the html of the chart svg
        :param sorted_chart_series: name of the series, if any, by which the chart is sorted
        """
        self.sorted_chart_series = sorted_chart_series
        self.soup = BeautifulSoup(chart_svg_html, 'html.parser')
        self.xaxis_labels = self.get_xaxis_labels()
        self.yaxis_range = self.get_yaxis_range()
        self.series_data = self.get_series_data()
        self.series_labels = self.get_series_labels()

    @staticmethod
    def x_label_x_or_y():
        """
        on which axis do we care about where the x axis label is
        overriden in charts (i.e. bar) that swap the axes
        :return: x
        """
        return 'x'

    @staticmethod
    def y_label_x_or_y():
        """
        on which axis do we care about where the y axis label is
        overriden in charts (i.e. bar) that swap the axes
        :return: y
        """
        return 'y'

    @staticmethod
    def get_pixels_from_path(path_string, x_or_y):
        """
        gets the pixel location from a path
        :param path_string: string containing the (x y) data
        :param x_or_y: whether or not the x or y value is desired
        :return: the x or y pixel location of the point for the path
        """
        index = -2 if x_or_y is 'x' else -1
        return float(path_string.split(' ')[index])

    @staticmethod
    def get_series_parser(series_class):
        """
        Factory method to get the appropriate series parser
        :param series_class: the class attribute of the series element
        :return: the parser for the series type
        """
        if 'highcharts-area-series' in series_class:
            return AreaSeriesParser()
        if 'highcharts-bar-series' in series_class:
            return BarSeriesParser()
        if 'highcharts-column-series' in series_class:
            return ColumnSeriesParser()
        if 'highcharts-spline-series' in series_class:
            return LineSeriesParser()
        else:
            raise Exception('Error: Unknown Series Type')

    def get_series_data(self):
        """
        Uses series parsers to get the series data from the svg
        :return: array of series data values
        """
        all_series = []
        chart_series = self.soup.select('.highcharts-series')
        for series in chart_series:
            if 'highcharts-navigator-series' not in series['class']:
                transform = series['transform']
                offset_x = int(re.search('\d+', transform).group(0))
                offset_y = int(re.search('(?<=,)\d+', transform).group(0))

                series_parser = self.get_series_parser(series['class'])
                all_series.append(series_parser.parse(series, offset_x, offset_y, self.xaxis_labels,
                                                      self.get_series_yaxis(series)))

        return all_series

    def get_series_yaxis(self, series):
        """
        Returns the yaxis data (either primary or secondary) that a series uses.  Defaults to always primary.
        :param series: The html of the series
        :return: The yaxis to use for the series
        """
        return self.yaxis_range[0]

    def get_series_labels(self):
        """
        Gets the series labels out of the chart legend.
        :return: array of series labels or "None" if the legend doesn't exist
        """
        labels = []
        series_labels = self.soup.select('.highcharts-legend > g > g > g > text')
        for series_label in series_labels:
            labels.append(self.get_label_value(series_label))
        if len(series_labels) is 0:
            labels.append('Data')
        return labels

    def get_xaxis_tick_marks(self):
        """
        Gets the xaxis tick marks.
        :return: array of tick mark created by highcharts
        """
        xaxis_tick_marks = self.soup.select('.highcharts-xaxis > .highcharts-tick')
        if not xaxis_tick_marks:
            xaxis_tick_marks = self.soup.select('.highcharts-xaxis-grid > .highcharts-grid-line')
        return xaxis_tick_marks

    def get_formatted_xaxis_labels(self):
        """
        Gets the formatted xaxis labels, making any modification required for grouped axis
        :return: array of labels to use in the tsv
        """
        xaxis_labels = self.soup.select('.highcharts-xaxis-labels > text')
        xaxis_tick_marks = self.soup.select('.highcharts-xaxis > .highcharts-tick')
        if not xaxis_tick_marks:
            # find the visible grid lines which create the "groups"
            xaxis_tick_marks = self.soup.select('.highcharts-xaxis-grid > .highcharts-grid-line')
            xaxis_groups_breaks = [tick_mark for tick_mark in xaxis_tick_marks if tick_mark.get('stroke-width') == '1']
            xaxis_grid_visible = [self.get_pixels_from_path(x['d'].replace('M ', '').split(' L ')[0],
                                  self.x_label_x_or_y())
                                  for x in xaxis_groups_breaks]
            # find the top and bottom axis
            xaxis_labels_y = [int(label.get('y')) for label in xaxis_labels]
            y_min = min(xaxis_labels_y)
            y_max = max(xaxis_labels_y)
            # Create lables for all combinations of axis, e.g. "Top:Bottom1, Top:Bottom2"
            grid_left = 0
            labels = []
            for grid in xaxis_grid_visible:
                label_bottom = []
                label_top = None
                grid_right = grid
                for label in xaxis_labels:
                    x = float(label.get("x"))
                    if x > grid_left and x < grid_right:
                        y = int(label.get('y'))
                        if y == y_min:
                            label_top = self.get_label_value(label)
                        if y == y_max:
                            label_bottom.append(self.get_label_value(label))
                for bottom in label_bottom:
                    labels.append('{}:{}'.format(label_top, bottom))
                grid_left = grid_right
        else:
            labels = [self.get_label_value(label) for label in xaxis_labels]

        return labels

    def get_xaxis_labels(self):
        """
        Gets the labels from the xaxis
        :return: An array of xaxis labels along with the end pixel corresponding to the label
        """
        labels = []
        xaxis_tick_marks = self.get_xaxis_tick_marks()
        xaxis_grid = [self.get_pixels_from_path(x['d'].replace('M ', '').split(' L ')[0], self.x_label_x_or_y())
                      for x in xaxis_tick_marks]
        xaxis_grid.sort()
        xaxis_labels = self.get_formatted_xaxis_labels()

        for label_index in range(len(xaxis_labels)):
            labels.append(AxisPoint(value=xaxis_labels[label_index],
                                    pixels=xaxis_grid[label_index+1]))
        return labels

    @staticmethod
    def get_label_value(label):
        """
        get the label value from label html element
        :param label: the label html element
        :return: the label text
        """
        text = label
        if len(label.select('title')) > 0:
            text = label.select('title')[0]
        elif len(label.select('tspan')) > 0:
            text = label.select('tspan')[0]
        return get_value(text.contents[0])

    def get_yaxis_range(self):
        """
        For each yaxis (primary and, if available, secondary) gets the min and max value along with pixel location
        :return: array of yaxis value/position information
        """
        yaxis = []
        yaxis_grid = self.soup.select('.highcharts-yaxis > .highcharts-axis-line')[0]['d'].split(' L ')
        yaxis_groups = self.soup.select('.highcharts-yaxis-labels')
        for yaxis_group in yaxis_groups:
            yaxis_range = []
            if 'highcharts-navigator-yaxis' not in yaxis_group['class']:
                yaxis_labels = yaxis_group.select('text')
                yaxis_values = [self.get_label_value(label) for label in yaxis_labels]
                yaxis_values.sort()

                last_yaxis_index = -1 if is_number(yaxis_values[-1]) else -2

                first_point_index = last_yaxis_index if self.y_label_x_or_y() is 'y' else 0
                first_point_pixels = self.get_pixels_from_path(yaxis_grid[0], self.y_label_x_or_y())
                last_point_index = 0 if self.y_label_x_or_y() is 'y' else last_yaxis_index
                last_point_pixels = self.get_pixels_from_path(yaxis_grid[1], self.y_label_x_or_y())

                yaxis_range.append(AxisPoint(value=yaxis_values[first_point_index], pixels=first_point_pixels))
                yaxis_range.append(AxisPoint(value=yaxis_values[last_point_index], pixels=last_point_pixels))
                yaxis.append(yaxis_range)
        return yaxis

    def has_navigator(self):
        return len(self.soup.select('.highcharts-series-group .highcharts-navigator-series')) > 0

    def convert_to_tsv(self):
        """
        Converts a chart's data to tab separated value string
        :return: the tab separated value string
        """
        tsv = []

        # For a chart with a sorted series, find the number of data points that match the last shown value.
        # This is necessary because data sorted by series isn't also sorted by category, and therefore the last data
        # point shown one run may not be invisible the next run (a different data point with the same value might be
        # visible instead).
        num_data_points_matching_last_sorted_value = 0
        if self.has_navigator() and self.sorted_chart_series in self.series_labels:
            sorted_series_index = self.series_labels.index(self.sorted_chart_series)
            last_sorted_series_value = self.series_data[sorted_series_index][len(self.xaxis_labels) - 1].split('\t')[0]
            num_data_points_matching_last_sorted_value = len(
                [x for x in self.series_data[sorted_series_index][:len(self.xaxis_labels)]
                 if x.split('\t')[0] == last_sorted_series_value]
            )
            tsv.append(u'{0}\t{1}\t{2}'.format('Last Data Shown', self.sorted_chart_series, last_sorted_series_value))
            tsv.append(u'{0}\t{1}\t{2}'.format('Last Data Shown', 'Count', num_data_points_matching_last_sorted_value))

        for x in range(len(self.xaxis_labels) - num_data_points_matching_last_sorted_value):
            for y in range(len(self.series_labels)):
                if x < len(self.series_data[y]):
                    tsv.append(u'{0}\t{1}\t{2}'.format(self.xaxis_labels[x].value, self.series_labels[y],
                                                       self.series_data[y][x]))
        return '\n'.join(tsv)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parses a chart svg and converts to tsv')
    parser.add_argument('file', help='file containing the chart svg to parse')
    args = parser.parse_args()

    with open(args.file, 'r') as fp:
        chart_svg = fp.read()
    chart_parser = ChartParser(chart_svg)
    print chart_parser.convert_to_tsv()
