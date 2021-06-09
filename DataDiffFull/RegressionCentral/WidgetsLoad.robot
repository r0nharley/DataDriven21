*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/PageObjects/CommonPage.robot

*** Variables ***

*** Keywords ***
Confirm all Widgets Load
    Leasing & Rents: Occupancy & Unit Availability
    Leasing & Rents: Leasing
    Leasing & Rents: Rent Roll & Expirations
    Leasing & Rents: Delinquency
    
    Finance: Financial Review
    Finance: Revenue
    Finance: Expenses
    Finance: Expenses Below NOI
    
    My Meetings: Weekly Property Snapshot
    My Meetings: Pricing & Recent Rents
    
Confirm for Visualization
    CommonPage.Open Dashboard Feature  Visualization
    CommonPage.Wait Until All Widgets Are Loaded
    # Verify here
    
Confirm for Details
    CommonPage.Open Dashboard Feature  Details
    CommonPage.Wait Until All Widgets Are Loaded
    # Verify here
    
Leasing & Rents: Occupancy & Unit Availability
    Log To Console  Confirm widgets load for Leasing & Rents: Occupancy & Unit Availability
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Occupancy & Unit Availability
    Confirm for Visualization
    Confirm for Details

Leasing & Rents: Leasing
    Log To Console  Confirm widgets load for Leasing & Rents: Leasing
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Leasing
    Confirm for Visualization
    Confirm for Details

Leasing & Rents: Rent Roll & Expirations
    Log To Console  Confirm widgets load for Leasing & Rents: Rent Roll & Expirations
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Rent Roll & Expirations
    Confirm for Visualization
    Confirm for Details
    
Leasing & Rents: Delinquency
    Log To Console  Confirm widgets load for Leasing & Rents: Delinquency
    CommonPage.Navigate to Dashboard using Header Buttons  Leasing & Rents  Delinquency
    Confirm for Visualization
    Confirm for Details
    
Finance: Financial Review
    Log To Console  Confirm widgets load for Finance: Financial Review
    CommonPage.Navigate to Dashboard using Header Buttons  Finance  Financial Review
    Confirm for Visualization
    Confirm for Details

Finance: Revenue
    Log To Console  Confirm widgets load for Finance: Revenue
    CommonPage.Navigate to Dashboard using Header Buttons  Finance  Revenue
    Confirm for Visualization
    Confirm for Details

Finance: Expenses
    Log To Console  Confirm widgets load for Finance: Expenses
    CommonPage.Navigate to Dashboard using Header Buttons  Finance  Expenses
    Confirm for Visualization
    Confirm for Details
    
Finance: Expenses Below NOI
    Log To Console  Confirm widgets load for Finance: Expenses Below NOI
    CommonPage.Navigate to Dashboard using Header Buttons  Finance  Expenses Below NOI
    Confirm for Visualization
    Confirm for Details
    
My Meetings: Weekly Property Snapshot
    Log To Console  Confirm widgets load for My Meetings: Weekly Property Snapshot
    CommonPage.Navigate to Dashboard using Header Buttons  My Meetings  Weekly Property Snapshot
    Confirm for Visualization
    Confirm for Details
    
My Meetings: Pricing & Recent Rents
    Log To Console  Confirm widgets load for My Meetings: Pricing & Recent Rents
    CommonPage.Navigate to Dashboard using Header Buttons  My Meetings  Pricing & Recent Rents
    Confirm for Visualization
    Confirm for Details
