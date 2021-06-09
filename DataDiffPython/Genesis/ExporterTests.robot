*** Settings ***

Documentation   Genesis main application test suite
Library         Collections
Library         DiffLibrary
Library         RequestsLibrary
Library         ${CURDIR}/Resources/OutputManipulatorLibrary.py
Resource        Resources/GenesisApp.robot
Suite Setup     Open Browser and Login As Staff User
Test Setup      Go to Page  RootPage
Test Template   Exported Data Should Match Expected Data
Suite Teardown  Close Browser


*** Variables ***

${EXPECTED_RESULTS_ROOT}    ${EXEC_DIR}/Genesis/ExpectedResults/Exporters
${EXPORTED_RESULTS_ROOT}    ${OUTPUT_DIR}/Genesis/Exporters


*** Test Cases ***                  ORG_NAME        DATASOURCE_NAME                 EXPORTER_NAME                         START_DATE  END_DATE
BH Management - DataValidation                   BH Management   BH Management - BH Management   DataValidationExporter                2017-05-01  2017-07-31
BH Management - FutureRentedStatus               BH Management   BH Management - BH Management   FutureRentedStatusExporter
BH Management - FutureRentedStatusV2             BH Management   BH Management - BH Management   FutureRentedStatusExporterV2
BH Management - GeneralLedgerAccountMap          BH Management   BH Management - BH Management   GeneralLedgerAccountMapExporter
BH Management - GeneralLedgerAccountMapFull      BH Management   BH Management - BH Management   GeneralLedgerAccountMapFullExporter
BH Management - GeneralLedgerAccounts            BH Management   BH Management - BH Management   GeneralLedgerAccountsExporter
BH Management - GeneralLedgerEditableEntries     BH Management   BH Management - BH Management   GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
BH Management - GeneralLedgerEntries             BH Management   BH Management - BH Management   GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
BH Management - PropertyAlias                    BH Management   BH Management - BH Management   PropertyAliasExporter
BH Management - PropertyGroups                   BH Management   BH Management - BH Management   PropertyGroupsExporter
BH Management - PropertyList                     BH Management   BH Management - BH Management   PropertyListExporter
BH Management - ReportsNotReceived               BH Management   BH Management - BH Management   ReportsNotReceivedExporter
BH Management - UnitType                         BH Management   BH Management - BH Management   UnitTypeExporter
BH Management - UserList                         BH Management   BH Management - BH Management   UserListExporter

# AMC - Kennedy Wilson DataValidation                Kennedy Wilson     AMC - Kennedy Wilson    DataValidationExporter                2017-05-01  2017-07-31
# AMC - Kennedy Wilson FutureRentedStatus            Kennedy Wilson     AMC - Kennedy Wilson    FutureRentedStatusExporter
## AMC - Kennedy Wilson FutureRentedStatusV2          Kennedy Wilson     AMC - Kennedy Wilson    FutureRentedStatusExporterV2
# AMC - Kennedy Wilson GeneralLedgerAccountMap       Kennedy Wilson     AMC - Kennedy Wilson    GeneralLedgerAccountMapExporter
# AMC - Kennedy Wilson GeneralLedgerAccountMapFull   Kennedy Wilson     AMC - Kennedy Wilson    GeneralLedgerAccountMapFullExporter
# AMC - Kennedy Wilson GeneralLedgerAccounts         Kennedy Wilson     AMC - Kennedy Wilson    GeneralLedgerAccountsExporter
# AMC - Kennedy Wilson GeneralLedgerEditableEntries  Kennedy Wilson     AMC - Kennedy Wilson    GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# AMC - Kennedy Wilson GeneralLedgerEntries          Kennedy Wilson     AMC - Kennedy Wilson    GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# AMC - Kennedy Wilson PropertyAlias                 Kennedy Wilson     AMC - Kennedy Wilson    PropertyAliasExporter
# AMC - Kennedy Wilson PropertyGroups                Kennedy Wilson     AMC - Kennedy Wilson    PropertyGroupsExporter
# AMC - Kennedy Wilson PropertyList                  Kennedy Wilson     AMC - Kennedy Wilson    PropertyListExporter
# AMC - Kennedy Wilson ReportsNotReceived            Kennedy Wilson     AMC - Kennedy Wilson    ReportsNotReceivedExporter
# AMC - Kennedy Wilson UnitType                      Kennedy Wilson     AMC - Kennedy Wilson    UnitTypeExporter
# AMC - Kennedy Wilson UserList                      Kennedy Wilson     AMC - Kennedy Wilson    UserListExporter

