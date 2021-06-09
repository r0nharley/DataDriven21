#!/usr/bin/env bash
if [ -z "${RUN_TESTS+x}" ]
then
    echo "RUN_TESTS environment variable isn't set. Setting it now to 1."
    RUN_TESTS=1
fi

if [ -z "${TARGET_ENVIRONMENT+x}" ]
then
    echo "TARGET_ENVIRONMENT environment variable isn't set. Setting it now to staging."
    TARGET_ENVIRONMENT=staging
fi

if [ "${RUN_TESTS}" -eq 1 ]
then
    case $TARGET_ENVIRONMENT in
        "test" ) case $CIRCLE_NODE_INDEX in
                      0 ) robot -d "$CIRCLE_ARTIFACTS" HasDataTest/HasDataBH/Tests/BH_Has_Data.robot
                          ;;
                      1 ) robot -d "$CIRCLE_ARTIFACTS" Genesis
                          ;;
                      2 ) echo "TBD"
                          ;;
                 esac ;;
        * ) case $CIRCLE_NODE_INDEX in
                 0) PROD=HasDataProd/HasDataBH/Tests/BH_Has_Data.robot
                    STAGE=HasDataStage/HasDataBH/Tests/BH_Has_Data.robot
                    robot -d "$CIRCLE_ARTIFACTS" "$PROD" "$STAGE"
                    ;;
                 1) PROD=HasDataProd/HasDataLivcor/Tests/Livcor_Has_Data.robot
                    STAGE=HasDataStage/HasDataLivcor/Tests/Livcor_Has_Data.robot
                    robot -d "$CIRCLE_ARTIFACTS" "$PROD" "$STAGE"
                    ;;
                 2) PROD=HasDataProd/HasDataWinterwood/Tests/Winterwood_Has_Data.robot
                    STAGE=HasDataStage/HasDataWinterwood/Tests/Winterwood_Has_Data.robot
                    robot -d "$CIRCLE_ARTIFACTS" "$PROD" "$STAGE"
                    ;;
            esac ;;
    esac
else
    echo "set RUN_TESTS environment variable to 1 in order to run robot tests"
fi

