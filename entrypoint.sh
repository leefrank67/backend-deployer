#!/usr/bin/env bash

#Install dependencies
echo "Building application"
mvn package  > /dev/null 2>&1


echo "Upload rtifact file : " $INPUT_ARTIFACT_FILE
aws s3 cp --region $INPUT_AWS_DEFAULT_REGION $INPUT_ARTIFACT_FILE s3://$INPUT_AWS_BUCKET_NAME/$PROJECT_NAME/$INPUT_ARTIFACT_FILE

#Build application
echo "Deploy application"
echo "$PRIVATE_KEY" > private_key.pem && chmod 600 private_key.pem
ssh -o StrictHostKeyChecking=no -i private_key.pem $INPUT_USER_NAME@$INPUT_HOST_NAME '
  $INPUT_DEPLOY_COMMAND
'
rm -rf private_key.pem
