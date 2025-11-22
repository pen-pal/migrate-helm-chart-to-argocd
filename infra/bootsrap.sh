#!/bin/bash

BUCKET_NAME=${1:-terraform-state}

aws cloudformation create-stack  --stack-name Terraform-State-Resources --enable-termination-protection --template-body file://terraform-bootstrap.cfn --parameters ParameterKey=TerraformStateBucketPrefix,ParameterValue=$BUCKET_NAME ParameterKey=TerraformStateLockTableName,ParameterValue=terraform-state-locks
