#!/bin/bash

REGION=$1
PROFILE=$2
BUCKET_NAME=${3:-terraform-state}

aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name Terraform-State-Resources --enable-termination-protection --template-body file://terraform-bootstrap.cfn --parameters ParameterKey=TerraformStateBucketPrefix,ParameterValue=$BUCKET_NAME ParameterKey=TerraformStateLockTableName,ParameterValue=terraform-state-locks