# Greystar - Kennedy Wilson DataValidation                Kennedy Wilson          Greystar - Kennedy Wilson       DataValidationExporter                2017-05-01  2017-07-31
# Greystar - Kennedy Wilson FutureRentedStatus            Kennedy Wilson          Greystar - Kennedy Wilson       FutureRentedStatusExporter
## Greystar - Kennedy Wilson FutureRentedStatusV2          Kennedy Wilson          Greystar - Kennedy Wilson       FutureRentedStatusExporterV2
# Greystar - Kennedy Wilson GeneralLedgerAccountMap       Kennedy Wilson          Greystar - Kennedy Wilson       GeneralLedgerAccountMapExporter
# Greystar - Kennedy Wilson GeneralLedgerAccountMapFull   Kennedy Wilson          Greystar - Kennedy Wilson       GeneralLedgerAccountMapFullExporter
# Greystar - Kennedy Wilson GeneralLedgerAccounts         Kennedy Wilson          Greystar - Kennedy Wilson       GeneralLedgerAccountsExporter
# Greystar - Kennedy Wilson GeneralLedgerEditableEntries  Kennedy Wilson          Greystar - Kennedy Wilson       GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# Greystar - Kennedy Wilson GeneralLedgerEntries          Kennedy Wilson          Greystar - Kennedy Wilson       GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# Greystar - Kennedy Wilson PropertyAlias                 Kennedy Wilson          Greystar - Kennedy Wilson       PropertyAliasExporter
# Greystar - Kennedy Wilson PropertyGroups                Kennedy Wilson          Greystar - Kennedy Wilson       PropertyGroupsExporter
# Greystar - Kennedy Wilson PropertyList                  Kennedy Wilson          Greystar - Kennedy Wilson       PropertyListExporter
# Greystar - Kennedy Wilson ReportsNotReceived            Kennedy Wilson          Greystar - Kennedy Wilson       ReportsNotReceivedExporter
# Greystar - Kennedy Wilson UnitType                      Kennedy Wilson          Greystar - Kennedy Wilson       UnitTypeExporter
# Greystar - Kennedy Wilson UserList                      Kennedy Wilson          Greystar - Kennedy Wilson       UserListExporter

# Capstone - LDG DataValidation                LDG Development         Capstone - LDG                  DataValidationExporter                2017-05-01  2017-07-31
# Capstone - LDG FutureRentedStatus            LDG Development         Capstone - LDG                  FutureRentedStatusExporter
## Capstone - LDG FutureRentedStatusV2          LDG Development         Capstone - LDG                  FutureRentedStatusExporterV2
# Capstone - LDG GeneralLedgerAccountMap       LDG Development         Capstone - LDG                  GeneralLedgerAccountMapExporter
# Capstone - LDG GeneralLedgerAccountMapFull   LDG Development         Capstone - LDG                  GeneralLedgerAccountMapFullExporter
# Capstone - LDG GeneralLedgerAccounts         LDG Development         Capstone - LDG                  GeneralLedgerAccountsExporter
# Capstone - LDG GeneralLedgerEditableEntries  LDG Development         Capstone - LDG                  GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# Capstone - LDG GeneralLedgerEntries          LDG Development         Capstone - LDG                  GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# Capstone - LDG PropertyAlias                 LDG Development         Capstone - LDG                  PropertyAliasExporter
# Capstone - LDG PropertyGroups                LDG Development         Capstone - LDG                  PropertyGroupsExporter
# Capstone - LDG PropertyList                  LDG Development         Capstone - LDG                  PropertyListExporter
# Capstone - LDG ReportsNotReceived            LDG Development         Capstone - LDG                  ReportsNotReceivedExporter
# Capstone - LDG UnitType                      LDG Development         Capstone - LDG                  UnitTypeExporter
# Capstone - LDG UserList                      LDG Development         Capstone - LDG                  UserListExporter

