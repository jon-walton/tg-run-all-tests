# Not sure what to call this file :D

module "parent" {
  source = "../../modules/echo"

  input_1 = "parent - foo"
}

module "child" {
  source = "../../modules/echo"

  input_1 = module.parent.output_from_input_1
  input_2 = "child - foo"
}

resource "local_file" "child_output_from_input_1" {
  filename = "${path.module}/child_output_from_input_1"
  content = module.child.output_from_input_1
}
