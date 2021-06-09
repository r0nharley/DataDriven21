import argparse
from collections import namedtuple
from math import acos, pi, pow, sqrt

from chart_parser import ChartParser, AxisPoint


Point = namedtuple('Point', ['x', 'y'])


class PieChartParser(ChartParser):
    """
    Child class for parsing pie charts
    Only makes use of the constructor and the convert_to_tsv method from the base
    """

    @staticmethod
    def get_wedge_points(wedge_path):
        """
        Gets the four points from the path of the wedge element.  The path string is of the format:
            "M # # A # # # # # # # L # # A # # # # # # # Z"
        We want the last two numbers (x & y respectively) in each section separated by a letter
        :param wedge_path: the string from the 'd' attribute of the wedge's path element
        :return: the four points within the path
        """
        cleaned_path = wedge_path.replace('M ', '').replace(' Z', '').replace('L', 'A')
        split_path = cleaned_path.split(' A ')
        points = []
        for point in split_path:
            values = point.split(' ')
            points.append(Point(float(values[-2]), float(values[-1])))
        return points

    @staticmethod
    def is_wedge_over_180_degrees(wedge_path):
        """
        Whether or not the wedge's angle is greater than 180 degrees.  This is known from the path string:
            "M # # A # # # * # # # L # # A # # # * # # # Z"
        The "*" in the path string is the "large-arc-flag" which will only be 1 if the wedge angle is greater than 180
        :param wedge_path: the string from the 'd' attribute of the wedge's path element
        :return: whether or not the wedge angle is greater than 180 degrees
        """
        return wedge_path.split(' A ')[1].split(' ')[3] == '1'

    @staticmethod
    def get_line_slope_and_intercept(point0, point1):
        """
        Gets the slope (m) and intercept (b) of the formula for a line (y = mx + b) given two points on that line
        :param point0: first point on the line
        :param point1: second point on the line
        :return: slope and intercept of the line
        """
        slope = (point1.y - point0.y) / (point1.x - point0.x)
        intercept = point0.y - slope * point0.x
        return slope, intercept

    @staticmethod
    def get_intersection_point(line0_slope, line0_intercept, line1_slope, line1_intercept):
        """
        Gets the x,y coordinates of where two lines (formula: y = mx + b) intersect
        :param line0_slope: slope (m) of the first line
        :param line0_intercept: intercept (b) of the first line
        :param line1_slope: slope (m) of the second line
        :param line1_intercept: intercept (b) of the second line
        :return:
        """
        intersection_x = (line1_intercept - line0_intercept)/(line0_slope - line1_slope)
        intersection_y = line0_slope * intersection_x + line0_intercept
        return Point(intersection_x, intersection_y)

    @staticmethod
    def get_line_length(point0, point1):
        """
        Gets the length of the line between two points
        :param point0: first point
        :param point1: second point
        :return: length of the line
        """
        return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2))

    def get_series_data(self):
        """
        Determines the percentage each wedge of the pie chart represents
        :return: list of percentage values
        """
        series_data = []
        pie_chart_wedges = self.soup.select('.highcharts-series > .highcharts-point')
        for wedge in pie_chart_wedges:
            # Get the points from the pie wedge and then the slope/intercept for the functions for the lines that
            # make up the boundary of the pie wedge.
            line0_point0, line1_point0, line1_point1, line0_point1 = self.get_wedge_points(wedge['d'])
            line0_slope, line0_intercept = self.get_line_slope_and_intercept(line0_point0, line0_point1)
            line1_slope, line1_intercept = self.get_line_slope_and_intercept(line1_point0, line1_point1)
            if line0_point0 == line1_point0 and line0_point1 == line1_point1:
                series_data.append(100 if self.is_wedge_over_180_degrees(wedge['d']) else 0)
            elif line1_slope == line0_slope and line1_intercept == line0_intercept:
                series_data.append(50)
            else:
                # Determine where the boundary lines intersect (aka the center of the pie chart)
                intersection_point = self.get_intersection_point(line0_slope, line0_intercept, line1_slope,
                                                                 line1_intercept)
                # Get the lengths of the sides of the triangle that connects the center of the pie chart to the
                # outermost points of the two boundary lines
                triangle_side_a = self.get_line_length(intersection_point, line0_point0)
                triangle_side_b = self.get_line_length(intersection_point, line1_point0)
                triangle_side_c = self.get_line_length(line0_point0, line1_point0)
                # Get the angle (in radians) of the corner of the triangle at the center of the pie chart
                triangle_angle = acos((pow(triangle_side_a, 2) + pow(triangle_side_b, 2) - pow(triangle_side_c, 2)) /
                                      (2 * triangle_side_a * triangle_side_b))
                # Get the wedge angle and the percentage it represents
                wedge_angle = 2 * pi - triangle_angle if self.is_wedge_over_180_degrees(wedge['d']) else triangle_angle
                wedge_percentage = 100.0 * wedge_angle / (2.0 * pi)
                series_data.append(wedge_percentage)
        return [series_data]

    def get_series_labels(self):
        """
        Gets the series labels (pie charts just one have: Percentage)
        :return: the series labels
        """
        return ['Percentage']

    def get_xaxis_labels(self):
        """
        For a pie chart, the xaxis labels are the items in the legend.  If the legend is not displayed, using the
        wedge colors instead.  Since wedge colors are sometimes not unique, postpends an integer to make them unique

        NOTE: How data gets concatenated into Other could cause a lot of noise in the Staging vs Production comparison
        for items that are close to 5% (the cutoff for consideration for Other)
        :return: an array of labels
        """
        labels = []
        legend = self.soup.select('.highcharts-legend')
        if len(legend) > 0:
            series_labels = legend[0].select('g > g > g > text')
            for series_label in series_labels:
                labels.append(AxisPoint(self.get_label_value(series_label), 0))
        else:
            pie_chart_wedges = self.soup.select('.highcharts-series > .highcharts-point')
            for wedge in pie_chart_wedges:
                wedge_color = wedge['fill']
                color_count = len(filter(lambda x: x.value.startswith(wedge_color), labels))
                labels.append(AxisPoint('{0}_{1}'.format(wedge_color, color_count), 0))
        return labels

    def get_yaxis_range(self):
        """
        The yaxis range for a pie chart could always be considered 0% - 100%, but there's no purpose in using this
        method for that.  Making this just "pass" for simplicity.
        :return:
        """
        pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parses a pie chart svg and converts to tsv')
    parser.add_argument('file', help='file containing the pie chart svg to parse')
    args = parser.parse_args()

    with open(args.file, 'r') as fp:
        pie_chart_svg = fp.read()
    pie_chart_parser = PieChartParser(pie_chart_svg)
    print pie_chart_parser.convert_to_tsv()
