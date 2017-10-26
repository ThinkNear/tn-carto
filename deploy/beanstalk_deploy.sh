#!/bin/bash

set -e           # fail the script if any line fails
set -x           # print all executed commands
set -o pipefail  # fail if any command within a series of piped commands fails, instead of just the rightmost

echo "APPLICATION_VERSION_LABEL=${APPLICATION_VERSION_LABEL}"
echo "ENVIRONMENT_NAME=${ENVIRONMENT_NAME}"

aws elasticbeanstalk update-environment --environment-name $ENVIRONMENT_NAME --version-label $APPLICATION_VERSION_LABEL

STATUS_CHECK_LIMIT=20  # number of checks before failure
WAIT_TIME=30           # number of seconds between each check

echo "Checking status over next $((STATUS_CHECK_LIMIT*WAIT_TIME)) seconds"

for (( status_counter=0; status_counter < $STATUS_CHECK_LIMIT; status_counter++ )) ; do
    echo "Waiting $WAIT_TIME seconds"
    sleep $WAIT_TIME
    DESCRIBE_ENV=`aws elasticbeanstalk describe-environments --environment-names $ENVIRONMENT_NAME`
    echo $DESCRIBE_ENV
    STATUS=`echo $DESCRIBE_ENV | grep -Po '(?<="Status": ")[^"]*'`
    HEALTH_STATUS=`echo $DESCRIBE_ENV | grep -Po '(?<="HealthStatus": ")[^"]*'`

    if [ "$STATUS" = "Ready" ]; then
        if [ "$HEALTH_STATUS" == "Ok" ]; then
            break
        else
            continue
        fi
    fi
done


if [ "$STATUS" != "Ready" ]; then
    echo "Host state is uncertain as it exceeded wait period"
    exit 1
elif [ "$HEALTH_STATUS" != "Ok" ]; then
    echo "Host not healthy, status: '${HEALTH_STATUS}'"
    exit 2
else
    echo "Host is healthy and deployment succeeded"
fi
