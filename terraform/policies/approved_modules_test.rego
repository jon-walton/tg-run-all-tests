package main

# eh, these will fail. i'm not a rego expert, but it demonstrates that we can have unit tests for policies

empty(value) {
	count(value) == 0
}

no_violations {
	empty(deny)
}

test_no_resources {
    no_violations with input as {"configuration": {"root_module": {"resources": [{"address": "local_File.test"}]}}}
}

test_using_resources {
    deny["Not allowed to use resources"] with input as {"configuration": {"root_module": {"resources": [{"address": "local_File.test"}]}}}
}
