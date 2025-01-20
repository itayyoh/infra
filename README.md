backend Config
environments/dev/backend.tf & environments/prod/backend.tf

uses S3 bucket for state storage
different state files for development and production

modules/networking
main.tf - Creates the core network infrastructure
variables.tf - Defines input variables
outputs.tf - Specifies which values to expose

creates
VPC
Public and private subnets
Single NAT Gateway
Internet Gateway
Route tables


security
main.tf - Creates IAM roles and security groups
variables.tf - Defines required inputs
outputs.tf - Exposes created resources


