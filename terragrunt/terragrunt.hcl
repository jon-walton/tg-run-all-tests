locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

remote_state {
  backend = "local"
  config  = {}
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
