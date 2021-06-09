import os
from importlib import import_module

from robot.libraries.BuiltIn import BuiltIn

target_environment = os.environ.get('TARGET_ENVIRONMENT', 'staging')
settings = import_module('settings.{}'.format(target_environment))


def get_kpis(file_name):
    with open(file_name) as f:
        lines = f.readlines()
    kpis = []
    for line in lines:
        kpi = line.strip('\n')
        kpi = kpi.strip('%')
        kpi = kpi.strip('M')
        kpi = kpi.strip('K')
        kpi = kpi.strip('$')
        kpi = kpi.replace(',', '')
        if 'N\A' in kpi:
            kpis.append(None)
        else:
            kpis.append(float(kpi))
    return kpis


def greater_than_threshold(percent, title, dashboard):
    threshold_percent = settings.threshold_percent
    if dashboard in settings.kpi_thresholds and title in settings.kpi_thresholds[dashboard]:
        threshold_percent = settings.kpi_thresholds[dashboard][title]
    if abs(percent) > threshold_percent:
        return True, threshold_percent
    return False, threshold_percent


def log_diffs(builtin, diffs):
    builtin.log('', console=True)
    log_format = '{:<30s} {:<10} {:<10} {:<12} {:<15s}'
    headers = log_format.format('title', settings.env1, settings.env2, 'diff_percent', 'status')
    builtin.log(headers, console=True)
    for diff in diffs:
        percent = diff['diff_percent']
        title = diff['title']
        if percent is None:
            status = "couldn't diff"
        else:
            exceeded_threshold, threshold_percent = greater_than_threshold(percent, title, diff['dashboard'])
            if exceeded_threshold:
                status = 'exceeded {}%'.format(threshold_percent)
            else:
                status = 'within {}%'.format(threshold_percent)

        line = log_format.format(title, diff['kpi1_value'], diff['kpi2_value'], percent, status)
        builtin.log(line, console=True)


def should_fail(diffs):
    for diff in diffs:
        percent = diff['diff_percent']
        if percent is None:
            return True
        exceeded_threshold, _ = greater_than_threshold(percent, diff['title'], diff['dashboard'])
        if exceeded_threshold:
            return True
    return False


def get_diff(kpi1, kpi2, dashboard, titles, i):
    if (kpi1 and kpi2 is None) or (kpi1 is None and kpi2):
        diff = {
            "dashboard": dashboard,
            "title": titles[i],
            "kpi1_value": kpi1,
            "kpi2_value": kpi2,
            "diff_percent": None
        }
        return diff

    difference = kpi2 - kpi1
    if difference == 0:
        return None

    diff_percent = round(((difference / kpi1) * 100), 2)
    diff = {
        "dashboard": dashboard,
        "title": titles[i],
        "kpi1_value": kpi1,
        "kpi2_value": kpi2,
        "diff_percent": diff_percent
    }
    return diff


def get_diffs(dashboard, kpis1, kpis2, titles):
    diffs = []
    for i, (kpi1, kpi2) in enumerate(zip(kpis1, kpis2)):
        if not kpi1 and not kpi2:
            continue
        diff = get_diff(kpi1, kpi2, dashboard, titles, i)
        if diff:
            diffs.append(diff)
    return diffs


def diff_kpis(file1, file2, dashboard):
    builtin = BuiltIn()
    kpis1 = get_kpis(file1)
    kpis2 = get_kpis(file2)
    if not kpis1 or not kpis2:
        builtin.fail('no KPIs found!')
    titles = settings.kpi_titles[dashboard]
    diffs = get_diffs(dashboard, kpis1, kpis2, titles)
    if diffs:
        log_diffs(builtin, diffs)
        if should_fail(diffs):
            builtin.fail('significant differences found!')