# ConAm - Livcor / Phoenix DataValidationExporter                 LivCor      ConAm - Livcor / Phoenix        DataValidationExporter                2017-05-01  2017-07-31
# ConAm - Livcor / Phoenix FutureRentedStatusExporter             LivCor      ConAm - Livcor / Phoenix        FutureRentedStatusExporter
## ConAm - Livcor / Phoenix FutureRentedStatusExporterV2           LivCor      ConAm - Livcor / Phoenix        FutureRentedStatusExporterV2
# ConAm - Livcor / Phoenix GeneralLedgerAccountMapExporter        LivCor      ConAm - Livcor / Phoenix        GeneralLedgerAccountMapExporter
# ConAm - Livcor / Phoenix GeneralLedgerAccountMapFullExporter    LivCor      ConAm - Livcor / Phoenix        GeneralLedgerAccountMapFullExporter
# ConAm - Livcor / Phoenix GeneralLedgerAccountsExporter          LivCor      ConAm - Livcor / Phoenix        GeneralLedgerAccountsExporter
# ConAm - Livcor / Phoenix GeneralLedgerEditableEntriesExporter   LivCor      ConAm - Livcor / Phoenix        GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# ConAm - Livcor / Phoenix GeneralLedgerEntriesExporter           LivCor      ConAm - Livcor / Phoenix        GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# ConAm - Livcor / Phoenix LivCorAccountMapAuditExporter          LivCor      ConAm - Livcor / Phoenix        LivCorAccountMapAuditExporter         2017-01-01  2017-07-31
# ConAm - Livcor / Phoenix LivCorFinancialChanges                 LivCor      ConAm - Livcor / Phoenix        LivCorFinancialChanges
# ConAm - Livcor / Phoenix LivCorFinancialSetupValidation         LivCor      ConAm - Livcor / Phoenix        LivCorFinancialSetupValidation        2017-01-01  2017-07-31
# ConAm - Livcor / Phoenix LivCorHistoricalFinancialByMonth       LivCor      ConAm - Livcor / Phoenix        LivCorHistoricalFinancialByMonth      2017-01-01  2017-07-31
# ConAm - Livcor / Phoenix LivCorHistoricalFinancialYearToDate    LivCor      ConAm - Livcor / Phoenix        LivCorHistoricalFinancialYearToDate   ${EMPTY}    2017-07-31
# ConAm - Livcor / Phoenix PropertyAliasExporter                  LivCor      ConAm - Livcor / Phoenix        PropertyAliasExporter
# ConAm - Livcor / Phoenix PropertyGroupsExporter                 LivCor      ConAm - Livcor / Phoenix        PropertyGroupsExporter
# ConAm - Livcor / Phoenix PropertyListExporter                   LivCor      ConAm - Livcor / Phoenix        PropertyListExporter
# ConAm - Livcor / Phoenix ReportsNotReceivedExporter             LivCor      ConAm - Livcor / Phoenix        ReportsNotReceivedExporter
# ConAm - Livcor / Phoenix UnitTypeExporter                       LivCor      ConAm - Livcor / Phoenix        UnitTypeExporter
# ConAm - Livcor / Phoenix UserListExporter                       LivCor      ConAm - Livcor / Phoenix        UserListExporter

# Greystar - LivCor DataValidationExporter                  LivCor      Greystar - LivCor               DataValidationExporter                2017-05-01  2017-07-31
# Greystar - LivCor FutureRentedStatusExporter              LivCor      Greystar - LivCor               FutureRentedStatusExporter
## Greystar - LivCor FutureRentedStatusExporterV2            LivCor      Greystar - LivCor               FutureRentedStatusExporterV2
# Greystar - LivCor GeneralLedgerAccountMapExporter         LivCor      Greystar - LivCor               GeneralLedgerAccountMapExporter
# Greystar - LivCor GeneralLedgerAccountMapFullExporter     LivCor      Greystar - LivCor               GeneralLedgerAccountMapFullExporter
# Greystar - LivCor GeneralLedgerAccountsExporter           LivCor      Greystar - LivCor               GeneralLedgerAccountsExporter
# Greystar - LivCor GeneralLedgerEditableEntriesExporter    LivCor      Greystar - LivCor               GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# Greystar - LivCor GeneralLedgerEntriesExporter            LivCor      Greystar - LivCor               GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# Greystar - LivCor LivCorAccountMapAuditExporter           LivCor      Greystar - LivCor               LivCorAccountMapAuditExporter         2017-01-01  2017-07-31
# Greystar - LivCor LivCorFinancialChanges                  LivCor      Greystar - LivCor               LivCorFinancialChanges
# Greystar - LivCor LivCorFinancialSetupValidation          LivCor      Greystar - LivCor               LivCorFinancialSetupValidation        2017-01-01  2017-07-31
# Greystar - LivCor LivCorHistoricalFinancialByMonth        LivCor      Greystar - LivCor               LivCorHistoricalFinancialByMonth      2017-01-01  2017-07-31
# Greystar - LivCor LivCorHistoricalFinancialYearToDate     LivCor      Greystar - LivCor               LivCorHistoricalFinancialYearToDate   ${EMPTY}    2017-07-31
# Greystar - LivCor PropertyAliasExporter                   LivCor      Greystar - LivCor               PropertyAliasExporter
# Greystar - LivCor PropertyGroupsExporter                  LivCor      Greystar - LivCor               PropertyGroupsExporter
# Greystar - LivCor PropertyListExporter                    LivCor      Greystar - LivCor               PropertyListExporter
# Greystar - LivCor ReportsNotReceivedExporter              LivCor      Greystar - LivCor               ReportsNotReceivedExporter
# Greystar - LivCor UnitTypeExporter                        LivCor      Greystar - LivCor               UnitTypeExporter
# Greystar - LivCor UserListExporter                        LivCor      Greystar - LivCor               UserListExporter

