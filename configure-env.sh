#!/bin/bash

### Set these variables to be written to .bashrc/stdout

# MYSQL
MYSQL_USER=""
MYSQL_PASSWORD=""

# MLFLOW
MLFLOW_TRACKING_USERNAME=""
MLFLOW_TRACKING_HOSTNAME=""

# AZURE
AZURE_STORAGE_ACCESS_KEY=""
AZURE_STORAGE_ACCOUNT=""
AZURE_STORAGE_CONTAINER=""
AZURE_RESOURCE_GROUP=""
AZURE_RESOURCE_GROUP_LOCATION=""



# DO NOT MODIFY BELOW
#==================================================================================

list() {
    cat <<EOF
$(vars)
EOF
}

write() {
    write_file ~/.bashrc
}

write_file() {
    cat <<EOF >> $1
$(vars)
EOF
}

vars() {
    echo """
export MYSQL_USER=\"$MYSQL_USER\"
export MYSQL_PASSWORD=\"$MYSQL_PASSWORD\"
export MLFLOW_TRACKING_USERNAME=\"$MLFLOW_TRACKING_USERNAME\"
export MLFLOW_TRACKING_PASSWORD=$(printf "\"%q\"" $MLFLOW_TRACKING_PASSWORD)
export MLFLOW_TRACKING_PASSWORD_HASH=$(printf "\"%q\"" $MLFLOW_TRACKING_PASSWORD_HASH)
export MLFLOW_TRACKING_HOSTNAME=\"$MLFLOW_TRACKING_HOSTNAME\"
export MLFLOW_TRACKING_URI=\"https://$MLFLOW_TRACKING_HOSTNAME\"
export AZURE_STORAGE_ACCESS_KEY=\"$AZURE_STORAGE_ACCESS_KEY\"
export AZURE_STORAGE_ACCOUNT=\"$AZURE_STORAGE_ACCOUNT\"
export AZURE_STORAGE_CONTAINER=\"$AZURE_STORAGE_CONTAINER\"
export AZURE_RESOURCE_GROUP=\"$AZURE_RESOURCE_GROUP\"
export AZURE_RESOURCE_GROUP_LOCATION=\"$AZURE_RESOURCE_GROUP_LOCATION\"
"""
}

help() {
    echo "------------------------------------------------------------------"
    echo "-                       Available commands                       -"
    echo "------------------------------------------------------------------"
    echo "   > list        [password]         - Write variables to stdout"
    echo "   > write       [password]         - Write variables to .bashrc"
    echo "   > write_file  [password]  [file] - Write variables to [file]"
    echo "   > help              - Display this help"
    echo "------------------------------------------------------------------"
}

if [ -z "$1" ]; then
    help
    exit 1
else
    if [ -n "$2" ]; then
        MLFLOW_TRACKING_PASSWORD="$2"
        MLFLOW_TRACKING_PASSWORD_HASH=$(htpasswd -nb "$MLFLOW_TRACKING_USERNAME" "$MLFLOW_TRACKING_PASSWORD" | cut -d ':' -f2)
    else
        if [ "$1" == "list" ] || [ "$1" == "write" ]; then
            echo "No password provided"
            help
            exit 1
        fi
    fi
fi



$*