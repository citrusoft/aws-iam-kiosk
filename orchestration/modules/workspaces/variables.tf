variable "auto_apply" {
  description = "Whether to automatically apply changes when a Terraform plan is successful."
  default     = false
}
variable "file_triggers_enabled" {
  description = "Whether to filter runs based on the changed files in a VCS push. If enabled, the working directory and trigger patterns describe a set of paths which must contain changes for a VCS push to trigger a run. If disabled, any push will trigger a run."
  default     = true
}
variable "name" {
  description = "Configuration File Name of the workspace"
  type        = string
}
variable "organization" {
  description = "Name of the organization."
  type = string
}
variable "project_id" {
  description = "Id of the project."
  type = string
}

variable "branch" {
  description = "Branch name."
  type        = string
}

variable "identifier" {
  description = "github repo id, format: organization/repository."
  type        = string
}

variable "oauth_token_id" {
  description = "Token ID of the VCS Connection (OAuth Connection Token) to use."
  type        = string
}

variable "queue_all_runs" {
  description = "Whether all runs should be queued. When set to false, runs triggered by a VCS change will not be queued until at least one run is manually queued."
  default     = true
  type        = bool
}
variable "terraform_version" {
  description = "The version of Terraform to use for this workspace."
  default     = null
  type        = string
}
variable "trigger_patterns" {
  description = "List of paths relative to the repository root which describe all locations to be tracked for changes in the workspace."
  default     = null
  type        = list(any)
}
variable "working_directory" {
  description = "A relative path that Terraform will execute within. Defaults to the root of your repository."
  default     = null
}
variable "tag_names" {
  type        = list(string)
  description = "Tags used to identify the workspace. These can only be lowercase due to a bug that will see change on plan/apply if upper."
}
variable "tf_vars" {
  # NOTE: This is of type `any` to allow for a map of various, complex types.
  type        = any
  description = "Map of environment or Terraform variables to define in the workspace."
  default     = {}
}

variable "env_vars" {
  # NOTE: This is of type `any` to allow for a map of various, complex types.
  type        = any
  description = "Map of environment or Terraform variables to define in the workspace."
  default     = {}
}

variable "varset" {
  description = "Varset Name from yaml file to query using data for varset id"
  type        = string
  default     = null
}

variable "var_file" {
  description = "Var file name for env_variables."
  type        = string
  default     = null
}

variable "drift_detection" {
  description = "set to true to detect changes to infra"
}
