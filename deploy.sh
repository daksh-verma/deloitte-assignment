#!/bin/bash

while getopts r:p:e: opt
do
   case "${opt}" in
      r ) region="$OPTARG" ;;
      p ) profile="$OPTARG" ;;
      e ) env="$OPTARG" ;;
   esac
done

env="${env:-test}"
cd infrastructure

echo "Setting up terraform dependencies"
terraform init

echo "Creating Deployment plan"
terraform plan

echo "Deploying resources on AWS"
terraform apply -auto-approve