# USRG - Post Investment Group 2 DataValidationExporter                Post Investment Group   USRG - Post Investment Group 2  DataValidationExporter                2017-05-01  2017-07-31
# USRG - Post Investment Group 2 FutureRentedStatusExporter            Post Investment Group   USRG - Post Investment Group 2  FutureRentedStatusExporter
## USRG - Post Investment Group 2 FutureRentedStatusExporterV2          Post Investment Group   USRG - Post Investment Group 2  FutureRentedStatusExporterV2
# USRG - Post Investment Group 2 GeneralLedgerAccountMapExporter       Post Investment Group   USRG - Post Investment Group 2  GeneralLedgerAccountMapExporter
# USRG - Post Investment Group 2 GeneralLedgerAccountMapFullExporter   Post Investment Group   USRG - Post Investment Group 2  GeneralLedgerAccountMapFullExporter
# USRG - Post Investment Group 2 GeneralLedgerAccountsExporter         Post Investment Group   USRG - Post Investment Group 2  GeneralLedgerAccountsExporter
# USRG - Post Investment Group 2 GeneralLedgerEditableEntriesExporter  Post Investment Group   USRG - Post Investment Group 2  GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# USRG - Post Investment Group 2 GeneralLedgerEntriesExporter          Post Investment Group   USRG - Post Investment Group 2  GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# USRG - Post Investment Group 2 PropertyAliasExporter                 Post Investment Group   USRG - Post Investment Group 2  PropertyAliasExporter
# USRG - Post Investment Group 2 PropertyGroupsExporter                Post Investment Group   USRG - Post Investment Group 2  PropertyGroupsExporter
# USRG - Post Investment Group 2 PropertyListExporter                  Post Investment Group   USRG - Post Investment Group 2  PropertyListExporter
# USRG - Post Investment Group 2 ReportsNotReceivedExporter            Post Investment Group   USRG - Post Investment Group 2  ReportsNotReceivedExporter
# USRG - Post Investment Group 2 UnitTypeExporter                      Post Investment Group   USRG - Post Investment Group 2  UnitTypeExporter
# USRG - Post Investment Group 2 UserListExporter                      Post Investment Group   USRG - Post Investment Group 2  UserListExporter

# Orion - Starwood DataValidationExporter                            Starwood                Orion - Starwood                DataValidationExporter                2017-05-01  2017-07-31
# Orion - Starwood FutureRentedStatusExporter                        Starwood                Orion - Starwood                FutureRentedStatusExporter
## Orion - Starwood FutureRentedStatusExporterV2                      Starwood                Orion - Starwood                FutureRentedStatusExporterV2
# Orion - Starwood GeneralLedgerAccountMapExporter                   Starwood                Orion - Starwood                GeneralLedgerAccountMapExporter
# Orion - Starwood GeneralLedgerAccountMapFullExporter               Starwood                Orion - Starwood                GeneralLedgerAccountMapFullExporter
# Orion - Starwood GeneralLedgerAccountsExporter                     Starwood                Orion - Starwood                GeneralLedgerAccountsExporter
# Orion - Starwood GeneralLedgerEditableEntriesExporter              Starwood                Orion - Starwood                GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# Orion - Starwood GeneralLedgerEntriesExporter                      Starwood                Orion - Starwood                GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# Orion - Starwood PropertyAliasExporter                             Starwood                Orion - Starwood                PropertyAliasExporter
# Orion - Starwood PropertyGroupsExporter                            Starwood                Orion - Starwood                PropertyGroupsExporter
# Orion - Starwood PropertyListExporter                              Starwood                Orion - Starwood                PropertyListExporter
# Orion - Starwood ReportsNotReceivedExporter                        Starwood                Orion - Starwood                ReportsNotReceivedExporter
# Orion - Starwood UnitTypeExporter                                  Starwood                Orion - Starwood                UnitTypeExporter
# Orion - Starwood UserListExporter                                  Starwood                Orion - Starwood                UserListExporter

