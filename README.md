# mlflow-docker-azure

## Install Dependencies

Requires:

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* htpasswd
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (optional: for creating storage account)

Install docker and docker-compose through the links above.

__htpasswd__ can be installed by:
```bash
sudo apt install apache2-utils
```

## Configure

Populate the variables at the start of the [configure-env.sh](configure-env.sh#L3-L18) file:

```bash
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
```

Run script appropriately to output to environment. Use the following to display usage:

```bash
./configure-env.sh help
```

Source environment file as appropriate for shell:

```bash
source ~/.bashrc
```

## Optional: Create Azure Storage Account

If a storage account has not yet been created, the [create-azure-sa.sh](create-azure-sa.sh) file can create the resource group, storage account, and storage container through the environment variables provided through [configure-env.sh](configure-env.sh).

The following environment variables must be set for storage account creation:

```bash
AZURE_STORAGE_ACCOUNT=""
AZURE_STORAGE_CONTAINER=""
AZURE_RESOURCE_GROUP=""
AZURE_RESOURCE_GROUP_LOCATION=""
```

Run the following command:

```bash
./create-azure-sa.sh create_sa
```

## Deploy

Start Mlflow and relevant images:

```bash
docker-compose up --build
```


## Access

The value of `MLFLOW_TRACKING_URI` is valid to access the Mlflow dashboard - simply add https:// to the provided value of `MLFLOW_TRACKING_HOSTNAME`.