# Project RDS and PostgreSQL with Terraform

This project contains the infrastructure as code to create RDS and PostgreSQL in AWS using Terraform.

## Prerequisites

- AWS CLI configured
- Terraform installed
- AWS credentials configured

## How to use

1. Clone the repository
2. Initialize Terraform:
```bash
terraform init
```
3. Check the execution plan:
```bash
terraform plan
```
4. Apply the changes:
```bash
terraform apply
```

The database is the same as previous project, tech challenge 2, but this time it is using RDS and PostgreSQL. The output of deployment is the endpoint to acces the database and will be used on repo [fast-food-kubernetes](https://github.com/henrique-hartwig/fast-food-kubernetes) to generate the kubernetes cloud image.
