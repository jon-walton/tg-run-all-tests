# A small repo to test terragrunt processes

We shouldn't use `run-all` - https://github.com/gruntwork-io/terragrunt/issues/720#issuecomment-497888756

Because each module is planned / applied in isolation, plans (and changes to outputs) are not
propagated down to dependent modules until all of the module's dependencies have been applied.

## prep

```bash
cd ./terragrunt/uat
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
```

## Using planfiles

Using planfiles is important to allow reviews / approvals on any changes to infrastructure.
However, it comes with significant drawbacks when using terragrunt due to any expected changes to
outputs not being propagated down to dependent modules.

```bash
terragrunt run-all plan -out planfile.tfplan
# note how the child module is using a mock for the parent module's output
terragrunt run-all apply planfile.tfplan
terragrunt run-all show
# note again how the child module is showing a mock output for "output_from_input_1"
# this will cause failures and generally wrong variable inputs being used during a deployment

# now we run another plan
terragrunt run-all plan -out planfile.tfplan
# note how because the parent module has now been applied, the child module will change it's input
# from a mock to the real value. Atlantis would have already merged the merge request because all plans
# have been applied (albeit with mock data)
terragrunt run-all apply planfile.tfplan
terragrunt run-all show
# yep, now the state is as expected
```

A while later, we make a change to the parent module that should affect the child module...

```bash
# make a change to the parent
sed -i '' -e 's/foo/i changed!/' parent/terragrunt.hcl
terragrunt run-all plan -out planfile.tfplan
# note how the child module inputs were NOT updated.
# this should be expected because the child module is planning on the current state of the parent
terragrunt run-all apply planfile.tfplan
terragrunt run-all plan -out planfile.tfplan
# now the child is updating it's input...
terragrunt run-all apply planfile.tfplan
terragrunt run-all show
# yep, now the state is as expected
```

## Shooting in the dark

we _could_ apply without planning, but then we lose the ability to audit/review/approve changes
before deploying.

```bash
terragrunt run-all apply
terragrunt run-all show
# note how the child module is NOT using any mock values for it's inputs
```

## Using Terraform instead...

```bash
brew install conftest opa
cd ./terraform/uat
```

If we use conftest, we can enforce only approved modules are used as part of a plan. The example policies
validate 2 things

- No `resource` blocks are defined
- Only approved modules are used

```bash
terraform init
terraform plan -out plan.tfplan
terraform show -json plan.tfplan | conftest - test -p ../policies
```

The policies are stored server side and can have unit tests
