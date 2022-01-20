locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

terraform {
  source = "${find_in_parent_folders()}/../../modules//echo"
}

include {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path = "../parent"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show"]
  mock_outputs = {
    output_from_input_1 = "MOCK - parent - output_from_input_1"
  }
}

inputs = {
  input_1 = dependency.parent.outputs.output_from_input_1
  input_2 = "child - foo"
}
