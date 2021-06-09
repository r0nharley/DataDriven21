import argparse

from chart_parser import ChartParser


class ColumnChartParser(ChartParser):
    """
    Child class for parsing column charts
    """

    def get_series_yaxis(self, series):
        """
        Override from parent.  Returns the secondary y-axis for line series otherwise returns the primary.
        This behavior is not 100% confirmed but matches what I have seen so far in the charts.
        :param series: The html representation of the chart series
        :return: The y-axis data to use for the chart series
        """
        # Assumption: When the secondary y-axis exists, only a line series uses it
        if len(self.yaxis_range) > 1 and 'highcharts-spline-series' in series['class']:
            return self.yaxis_range[1]

        return self.yaxis_range[0]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parses a column chart svg and converts to tsv')
    parser.add_argument('file', help='file containing the column chart svg to parse')
    parser.add_argument('-s', '--series', default='', help='series by which the chart is sorted')
    args = parser.parse_args()

    with open(args.file, 'r') as fp:
        column_chart_svg = fp.read()
    column_chart_parser = ColumnChartParser(column_chart_svg, args.series)
    print column_chart_parser.convert_to_tsv()
