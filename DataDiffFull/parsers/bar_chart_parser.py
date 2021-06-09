import argparse

from chart_parser import ChartParser


class BarChartParser(ChartParser):
    """
    Child class for parsing bar charts - in a way, a bar chart is a column chart that fell onto its side in highcharts:
    The x-axis and y-axis are switched, and thus we care about the y location of x-axis labels and the x location of
    y-axis labels (hence the overrides of x_label_x_or_y and y_label_x_or_y).  Additionally sometimes our series_data is
    also turned on its side (instead of being an array with one array of multiple values, it's an array of multiple
    array with one value each).  Thus the logic in convert_to_tsv checks to see if that's true and outputs
    appropriately.
    """

    @staticmethod
    def x_label_x_or_y():
        """
        on which axis do we care about where the x axis label is
        overriden since a bar chart inverts the axes
        :return: 'y'
        """
        return 'y'

    @staticmethod
    def y_label_x_or_y():
        """
        on which axis do we care about where the y axis label is
        overriden since a bar chart inverts the axes
        :return: 'x'
        """
        return 'x'

    def convert_to_tsv(self):
        """
        Converts a chart's data to tab separated value string
        :return: the tab separated value string
        """
        tsv = []
        # When true, the series_data is turned on its side (aka each data point is in its own series)
        if len(self.xaxis_labels) == len(self.series_data):
            for y in range(len(self.series_labels)):
                for x in range(len(self.xaxis_labels)):
                    if y < len(self.series_data[x]):
                        tsv.append(u'{0}\t{1}\t{2}'.format(self.xaxis_labels[x].value, self.series_labels[y],
                                                           self.series_data[x][y]))
        else:
            for y in range(len(self.series_labels)):
                for x in range(len(self.xaxis_labels)):
                    if y < len(self.series_data):
                        tsv.append(u'{0}\t{1}\t{2}'.format(self.xaxis_labels[x].value, self.series_labels[y],
                                                           self.series_data[0][x]))

        return '\n'.join(tsv)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parses a bar chart svg and converts to tsv')
    parser.add_argument('file', help='file containing the bar chart svg to parse')
    args = parser.parse_args()

    with open(args.file, 'r') as fp:
        bar_chart_svg = fp.read()
    bar_chart_parser = BarChartParser(bar_chart_svg)
    print bar_chart_parser.convert_to_tsv()
