*** Settings ***
Resource  ../Resources/PageObjects/BISearchTest.robot
Resource  ../Resources/PageObjects/UserSignin.robot
Resource  ../Resources/PageObjects/ExecutiveKPIValues.robot
Resource  ../Resources/PageObjects/PropertyGroupingsKPIValues.robot
Resource  ../Resources/PageObjects/FinancesByPropertyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsSinglePropertyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsOccupancyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsRentsKPIValues.robot
Resource  ../Resources/PageObjects/OperationsLeasesKPIValues.robot
Resource  ../Resources/PageObjects/OperationsLeasePerformance.robot
Resource  ../Resources/PageObjects/OperationsFutureOccupancyKPIValues.robot
Resource  ../Resources/PageObjects/OperationsRentPerSqFtKPIValues.robot
Resource  ../Resources/PageObjects/CustomAssetManagerCustom.robot

*** Keywords ***
Rentlytics User Signin Extended
    UserSignin.User Signin Extended
BI Search Tests
    BISearchTest.BI Search Test
Rentlytics BH Management Executive KPI Has Data
    ExecutiveKPIValues.Rentlytics BH Management Executive KPI Has Data
Rentlytics BH Management Property Grouping Has Data
    PropertyGroupingsKPIValues.Rentlytics BH Management Property Grouping Has Data
Rentlytics BH Management Finances By Property KPI Has Data
    FinancesByPropertyKPIValues.Rentlytics BH Management Finances By Property KPI Has Data
Rentlytics BH Management Operations Single Property Has Data
    OperationsSinglePropertyKPIValues.Rentlytics BH Management Operations Single Property Has Data
Rentlytics BH Management Operations Occupancy Has Data
    OperationsOccupancyKPIValues.Rentlytics BH Management Operations Occupancy Has Data
Rentlytics BH Management Operations Rents Has Data
    OperationsRentsKPIValues.Rentlytics BH Management Operations Rents Has Data
Rentlytics BH Management Operations Leases Has Data
    OperationsLeasesKPIValues.Rentlytics BH Management Operations Leases Has Data
Rentlytics BH Management Operations Lease Performance Has Data
    OperationsLeasePerformance.Rentlytics BH Management Operations Lease Performance Has Data
Rentlytics BH Management Operations Future Occupancy Has Data
    OperationsFutureOccupancyKPIValues.Rentlytics BH Management Operations Future Occupancy Has Data
Rentlytics BH Management Operations Rent per Sq Ft Has Data
    OperationsRentPerSqFtKPIValues.Rentlytics BH Management Operations Rent per Sq Ft Has Data
Rentlytics BH Management Asset Manager Custom KPI Has Data
    CustomAssetManagerCustom.Rentlytics BH Management Asset Manager Custom KPI Has Data