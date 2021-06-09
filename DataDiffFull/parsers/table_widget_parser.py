import argparse

from table_parser import TableParser

from utility import get_value


class TableWidgetParser(TableParser):
    """
    Class for parsing data out of a table widget
    """

    def get_unique_key_column_count(self):
        """
        Determines how many columns (starting from the left) need to be concatenated together to produce a unique key
        for each row in the data set.
        :return: number of columns that make of the unique key
        """
        columns = 0
        values = ['placeholder']
        unique_values = []
        while len(values) > len(unique_values):
            columns += 1
            values = [':'.join(x[0:columns]) for x in self.data_cells]
            unique_values = set(values)
        return columns

    def convert_to_tsv(self):
        """
        Converts a table's data to tab separated value string
        :return: the tab separated value string
        """
        tsv, num_data_rows_matching_last_sorted_value = self.get_data_rows_matching_last_sorted_value()

        unique_key_columns = self.get_unique_key_column_count()

        for row in range(len(self.data_cells) - num_data_rows_matching_last_sorted_value):
            row_header = ':'.join(self.data_cells[row][0:unique_key_columns])
            for column in range(unique_key_columns, len(self.data_cells[row])):
                column_header = self.frozen_rows[0][column]
                tsv.append(u'{0}\t{1}\t{2}'.format(row_header, column_header, get_value(self.data_cells[row][column])))
        return '\n'.join(tsv)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parses a table widget div and converts to tsv')
    parser.add_argument('file', help='file containing the table widget div to parse')
    parser.add_argument('-c', '--column', default='', help='column by which the table is sorted')
    args = parser.parse_args()

    with open(args.file, 'r') as fp:
        table_widget_html = fp.read()
    table_widget_parser = TableWidgetParser(table_widget_html, args.column)
    print table_widget_parser.convert_to_tsv()
