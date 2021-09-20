#!/bin/bash

create_sa() {
    check_az
    check_vars
    # check if rg exists
    group=$(az group exists -n $AZURE_RESOURCE_GROUP)
    if [ "$group" = "false" ]; then
        # resource group does not exist, create it
        echo "No resource group named $AZURE_RESOURCE_GROUP found, creating..."
        az group create -l $AZURE_RESOURCE_GROUP_LOCATION -n $AZURE_RESOURCE_GROUP
    else
        echo "Resource group named $AZURE_RESOURCE_GROUP exists, continuing..."
    fi

    # check if sa exists
    account=$(az storage account list --query "[?name=='$AZURE_STORAGE_ACCOUNT']")
    if [ "$account" = "[]" ]; then
        name_avail=$(az storage account check-name -n $AZURE_STORAGE_ACCOUNT --query "nameAvailable")
        if [ "$name_avail" = "true" ]; then
            echo "No storage account named $AZURE_STORAGE_ACCOUNT found, creating..."
            az storage account create -n $AZURE_STORAGE_ACCOUNT -g $AZURE_RESOURCE_GROUP
        else
            echo "Storage account name $AZURE_STORAGE_ACCOUNT unavailable, please retry with a different value of \$AZURE_STORAGE_ACCOUNT"
            exit 1
        fi
    else
        echo "Storage account named $AZURE_STORAGE_ACCOUNT exists, continuing..."
    fi
    
    # retrieve storage account key
    key=$(az storage account keys list -g $AZURE_RESOURCE_GROUP --account-name $AZURE_STORAGE_ACCOUNT --query "[0].value")

    # check if container exists
    container=$(az storage container exists -n $AZURE_STORAGE_CONTAINER --account-name $AZURE_STORAGE_ACCOUNT --query "exists" --account-key $key)
    if [ "$container" = "false" ]; then
        echo "No storage container named $AZURE_STORAGE_CONTAINER found, creating..."
        az storage container create -n $AZURE_STORAGE_CONTAINER --account-name $AZURE_STORAGE_ACCOUNT --account-key $key
    else
        echo "Storage account container $AZURE_STORAGE_CONTAINER exists, continuing..."
    fi

    # get key
    echo "Add the following line to your profile:"
    echo "export AZURE_STORAGE_ACCESS_KEY=$key"
}

check_vars() {
    # source configure-env.sh > /dev/null 2>&1
    if [ -z $MLFLOW_TRACKING_PASSWORD ]; then
        echo "Could not find required variables in environment. Please run `./configure-env.sh help` for more information"
        exit 1
    fi
}

check_az() {
    az account list-locations > /dev/null 2>&1
    if [ $? -eq 1 ]; then
        echo "User must be logged into Azure CLI - run 'az login' or refer to https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli for more information."
        exit 1
    fi
}


$*