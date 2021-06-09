import unittest

import __init__
from automation.mappings_dashboard_data import extract_summary_dashboards_data


class TestExtractSummaryDashboardsData(unittest.TestCase):

    def test_extract_summary_dashboards_data_no_mapping_file_returns_none(self):
        # test against categories and topics that done' have any saved mappings. Ensure None is returned.
        dashboard_data = extract_summary_dashboards_data("just_a_test_category", "just_a_test_topic")

        self.assertEqual(dashboard_data, None)

    def test_extract_summary_dashboards_data_mapping_file_returns_data(self):
        # now, make sure a known topic and category are returned
        dashboard_data = extract_summary_dashboards_data("Leasing & Rents", "Summary")

        self.assertIsNot(dashboard_data, None)

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(TestExtractSummaryDashboardsData)
    unittest.TextTestRunner(verbosity=2).run(suite)
