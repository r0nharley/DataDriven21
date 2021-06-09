*** Settings ***
Resource   ${EXECDIR}/RegressionCentral/PageObjects/DashboardPage.robot


*** Variables ***
${Dashboard_ExportPDF} =  leasing-rents-occupancy-unit-availability


*** Keywords ***
Export to PDF Test
    DashboardPage.Navigate to dashboard  ${Dashboard_ExportPDF}
    DashboardPage.Export to PDF
    DashboardPage.Navigate to dashboard details  ${Dashboard_ExportPDF}
    DashboardPage.Export to PDF
