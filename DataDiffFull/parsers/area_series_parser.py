from line_series_parser import LineSeriesParser


class AreaSeriesParser(LineSeriesParser):
    """
    Child class for parsing area series.  Area series are essentially just line series with straight versus curved
    lines from point to point.
    """

    @staticmethod
    def series_point_separator():
        """
        The character that separates points within the series string.  For an area series, it's "L" (in an svg, "L"
        indicates draw a straight line from the previous point to this one).
        :return: 'L'
        """
        return 'L'
