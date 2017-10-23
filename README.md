# terraform-example
> Author: Abdelaziz Khajour
> This e example shows how to use main Terraform features on aws provider


## Dependencies
You need the following tools to run this example:
* terraform
* terragrunt
* git
* aws cli

## Setup

```sh
aws configure
cd
mkdir projects/terraform
git clone https://github.com/khajour/terraform-example.git
cd terraform-example
```

## Run the example
edit the main.tf file if necessary

```sh
vim main.tf  
terraform plan
terraform validate
terraform apply
```

## Remove the created resources
```sh
terraform destroy
```
