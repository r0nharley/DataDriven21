*** Settings ***

Documentation   Genesis main application test suite
Library         Collections
Library         DiffLibrary
Library         RequestsLibrary
Resource        Resources/GenesisApp.robot
Suite Setup     Open Browser and Login As Staff User
Test Setup      Go to Page  RootPage
Suite Teardown  Close Browser



*** Variables ***
${EXPECTED_RESULTS_ROOT}    ${EXEC_DIR}/Genesis/ExpectedResults/Exporters
${EXPORTED_RESULTS_ROOT}    ${OUTPUT_DIR}/Genesis/Exporters


*** Test Cases ***

User Can Change To All Available Organizations
    :FOR  ${org_name}  IN  @{AVAILABLE_ORGS}
    \   change organization to  ${org_name}
    \   current organization should be  ${org_name}

Expected Datasources are Available
    :FOR  ${org_name}  IN  @{AVAILABLE_ORGS}
    \   change organization to  ${org_name}
    \   datasources should be  &{AVAILABLE_DATASOURCES}[${org_name}]
