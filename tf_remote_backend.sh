#!/usr/bin/env bash

# Catch when an error occurs

handle_error() {
    echo "An error occurred on line $1"
} 
trap 'handle_error $LINENO' ERR

# Validate if required arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <aws_region> <bucketName> <dynamoDB_table>"
    exit 1
fi

# Assign command-line arguments to variables
aws_region="$1"
bucketName="$2"
dynamoDB_table="$3"


# Create S3 Bucket
aws s3 mb s3://${bucketName} --region ${aws_region}

# Create the dynamoDB table
aws dynamodb create-table \
    --table-name ${dynamoDB_table} \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --table-class STANDARD
