import argparse
import os
from logging import format_log_data


# data, format="variable", file_path="", formatter=HTMLFormatter
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Formats the provided log file into the format provided, using the formatter provided '
    )
    parser.add_argument('-s', '--source', type=str,
                        help='The source log file path to format.')
    parser.add_argument('-f', '--format', type=str,
                        help='The format in which you want the log formatted.')
    parser.add_argument('-d', '--destination', type=str,
                        help='The destination file name to save the results to. File must be in the same directory as '
                             'the source file.')
    args = parser.parse_args()

    current_directory_path = os.getcwd()

    format_log_data(os.path.join(current_directory_path, args.source),
                    args.format,
                    os.path.join(current_directory_path, args.destination))
