import logging

import sys

import requests
from pytz import timezone

import pytz
from datetime import datetime, timedelta
from dateutil import parser

from retrying import retry

log = logging.getLogger('')
log.setLevel(logging.WARN)
log_format = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
ch = logging.StreamHandler(sys.stdout)
ch.setFormatter(log_format)
log.addHandler(ch)

max_delay = 30 * 60 * 1000
interval = 1 * 60 * 1000


def if_dates_are_old(dates):
    current_date, build_date, query_date = dates
    dates_are_old = build_date is None or query_date is None or \
        (build_date < current_date and query_date < current_date)
    if dates_are_old:
        log.warn("build_date ({}) and query_date ({}) haven't surpassed current_date ({}) yet.".format(build_date,
                                                                                                       query_date,
                                                                                                       current_date))
    return dates_are_old


def get_date(server):
    url = 'https://rl-genesis-test.herokuapp.com/sisense/api/cube-status/?server={}'.format(server)
    response = requests.get(url)
    data = response.json()
    first_item = data['item'][0]
    last_built = first_item['lastBuiltPacificTime']
    try:
        date = parser.parse(last_built)
        date = timezone('US/Pacific').localize(date)
    except ValueError:
        date = None
    return date


@retry(retry_on_result=if_dates_are_old, stop_max_delay=max_delay, wait_fixed=interval)
def check_cube_build(current_date):
    build_date = get_date('build')
    query_date = get_date('query')
    return current_date, build_date, query_date


if __name__ == '__main__':
    current_date = datetime.now(tz=pytz.utc)
    current_date = current_date.astimezone(timezone('US/Pacific'))
    current_date = current_date - timedelta(minutes=1)
    check_cube_build(current_date)
