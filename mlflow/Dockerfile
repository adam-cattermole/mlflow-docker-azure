FROM python:3.9-bullseye

RUN apt-get update \
    && apt-get install -y wait-for-it \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir mlflow \
    azure-storage-blob \
    mysqlclient