# Project DynamoDB with Terraform

This project contains the infrastructure as code to create DynamoDB tables in AWS using Terraform.

## Prerequisites

- AWS CLI configured
- Terraform installed
- AWS credentials configured

## How to use

1. Clone the repository
2. Enter the terraform directory:
   ```bash
   cd terraform
   ```
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Check the execution plan:
   ```bash
   terraform plan
   ```
5. Apply the changes:
   ```bash
   terraform apply
   ```

## Tables structure

### Users table
- Primary key: cpf (String)
