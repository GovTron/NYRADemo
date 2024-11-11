#!/bin/bash
set -x
# Source: https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli
RESOURCE_GROUP_NAME=terraform2
STORAGE_ACCOUNT_NAME=nyragovtrontf2
CONTAINER_NAME=tfstate2

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus
# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
