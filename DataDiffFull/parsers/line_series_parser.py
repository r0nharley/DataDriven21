from series_parser import SeriesParser


class LineSeriesParser(SeriesParser):
    """
    Child class for parsing line series
    """

    @staticmethod
    def series_point_separator():
        """
        The character that separates points within the series string.  For a line series, it's "C" (in an svg, "C"
        indicates draw a curved line from the previous point to this one).
        :return: 'C'
        """
        return 'C'

    def get_all_y_pixels(self, path_string):
        """
        Gets the y pixel locations of each point within a line
        :param path_string: the path string from the html element that defines the line
        :return: an array of the y pixel values for each point in the line
        """
        y_pixels = []
        parts = path_string.split(' {} '.format(self.series_point_separator()))
        for part in parts:
            y_pixels.append(float(part.split(' ')[-1]))
        return y_pixels

    def parse(self, series, offset_x, offset_y, xaxis_labels, yaxis_range):
        """
        Parsing the html for a line series and returns the data from it
        :param series: The column series to parse
        :param offset_x: y offset of the chart in pixels
        :param offset_y: y offset of the chart in pixels
        :param xaxis_labels: x-axis labels and their end pixels
        :param yaxis_range: y-axis min/max and their pixel locations
        :return: an array of the values for the line series
        """
        raw_line_data = series.select('path')[0]['d']
        line_data = self.get_all_y_pixels(raw_line_data)
        data = []
        for item in line_data:
            data.append(self.get_y_value(item + offset_y, yaxis_range))
        return data
