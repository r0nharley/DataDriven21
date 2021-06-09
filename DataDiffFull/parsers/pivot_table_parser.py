import argparse

from utility import get_value, is_number

from table_parser import TableParser


class PivotTableParser(TableParser):
    """
    Class for parsing data out of pivot table
    """

    def convert_to_tsv(self):
        """
        Converts a table's data to tab separated value string
        :return: the tab separated value string
        """
        tsv, num_data_rows_matching_last_sorted_value = self.get_data_rows_matching_last_sorted_value()

        for row in range(len(self.data_cells) - num_data_rows_matching_last_sorted_value):
            frozen_data_columns = []
            for column in range(len(self.frozen_columns[row])):
                if all(is_number(x[column]) for x in self.frozen_columns):
                    frozen_data_columns.append(column)
                    row_header = ':'.join(filter(lambda x: not is_number(x), self.frozen_columns[row][:column]))
                    column_header = self.frozen_corner[column]
                    tsv_entry = u'{0}\t{1}\t{2}'.format(row_header, column_header,
                                                        get_value(self.frozen_columns[row][column]))
                    if tsv_entry not in tsv:
                        tsv.append(tsv_entry)
            row_header = ':'.join(filter(lambda x: x not in frozen_data_columns, self.frozen_columns[row]))
            for column in range(len(self.data_cells[row])):
                column_header = ':'.join(fr[column] for fr in self.frozen_rows)
                tsv.append(u'{0}\t{1}\t{2}'.format(row_header, column_header, get_value(self.data_cells[row][column])))
        return '\n'.join(tsv)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parses a pivot table div and converts to tsv')
    parser.add_argument('file', help='file containing the pivot table div to parse')
    parser.add_argument('-c', '--column', default='', help='column by which the table is sorted')
    args = parser.parse_args()

    with open(args.file, 'r') as fp:
        pivot_table_html = fp.read()
    pivot_table_parser = PivotTableParser(pivot_table_html, args.column)
    print pivot_table_parser.convert_to_tsv()
