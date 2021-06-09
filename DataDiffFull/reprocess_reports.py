import logging
import sys
from subprocess import Popen, PIPE, call

log = logging.getLogger('')
log.setLevel(logging.WARN)
log_format = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
ch = logging.StreamHandler(sys.stdout)
ch.setFormatter(log_format)
log.addHandler(ch)


def reprocess_reports():
    query = 'select Min(id) from repository_report group by report_set_id;'

    p = Popen(['heroku', 'pg:psql', '-a', 'rl-genesis-test', '-c', query], stdout=PIPE)
    output, err = p.communicate()
    lines = output.splitlines()
    lines = lines[2:-2]
    for line in lines:
        call(['heroku', 'run', '--size', 'performance-m', './manage.py', 'process_report', line, '-a',
              'rl-genesis-test'])


if __name__ == '__main__':
    reprocess_reports()
