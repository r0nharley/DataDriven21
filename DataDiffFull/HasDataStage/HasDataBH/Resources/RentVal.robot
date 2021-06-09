*** Settings ***
Resource  ${EXECDIR}/RegressionCentral/CommonV.robot
Resource  ../Resources/PageObjects/BIShareTest.robot
Resource  ../Resources/PageObjects/BIChangePassword.robot
Resource  ../Resources/PageObjects/BINewUser.robot
Resource  ../Resources/PageObjects/BIDeleteUser.robot
Resource  ../Resources/PageObjects/BIFilterTest.robot
Resource  ../Resources/PageObjects/UserSignin.robot
Resource  ../Resources/PageObjects/BISearchTest.robot
Resource  ../Resources/PageObjects/MyPinboard.robot
Resource  ../Resources/PageObjects/BILeaseDataExceptionsTest.robot
Resource  ../Resources/PageObjects/ExecutiveKPIValues.robot
Resource  ../Resources/PageObjects/PropertyGroupingsKPIValues.robot
Resource  ../Resources/PageObjects/FinancesByPropertyKPIValues.robot
Resource  ../Resources/PageObjects/FinancesByMonthKPIValues.robot
Resource  ../Resources/PageObjects/FinancesByTrendsKPIValues.Robot
Resource  ../Resources/PageObjects/FinancesUtilitiesKPIValues.robot
Resource  ../Resources/PageObjects/FinancesCapexKPIValues.robot
Resource  ../Resources/PageObjects/OperationsSinglePropertyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsOccupancyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsDelinquencyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsRentsKPIValues.robot
Resource  ${EXECDIR}/RegressionCentral/PageObjects/OperationsLeasesKPIValues.robot
Resource  ../Resources/PageObjects/OperationsFutureOccupancyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsRentPerSqFtKPIValues.robot
Resource  ../Resources/PageObjects/MarketingOverviewKPIValues.robot
Resource  ../Resources/PageObjects/MarketingTrafficCountsKPIValues.robot
Resource  ../Resources/PageObjects/MarketingConversionFunnelKPIValues.robot
Resource  ../Resources/PageObjects/MarketingLeasingResultsKPIValues.robot
Resource  ../Resources/PageObjects/MarketingCostAnalysisKPIValues.robot
Resource  ../Resources/PageObjects/CustomAssetManagerCustom.robot

*** Keywords ***
Rentlytics User Signin Extended
    UserSignin.User Signin Extended
BI Create User
    BINewUser.BI New User Test
BI Delete User
    BIDeleteUser.BI Delete User Test
BI Change Password
    BIChangePassword.BI Change PW Test
BI Search Tests
    BISearchTest.BI Search Test
BI Filter Test
    BIFilterTest.BI Filter Test
My Pinboard Test
    MyPinboard.My Pinboard Test
BI Share Test
    BIShareTest.BI Share Test
BI LeaseDataExcept Test
    BILeaseDataExceptionsTest.BI LeaseDataExcept Test
Rentlytics BH Management Executive KPI Has Data
    ExecutiveKPIValues.Rentlytics BH Management Executive KPI Has Data
Rentlytics BH Management Property Grouping Has Data
    PropertyGroupingsKPIValues.Rentlytics BH Management Property Grouping Has Data
Rentlytics BH Management Finances By Property KPI Has Data
    FinancesByPropertyKPIValues.Rentlytics BH Management Finances By Property KPI Has Data
Rentlytics BH Management Finances By Month Has Data
    FinancesByMonthKPIValues.Rentlytics BH Management Finances By Month Has Data
Rentlytics BH Management Finance Trends Has Data
    FinancesByTrendsKPIValues.Rentlytics BH Management Finance Trends Has Data
Rentlytics BH Management Finance Utilities Has Data
    FinancesUtilitiesKPIValues.Rentlytics BH Management Finance Utilities Has Data
Rentlytics BH Management Finance Capex Has Data
    FinancesCapexKPIValues.Rentlytics BH Management Finance Capex Has Data
Rentlytics BH Management Operations Single Property Has Data
    OperationsSinglePropertyKPIValues.Rentlytics BH Management Operations Single Property Has Data
Rentlytics BH Management Operations Occupancy Has Data
    OperationsOccupancyKPIValues.Rentlytics BH Management Operations Occupancy Has Data
Rentlytics BH Management Operations Delinquency Has Data
    OperationsDelinquencyKPIValues.Rentlytics BH Management Operations Delinquency Has Data
Rentlytics BH Management Operations Rents Has Data
    OperationsRentsKPIValues.Rentlytics BH Management Operations Rents Has Data
Rentlytics Operations Leases Has Data
    UserSignin.User Signin Extended
    OperationsLeasesKPIValues.Rentlytics Operations Leases Has Data
    CommonV.Has Data Difference
Rentlytics BH Management Operations Future Occupancy Has Data
    OperationsFutureOccupancyKPIValues.Rentlytics BH Management Operations Future Occupancy Has Data
Rentlytics BH Management Operations Rent per Sq Ft Has Data
    OperationsRentPerSqFtKPIValues.Rentlytics BH Management Operations Rent per Sq Ft Has Data
Rentlytics BH Management Marketing Overview Has Data
    MarketingOverviewKPIValues.Rentlytics BH Management Marketing Overview Has Data
Rentlytics BH Management Marketing Traffic Counts Has Data
    MarketingTrafficCountsKPIValues.Rentlytics BH Management Marketing Traffic Counts Has Data
Rentlytics BH Management Marketing Conversion Funnel Has Data
    MarketingConversionFunnelKPIValues.Rentlytics BH Management Marketing Conversion Funnel Has Data
Rentlytics BH Management Marketing Leasing Results Has Data
    MarketingLeasingResultsKPIValues.Rentlytics BH Management Marketing Leasing Results Has Data
Rentlytics BH Management Cost Analysis Has Data
    MarketingCostAnalysisKPIValues.Rentlytics BH Management Cost Analysis Has Data
Rentlytics BH Management Asset Manager Custom KPI Has Data
    CustomAssetManagerCustom.Rentlytics BH Management Asset Manager Custom KPI Has Data