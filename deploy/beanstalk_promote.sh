#!/bin/bash

set -e           # fail the script if any line fails
set -x           # print all executed commands
set -o pipefail  # fail if any command within a series of piped commands fails, instead of just the rightmost

echo "APPLICATION_VERSION_LABEL=${APPLICATION_VERSION_LABEL}"
echo "APPLICATION_NAME=%{APPLICATION_NAME}"

echo "Creating beanstalk version: ${APPLICATION_VERSION_LABEL}"

S3_BUCKET="thinknear-etl"
S3_BUCKET_KEY="production/deployments/tn-carto/${APPLICATION_VERSION_LABEL}.zip"
APPLICATION_ARCHIVE="${APPLICATION_VERSION_LABEL}.zip"

echo "Uploading archive to S3"
aws s3api put-object --bucket $S3_BUCKET --key $S3_BUCKET_KEY --body $APPLICATION_ARCHIVE

echo "Creating application version"
aws elasticbeanstalk create-application-version --application-name $APPLICATION_NAME --version-label $APPLICATION_VERSION_LABEL \
    --source-bundle S3Bucket=$S3_BUCKET,S3Key=$S3_BUCKET_KEY --auto-create-application

echo "Application version '${APPLICATION_VERSION_LABEL}' created"
