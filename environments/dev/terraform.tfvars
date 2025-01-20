# environments/dev/terraform.tfvars
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
kubernetes_version = "1.27"
gitops_repo_url  = "https://github.com/itayyoh/gitops-shorturl.git"
gitops_repo_branch = "feature"