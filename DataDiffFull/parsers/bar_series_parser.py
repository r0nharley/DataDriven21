from series_parser import SeriesParser


class BarSeriesParser(SeriesParser):
    """
    Child class for parsing bar series
    """
    def parse(self, series, offset_x, offset_y, xaxis_labels, yaxis_range):
        """
        Parsing the html for a bar series and returns the data from it
        NOTE: Data values are *not* exact since bar widths are rounded to the nearest integer
        :param series: The bar series to parse
        :param offset_x: y offset of the chart in pixels
        :param offset_y: y offset of the chart in pixels
        :param xaxis_labels: x-axis labels and their end pixels
        :param yaxis_range: y-axis min/max and their pixel locations
        :return: an array of the values for the bar series
        """
        data = []
        raw_series_data = series.select('rect')
        for data_point in raw_series_data:
            top = self.get_y_value(float(data_point['y']) + offset_y, yaxis_range)
            bottom = self.get_y_value(float(data_point['y']) + float(data_point['height']) + offset_y, yaxis_range)
            if 'highcharts-negative' in data_point['class']:
                data.append(top - bottom)
            else:
                data.append(bottom - top)
        return data
