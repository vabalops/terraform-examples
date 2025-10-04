# Remote Terraform State (AWS)

This module creates S3 bucket resources to enable storing terraform state on a remote backend

## Initial run

Initial `terraform apply` creates the remote backend itself, therefore contents of **backend.tf** should be commented out. After bucket is created, uncomment this file and update with values based on output, then run `terraform init` to migrate your local state file to remote backend.