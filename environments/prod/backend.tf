terraform {
  backend "s3" {
    bucket = "itay-terraform-state-bc22"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}