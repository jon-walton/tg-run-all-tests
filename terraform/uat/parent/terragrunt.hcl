locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${find_in_parent_folders()}/../../modules//echo"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  input_1 = "parent - foo"
}
