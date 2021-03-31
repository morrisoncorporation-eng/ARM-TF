# Deploy Azure VM using Arm Templates and Terraform

## ARM Templates Deployment
 ### In this section, we will use yaml pipeline to deploy a Virtual Machine using ARM Templates. 

* Prerequisites
   - SAS Token for Custom Script file in Azure Storage Account
   - VM Name and Password
   - Service Connection from ADO to Azure Subscription
   - Resource Group Name for Deployment (Can be set in yaml or Arm templates with variables)

## Deployment 
Use the Azure pipeline variables to set all prerequisites for both ARM templates parameters and variables. 

Arm templates parameters can be overridden using the section below in the Azure resourcegroup deployment Task.
```
overrideParameters: '-adminUsername "$(vmuser)" -adminPassword $(vmpassword) -customscript $(blobsas) -vmName "ismorrisvm"'

```


[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-storage-account-create%2Fazuredeploy.json)



# Terraform Deployment

 ### In this section, we will use yaml pipeline to deploy a Virtual Machine using Terraform.

* Prerequisites
   - SAS Token for Custom Script file in Azure Storage Account
   - VM Password
   - Service Connection from ADO to Azure Subscription
   - Storage Account Name and Container for State file
   - Resource Group Name for Storage Account
 
## Deployment 
Use the Azure pipeline variables in to set all prerequisites for both ARM templates parameters and variables. 

Terraform Variables can be parsed using the command options using the Terraform Task in Yaml as below; 
```
commandOptions: -input=false -var "MYSECRET=$(TF_VAR_mysecret)" -var "rgname=$(TF_VAR_prodRG)"
```

**Notice** how "MYSECRET" is in upper cases, all variables stored as "Secret" in Azure pipeline Variables are stored with upper cases and can only be retrieved using the method above. 