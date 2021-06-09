import os

HEROKU_APP = os.environ.get('HEROKU_APP', 'rl-genesis-test')
BROWSER = os.environ.get('BROWSER', 'phantomjs')
GENESIS_URL = os.environ.get('GENESIS_URL', 'https://{}.herokuapp.com'.format(HEROKU_APP))
STAFF_USERNAME = 'superuser@rentlytics.com'
STAFF_PASSWORD = os.environ.get('FAKE_USER_PASSWORD')
NON_STAFF_USERNAME = 'user@rentlytics.com'
NON_STAFF_PASSWORD = os.environ.get('FAKE_USER_PASSWORD')
AVAILABLE_DATASOURCES = {
    'BH Management': [
        'BH Management - BH Management'
    ],
    # 'Kennedy Wilson': [
    #     'AMC - Kennedy Wilson',
    #     'Greystar - Kennedy Wilson'
    # ],
    # 'LDG Development': [
    #     'Capstone - LDG'
    # ],
    # 'LivCor': [
    #     'ConAm - Livcor / Phoenix',
    #     'Greystar - LivCor',
    #     'Primary - LivCor',
    # ],
    # 'Post Investment Group': [
    #     'USRG - Post Investment Group 2'
    # ],
    # 'Starwood': [
    #     'Orion - Starwood'
    # ],
    # 'Winterwood': [
    #     'Winterwood - Winterwood'
    # ],
}
AVAILABLE_ORGS = AVAILABLE_DATASOURCES.keys()

# When establishing a new baseline for exporter tests, set this to True
OVERWRITE_ALL_EXPECTED_RESULTS = False

EXPORTER_RULES = {
    # order_by:
    #   Fields to sort by before comparing output. Do not use if the exporter itself does sorting.
    # ignore:
    #   List of fields that cannot not be compared at all
    # null_eq:
    #   List of fields that should be null if expected is null, but their value is based on variables
    #   outside of the control of this test (report run dates, generated ids, etc.)
    'DataValidationExporter': {
        'order_by': [
            'Property PK', 'Property Name', 'Operator GL PK', 'Operator Account Code', 'Operator Account Name',
            'Primary GL PK', 'Primary Account Code', 'Primary Account Name', 'Month',
        ],
    },
    'FutureRentedStatusExporter': {
        'order_by': [
            'Property', 'Unit', 'Resident ID', 'Resident Name', 'Unit Type', 'Unit Status',
        ]
    },
    'GeneralLedgerAccountMapFullExporter': {
        'order_by': ['organization_name', 'datasource', 'primary_account', 'datasource_account'],
    },
    'GeneralLedgerAccountMapExporter': {
        'order_by': [
            'organization_name', 'datasource', 'datasource_account', 'datasource_account_name', 'primary_account',
            'primary_account_name'
        ]
    },
    'GeneralLedgerAccountsExporter': {
        'ignore': ['created_on'],
        'order_by': ['datasource_slug', 'account_code', 'name'],
    },
    'GeneralLedgerEditableEntriesExporter': {
        'order_by': ['property_code', 'property_name', 'account_code', 'name', 'period'],
    },
    'GeneralLedgerEntriesExporter': {
        'order_by': ['property_code', 'account_code', 'name', 'period'],
    },
    'PropertyAliasExporter': {
        'ignore': ['pk', 'created_on'],
        'today_placeholder': [
            'latest_delinquency_data',
            'latest_financial_data',
            'latest_lease_data',
            'latest_marketing_data',
            'latest_unit_status_data',
        ],
        'order_by': ['name'],
    },
    'PropertyGroupsExporter': {
        'order_by': ['organization', 'group', 'attribute', 'property']
    },
    'PropertyListExporter': {
        'order_by': ['property_code', 'name'],
    },
    'UnitTypeExporter': {
        'order_by': ['property_code', 'unit_type_code'],
    },
    'UserListExporter': {
        'order_by': ['organization_name', 'pms_type', 'email']
    }
}
