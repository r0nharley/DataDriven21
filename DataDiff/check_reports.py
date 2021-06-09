from argparse import ArgumentParser
import logging
import os
import sys
from retrying import retry
from subprocess import Popen, PIPE

log = logging.getLogger('')
log.setLevel(logging.WARN)
log_format = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
ch = logging.StreamHandler(sys.stdout)
ch.setFormatter(log_format)
log.addHandler(ch)


def get_expected_report_count():
    path = './HasDataTest/Reports'
    count = sum([len(files) for _, __, files in os.walk(path)])
    return count


def get_matcher(expected_count=None):
    if not expected_count:
        expected_count = get_expected_report_count()

    def if_count_doesnt_match(count):
        log.warn("# reports: {} out of {}".format(count, expected_count))
        return count != expected_count

    return if_count_doesnt_match


def check_reports(query_name, genesis_app_name):
    if query_name == 'all_reports':
        query = 'select count(*) from repository_report;'
    elif query_name == 'processed_reports':
        query = "select count(*) from repository_report where status='PROCESSED';"
    elif query_name == 'sleeping_reports':
        query = "select count(*) from repository_report where status in ('SLEEPING', 'PROCESSING', 'PROCESSED');"
    else:
        raise Exception('query_name not supported')

    p = Popen(['heroku', 'pg:psql', '-a', genesis_app_name, '-c', query], stdout=PIPE)
    output, err = p.communicate()
    lines = output.splitlines()
    count = int(lines[2])

    return count


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('query_name')
    parser.add_argument('genesis_app_name')
    parser.add_argument('timeout_mins')
    parser.add_argument('expected_count', default=None, nargs='?')
    timeout_ms = 30 * 60 * 1000
    args = parser.parse_args()
    if args.timeout_mins:
        timeout_ms = int(args.timeout_mins) * 60 * 1000
    expected_count = None
    if args.expected_count:
        expected_count = int(args.expected_count)
    retry_args = {
        'retry_on_result': (get_matcher(expected_count)),
        'stop_max_delay': timeout_ms,
        'wait_fixed': (2 * 60 * 1000)
    }
    report_checker = retry(**retry_args)(check_reports)
    report_checker(args.query_name, args.genesis_app_name)
