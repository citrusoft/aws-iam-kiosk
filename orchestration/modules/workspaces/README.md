<!-- BEGIN_TF_DOCS -->
# TFC Workspaces
Terraform module that provisions the workspaces

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Usage

Usage information can be found in `modules/examples/*`

`cd modules/examples/*`

`terraform init`

`terraform validate`

`terraform plan`

`terraform apply`

Run `terraform destroy` when you don't need these resources.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.env_vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tf_vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace_policy_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_policy_set) | resource |
| [tfe_workspace_variable_set.attach_varset](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_variable_set) | resource |
| [tfe_agent_pool.agent-pool](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/agent_pool) | data source |
| [tfe_policy_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/policy_set) | data source |
| [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/variable_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_apply"></a> [auto\_apply](#input\_auto\_apply) | Whether to automatically apply changes when a Terraform plan is successful. | `bool` | `false` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map of environment or Terraform variables to define in the workspace. | `any` | `{}` | no |
| <a name="input_file_triggers_enabled"></a> [file\_triggers\_enabled](#input\_file\_triggers\_enabled) | Whether to filter runs based on the changed files in a VCS push. If enabled, the working directory and trigger prefixes describe a set of paths which must contain changes for a VCS push to trigger a run. If disabled, any push will trigger a run. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Configuration File Name of the workspace | `string` | n/a | yes |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | Map of `tfe_notification_configurations` to define in the workspace. | `map(object({ configuration = map(string), triggers = list(string) }))` | `{}` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the organization. | `any` | n/a | yes |
| <a name="input_policy_env"></a> [policy\_env](#input\_policy\_env) | Value from the yaml config file to apply environment based policy set. | `string` | n/a | yes |
| <a name="input_queue_all_runs"></a> [queue\_all\_runs](#input\_queue\_all\_runs) | Whether all runs should be queued. When set to false, runs triggered by a VCS change will not be queued until at least one run is manually queued. | `bool` | `true` | no |
| <a name="input_ssh_key_id"></a> [ssh\_key\_id](#input\_ssh\_key\_id) | The ID of an SSH key to assign to the workspace. | `any` | `null` | no |
| <a name="input_tag_names"></a> [tag\_names](#input\_tag\_names) | Tags used to identify the workspace. These can only be lowercase due to a bug that will see change on plan/apply if upper. | `list(string)` | n/a | yes |
| <a name="input_team_access"></a> [team\_access](#input\_team\_access) | Associate teams to permissions on the workspace. | `map(string)` | `{}` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The version of Terraform to use for this workspace. | `string` | `null` | no |
| <a name="input_tf_vars"></a> [tf\_vars](#input\_tf\_vars) | Map of environment or Terraform variables to define in the workspace. | `any` | `{}` | no |
| <a name="input_trigger_prefixes"></a> [trigger\_prefixes](#input\_trigger\_prefixes) | List of paths relative to the repository root which describe all locations to be tracked for changes in the workspace. | `list(any)` | `null` | no |
| <a name="input_varset"></a> [varset](#input\_varset) | Varset Name from yaml file to query using data for varset id | `string` | n/a | yes |
| <a name="input_vcs_repo"></a> [vcs\_repo](#input\_vcs\_repo) | The VCS repository to configure. | `map(string)` | `{}` | no |
| <a name="input_working_directory"></a> [working\_directory](#input\_working\_directory) | A relative path that Terraform will execute within. Defaults to the root of your repository. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | n/a |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | n/a |


<!-- END_TF_DOCS -->