# Winterwood DataValidationExporter                Winterwood              Winterwood - Winterwood         DataValidationExporter                2017-05-01  2017-07-31
# Winterwood FutureRentedStatusExporter            Winterwood              Winterwood - Winterwood         FutureRentedStatusExporter
## Winterwood FutureRentedStatusExporterV2          Winterwood              Winterwood - Winterwood         FutureRentedStatusExporterV2
# Winterwood GeneralLedgerAccountMapExporter       Winterwood              Winterwood - Winterwood         GeneralLedgerAccountMapExporter
# Winterwood GeneralLedgerAccountMapFullExporter   Winterwood              Winterwood - Winterwood         GeneralLedgerAccountMapFullExporter
# Winterwood GeneralLedgerAccountsExporter         Winterwood              Winterwood - Winterwood         GeneralLedgerAccountsExporter
# Winterwood GeneralLedgerEditableEntriesExporter  Winterwood              Winterwood - Winterwood         GeneralLedgerEditableEntriesExporter  2017-05-01  2017-07-31
# Winterwood GeneralLedgerEntriesExporter          Winterwood              Winterwood - Winterwood         GeneralLedgerEntriesExporter          2017-05-01  2017-07-31
# Winterwood PropertyAliasExporter                 Winterwood              Winterwood - Winterwood         PropertyAliasExporter
# Winterwood PropertyGroupsExporter                Winterwood              Winterwood - Winterwood         PropertyGroupsExporter
# Winterwood PropertyListExporter                  Winterwood              Winterwood - Winterwood         PropertyListExporter
# Winterwood ReportsNotReceivedExporter            Winterwood              Winterwood - Winterwood         ReportsNotReceivedExporter
# Winterwood UnitTypeExporter                      Winterwood              Winterwood - Winterwood         UnitTypeExporter
# Winterwood UserListExporter                      Winterwood              Winterwood - Winterwood         UserListExporter


*** Keywords ***

Exported Data Should Match Expected Data
    [Documentation]     Compares exporter output to expected output and fails if it doesn't match
    [Arguments]         ${org_name}  ${datasource_name}  ${exporter_name}  ${start_date}=  ${end_date}=
    ${exported_path}=   build path  ${EXPORTED_RESULTS_ROOT}  ${org_name}  ${datasource_name}  ${exporter_name}
    ${expected_path}=   build path  ${EXPECTED_RESULTS_ROOT}  ${org_name}  ${datasource_name}  ${exporter_name}

    go to page  RootPage
    ${exported_data}=   export data  ${org_name}  ${datasource_name}  ${exporter_name}  ${start_date}  ${end_date}

    write tsv  ${exporter_name}  ${exported_path}  ${exported_data}
    run keyword if  $OVERWRITE_ALL_EXPECTED_RESULTS
    ...     overwrite expected  ${exporter_name}  ${expected_path}  ${exported_data}

    diff files  ${expected_path}  ${exported_path}

Build Path
    [Arguments]     ${root}  ${org_name}  ${datasource_name}  ${exporter_name}
    ${path}=        set variable  ${root}/${org_name}/${datasource_name}/${exporter_name}.tsv
    [Return]        ${path}

Overwrite Expected
    [Documentation]     Warns user and writes exported json out to the expected dir
    [Arguments]         ${exporter_name}  ${path}  ${data}
    log  Overwriting ${path} because OVERWRITE_ALL_EXPECTED_RESULTS is True  level=WARN
    write tsv  ${exporter_name}  ${path}  ${data}
