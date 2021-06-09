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
Resource  ../Resources/PageObjects/OperationsLeasesKPIValues.robot
Resource  ../Resources/PageObjects/OperationsFutureOccupancyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsRentPerSqFtKPIValues.robot


*** Keywords ***
Rentlytics User Signin Extended
    UserSignin.User Signin Extended
Rentlytics Winterwood Executive KPI Has Data
    ExecutiveKPIValues.Rentlytics Winterwood Executive KPI Has Data
Rentlytics Winterwood Property Grouping Has Data
    PropertyGroupingsKPIValues.Rentlytics Winterwood Property Grouping Has Data
Rentlytics Winterwood Finances By Property KPI Has Data
    FinancesByPropertyKPIValues.Rentlytics Winterwood Finances By Property KPI Has Data
Rentlytics Winterwood Finances By Month Has Data
    FinancesByMonthKPIValues.Rentlytics Winterwood Finances By Month Has Data
Rentlytics Winterwood Finance Trends Has Data
    FinancesByTrendsKPIValues.Rentlytics Winterwood Finance Trends Has Data
Rentlytics Winterwood Finance Utilities Has Data
    FinancesUtilitiesKPIValues.Rentlytics Winterwood Finance Utilities Has Data
Rentlytics Winterwood Finance Capex Has Data
    FinancesCapexKPIValues.Rentlytics Winterwood Finance Capex Has Data
Rentlytics Winterwood Operations Single Property Has Data
    OperationsSinglePropertyKPIValues.Rentlytics Winterwood Operations Single Property Has Data
Rentlytics Winterwood Operations Occupancy Has Data
    OperationsOccupancyKPIValues.Rentlytics Winterwood Operations Occupancy Has Data
Rentlytics Winterwood Operations Delinquency Has Data
    OperationsDelinquencyKPIValues.Rentlytics Winterwood Operations Delinquency Has Data
Rentlytics Winterwood Operations Rents Has Data
    OperationsRentsKPIValues.Rentlytics Winterwood Operations Rents Has Data
Rentlytics Winterwood Operations Leases Has Data
    OperationsLeasesKPIValues.Rentlytics Winterwood Operations Leases Has Data
Rentlytics Winterwood Operations Future Occupancy Has Data
    OperationsFutureOccupancyKPIValues.Rentlytics Winterwood Operations Future Occupancy Has Data
Rentlytics Winterwood Operations Rent per Sq Ft Has Data
    OperationsRentPerSqFtKPIValues.Rentlytics Winterwood Operations Rent per Sq Ft Has Data
