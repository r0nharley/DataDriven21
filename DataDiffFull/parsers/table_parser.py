from bs4 import BeautifulSoup

from utility import clean_string, get_span_value, get_value


class TableParser(object):
    def __init__(self, table_div_html, sorted_table_column=''):
        """
        constructor/parses data out of the table html
        :param table_div_html: string containing the html of the table widget div
        :param sorted_table_column: name of the column, if any, by which the table is sorted
        """
        self.sorted_table_column = sorted_table_column
        soup = BeautifulSoup(table_div_html, 'html.parser')
        self.table_container = soup.select('.rl-table-content > .rl-table-container')[0]
        self.frozen_corner = self.get_frozen_corner()
        self.frozen_rows = self.get_frozen_rows()
        self.frozen_columns = self.get_frozen_columns()
        self.data_cells = self.get_data_cells()

    def get_frozen_corner(self):
        """
        Gets the cell data for the frozen corner (upper left) of the table
        :return: array of cell data from the frozen corner
        """
        frozen_corner = []
        frozen_corner_cells = self.table_container.select(
            '.rl-left-container > .rl-frozen-corner > table > tbody > tr > td')
        for cell in frozen_corner_cells:
            frozen_corner.append(clean_string(cell.contents[0]))
        return frozen_corner

    def get_frozen_rows(self):
        """
        Gets the cell data for the frozen rows (upper right) of the table
        :return: two-dimension array of cell data from the frozen rows
        """
        return self.get_table_data('.rl-right-container > .rl-frozen-rows')

    def get_frozen_columns(self):
        """
        Gets the cell data for the frozen columns (lower left) of the table
        :return: two-dimension array of cell data from the frozen columns
        """
        return self.get_table_data('.rl-left-container > .rl-frozen-columns')

    def get_data_cells(self):
        """
        Gets the cell data for the data cells (lower right) of the table
        :return: two-dimension array of cell data from the data cells
        """
        return self.get_table_data('.rl-right-container > .rl-scrollable-table')

    def get_table_data(self, table_selector):
        """
        Gets the cell data for a table
        :param  table_selector: xpath expression to get the div that contains the table
        :return: two-dimension array of cell data from the table
        """
        rows = self.table_container.select('{0} > table > tbody > tr'.format(table_selector))

        table_rows = []
        rowspan_placeholders = {}
        for row in rows:
            table_row = []
            while len(table_row) + 1 in rowspan_placeholders:
                table_row.append(rowspan_placeholders[len(table_row) + 1]['value'])
                if rowspan_placeholders[len(table_row)]['rows'] is 1:
                    del rowspan_placeholders[len(table_row)]
                else:
                    rowspan_placeholders[len(table_row)]['rows'] -= 1
            cells = row.select('td')
            for cell in cells:
                colspan = get_span_value(cell['colspan'])
                rowspan = get_span_value(cell['rowspan'])
                for x in range(colspan):
                    data = clean_string(cell.contents[0]) if len(cell.contents) > 0 else ''
                    table_row.append(data)
                    if rowspan > 1:
                        rowspan_placeholders[len(table_row)] = {'rows': rowspan - 1, 'value': data}
                while len(table_row) + 1 in rowspan_placeholders:
                    table_row.append(rowspan_placeholders[len(table_row) + 1]['value'])
                    if rowspan_placeholders[len(table_row)]['rows'] is 1:
                        del rowspan_placeholders[len(table_row)]
                    else:
                        rowspan_placeholders[len(table_row)]['rows'] -= 1
            table_rows.append(table_row)
        return table_rows

    def get_data_rows_matching_last_sorted_value(self):
        """
        For a table with a sorted column, find the number of data rows that match the last shown value.
        This is necessary because data sorted by columns isn't also sorted by category, and therefore the last data
        row shown one run may not be invisible the next run (a different data row with the same value might be
        visible instead).
        :return: the tsv entries for the data rows matching, if any, and the number of data rows matching the last value
        """
        tsv = []

        num_data_rows_matching_last_sorted_value = 0
        if self.sorted_table_column in self.frozen_rows[0]:
            sorted_series_index = self.frozen_rows[0].index(self.sorted_table_column)
            last_sorted_series_value = get_value(self.data_cells[-1][sorted_series_index])
            num_data_rows_matching_last_sorted_value = len(
                [x for x in self.data_cells if get_value(x[sorted_series_index]) == last_sorted_series_value])
            tsv.append(u'{0}\t{1}\t{2}'.format('Last Data Shown', self.sorted_table_column, last_sorted_series_value))
            tsv.append(u'{0}\t{1}\t{2}'.format('Last Data Shown', 'Count', num_data_rows_matching_last_sorted_value))

        return [tsv, num_data_rows_matching_last_sorted_value]
