from series_parser import SeriesParser


class ColumnSeriesParser(SeriesParser):
    """
    Child class for parsing column series
    """
    def parse(self, series, offset_x, offset_y, xaxis_labels, yaxis_range):
        """
        Parsing the html for a column series and returns the data from it
        NOTE: Data values are *not* exact since column heights are rounded to the nearest integer
        :param series: The column series to parse
        :param offset_x: y offset of the chart in pixels
        :param offset_y: y offset of the chart in pixels
        :param xaxis_labels: x-axis labels and their end pixels
        :param yaxis_range: y-axis min/max and their pixel locations
        :return: an array of strings with tab-separated value/color pairs for the column series
        """
        data = []
        raw_series_data = series.select('rect')
        for data_point in raw_series_data:
            x_index = self.get_x_index(float(data_point['x']) + offset_x, xaxis_labels)
            while len(data) < x_index:
                data.append('0\tN/A')
            top = self.get_y_value(float(data_point['y']) + offset_y, yaxis_range)
            bottom = self.get_y_value(float(data_point['y']) + float(data_point['height']) + offset_y, yaxis_range)
            if 'highcharts-negative' in data_point['class']:
                value = bottom - top
            else:
                value = top - bottom
            data.append('{}\t{}'.format(value, data_point['fill']))
        empty_end_columns = len(xaxis_labels) - len(data)
        for x in range(empty_end_columns):
            data.append('0\tN/A')
        return data
