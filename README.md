[![Python application test with Github Actions](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/actions/workflows/pythonapp.yml/badge.svg)](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/actions/workflows/pythonapp.yml)

# Overview of udacity-azure-project2

This project has been created during the [Azure DevOps Nanodegree on Udacity](https://www.udacity.com/course/cloud-devops-using-microsoft-azure-nanodegree--nd082).

After planning the different steps regarding the deployment of a Python Flask Machine Learning app, we will manage to add GitHub Actions and Azure Pipeline to it to have a fully working CI/CD environment.

## Project Plan

The planning tool I used are Trello, an Atlassian Todo list, and a Google Spreadsheets.

* [Trello dashboard](https://trello.com/b/N4n2WxWE/udacity-azure-devops-project-2)
* [Google Spreadsheets](https://docs.google.com/spreadsheets/d/1c9QQ_uZhxDJftm1akvgTQ2NzjPdrvcYQ4beOr9RbZg0/edit?usp=sharing)

Azure Cloud Shell

![Azure Cloud Shell](https://video.udacity-data.com/topher/2020/August/5f344440_azure-cloud-shell/azure-cloud-shell.png)

Azure CI

![Azure CI](https://video.udacity-data.com/topher/2020/August/5f34465d_ci-diagram/ci-diagram.png)

Azure CD

![Azure CD](https://video.udacity-data.com/topher/2020/August/5f3447ab_cd-diagram/cd-diagram.png)

Architecture Diagram

![Diagram](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/12-architecture-diagram.png)

# Instructions

## Set up Azure Cloud Shell

### Create Storage Account for Azure Cloud Shell on "Udacity On Demand Lab"

Login to Azure CLI using Service Principle provided by Udacity On Demand Lab.
```
az login --service-principal -u {Application Id} -p {Secret Key} --tenant {Tenant Id (Directory Id)}
```
Using Azure CLI to create Storage Account and Storage File Share.
```
az storage account create --name {Storage Account Name} --resource-group {Resource Group} --location {Region} --sku Standard_RAGRS --kind StorageV2

az storage share create --account-name {Storage Account Name} --name {Storage Account File Share}
```

### Create SSH keys

Open the Azure Cloud Shell or Azure CLI and type:

```
az sshkey create --name {SSH Key Name} --resource-group {Resource Group} --location {Region}
```

The Shell or CLI will return a JSON contains the key that needs to be copy and paste into GitHub.
(GitHub > Settings > SSH and GPG keys > Paste > Add the key).

Then you can clone the repository from the Azure Shell without typing your password.

```
git clone https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project.git
```

![Azure project cloned](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/1-azure-cloud-shell-clone-git.png)

### Create a virtual environment

```
python3 -m venv ~/.Agile-Development-with-Azure-Project
source ~/.Agile-Development-with-Azure-Project/bin/activate
```

### Install and run

```
make all
az webapp up -n {Web App Name} --resource-group {Resource Group} --location {Region} --sku B1
```

Your `make all` output should look like this:

![make all](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/2-make-all.png)


Modify the file `make_predict_azure_app.sh` line `-X POST https://{Web App Name}.azurewebsites.net:$PORT/predict`.

If you go to https://{Web App Name}.azurewebsites.net, you should be able to see the following:

![Web App running](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/4-web-app-running.png)

## Configure GitHub Actions

### Create the workflow

GitHub > Actions > set up a workflow yourself

Copy the following the replace the default template:

```
name: Python application test with Github Actions

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Python 3.11.2
      uses: actions/setup-python@v1
      with:
        python-version: 3.11.2
    - name: Install dependencies
      run: |
        make install
    - name: Lint with pylint
      run: |
        make lint
    - name: Test with pytest
      run: |
        make test
```

After commiting, your build should be green. In details, it should look like this:

![GitHub Actions passed](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/3-github-actions-pass.png)

## Configure Azure Pipeline

Best way is to follow the official [Microsot documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops).

![Azure Pipeline](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/5-azure-pipelines-pass.png)

## Checking the application

The application is contacted from the `make_predict_azure_app.sh` file that return the prediction.

![Prediction](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/9-prediction-result.png)

### Access the logs

Use the following command to display the logs of the server:

```
az webapp log tail -g {Resource Group} -n {Web App Name}
```

![Logs](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/6-web-app-logs.png)

### Locust

Install locust with pip and run it:

```
pip install locust
locust
```

Go on http://0.0.0.0:8089/ and enter the URL of the App Service.

![Locust Main](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/7-locust.png)

After running:

![Locust Running](https://github.com/bluerosecloud52/Agile-Development-with-Azure-Project/raw/main/screenshots/8-locus-success.png)

## Enhancements

We should consider deploying with tools such as Docker or Kubernetes.
We should also consider having different environments related to different GitHub branches (staging and production) with Terraform and Packer templates to have a similare infrastructure between those environments. There could be a pipe between staging and production: if the code is correctly tested on staging, it can be deployed in production.

## Youtube
* [Video](https://www.youtube.com/watch?v=BiZLDtdkv8Y)