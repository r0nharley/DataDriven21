*** Settings ***

Documentation  Rentlytics regression test suite

Resource  ${EXECDIR}/RegressionCentral/DataDiff.robot


*** Variables ***

${ENV1}         %env1%
${ENV2}         %env2%
${ORG_NAME}     %name%

*** Test Cases ***

#TEST_CASES