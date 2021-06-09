*** Settings ***
Resource  ../Resources/PageObjects/UserSignin.robot
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

*** Keywords ***
Rentlytics User Signin Extended
    UserSignin.User Signin Extended
Rentlytics Livcor Executive KPI Has Data
    ExecutiveKPIValues.Rentlytics Livcor Executive KPI Has Data
Rentlytics Livcor Property Grouping Has Data
    PropertyGroupingsKPIValues.Rentlytics Livcor Property Grouping Has Data
Rentlytics Livcor Finances By Property KPI Has Data
    FinancesByPropertyKPIValues.Rentlytics Livcor Finances By Property KPI Has Data
Rentlytics Livcor Finances By Month Has Data
    FinancesByMonthKPIValues.Rentlytics Livcor Finances By Month Has Data
Rentlytics Livcor Finance Trends Has Data
    FinancesByTrendsKPIValues.Rentlytics Livcor Finance Trends Has Data
Rentlytics Livcor Finance Utilities Has Data
    FinancesUtilitiesKPIValues.Rentlytics Livcor Finance Utilities Has Data
Rentlytics Livcor Finance Capex Has Data
    FinancesCapexKPIValues.Rentlytics Livcor Finance Capex Has Data
Rentlytics Livcor Operations Single Property Has Data
    OperationsSinglePropertyKPIValues.Rentlytics Livcor Operations Single Property Has Data
Rentlytics Livcor Operations Occupancy Has Data
    OperationsOccupancyKPIValues.Rentlytics Livcor Operations Occupancy Has Data
Rentlytics Livcor Operations Delinquency Has Data
    OperationsDelinquencyKPIValues.Rentlytics Livcor Operations Delinquency Has Data
Rentlytics Livcor Operations Rents Has Data
    OperationsRentsKPIValues.Rentlytics Livcor Operations Rents Has Data
Rentlytics Operations Leases Has Data
    OperationsLeasesKPIValues.Rentlytics Operations Leases Has Data
Rentlytics Livcor Operations Future Occupancy Has Data
    OperationsFutureOccupancyKPIValues.Rentlytics Livcor Operations Future Occupancy Has Data
Rentlytics Livcor Operations Rent per Sq Ft Has Data
    OperationsRentPerSqFtKPIValues.Rentlytics Livcor Operations Rent per Sq Ft Has Data
Rentlytics Livcor Marketing Overview Has Data
    MarketingOverviewKPIValues.Rentlytics Livcor Marketing Overview Has Data
Rentlytics Livcor Marketing Traffic Counts Has Data
    MarketingTrafficCountsKPIValues.Rentlytics Livcor Marketing Traffic Counts Has Data
Rentlytics Livcor Marketing Conversion Funnel Has Data
    MarketingConversionFunnelKPIValues.Rentlytics Livcor Marketing Conversion Funnel Has Data
Rentlytics Livcor Marketing Leasing Results Has Data
    MarketingLeasingResultsKPIValues.Rentlytics Livcor Marketing Leasing Results Has Data
Rentlytics Livcor Cost Analysis Has Data
    MarketingCostAnalysisKPIValues.Rentlytics Livcor Cost Analysis Has Data