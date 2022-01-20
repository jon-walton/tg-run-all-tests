package main
import input

approved_modules = {
  "../../modules/echo"
}

invalid_module_sources[m] {
    m := input.configuration.root_module.module_calls[_].source
    not approved_modules[m]
}

resources[r] {
    r := input.configuration.root_module.resources[_].address
}

deny[msg] {
    count(invalid_module_sources) > 0
    msg := sprintf("Module source is not approved %s", [invalid_module_sources[_]])
}

deny[msg] {
    count(resources) > 0
    msg := sprintf("Using local resources is forbidden. Resource found: %s", [resources[_]])
}
