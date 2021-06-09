class SeriesParser(object):
    """
    Base class for parsing a chart series
    """
    @staticmethod
    def get_x_index(x_location, xaxis_labels):
        """
        Determines the x index of a data point based on it's pixel location
        :param x_location: the pixel location of the data point
        :param xaxis_labels: the array of xaxis items with their pixel cutoffs
        :return: the x index of the data point
        """
        index = filter(lambda x: x.pixels >= x_location, xaxis_labels)
        return len(xaxis_labels)-len(index)

    @staticmethod
    def get_y_value(y_location, yaxis_range):
        # When true, it means that the y value is at the bottom of the chart, and the bottom of the chart is above
        # 0 (i.e. the y-axis range is 600 to 1000).  In this case, we should say the y_value is 0 rather than 600.
        if y_location >= yaxis_range[1].pixels and 0 < yaxis_range[1].value < yaxis_range[0].value:
            return 0

        return yaxis_range[1].value + \
            (yaxis_range[0].value - yaxis_range[1].value) * (yaxis_range[1].pixels - y_location) / \
            (yaxis_range[1].pixels - yaxis_range[0].pixels)

    def parse(self, series, offset_x, offset_y, xaxis_labels, yaxis_range):
        raise Exception('Error: parse() Not Implemented')
