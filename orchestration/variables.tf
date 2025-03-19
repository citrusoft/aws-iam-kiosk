variable "config_auto_apply" {
  type        = bool
  description = "automatically apply plans?"
}

variable "drift_detection" {
  type        = bool
  description = "Detect and remediate drift?"
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version."
  default     = "1.3.6"
}

variable "github_org" {
  description = "Name of the github organization."
  type        = string
}

variable "github_repo" {
  description = "Name of the github repository."
  type        = string
}

variable "resource_folder" {
  description = "Path to resources relative to repo base folder."
  type        = string
}

variable "resource_path" {
  description = "Path to resources relative to working directory."
  type        = string
}

variable "branch" {
  description = "Branch name."
  type        = string
}

variable "oauth_token_id" { # Specify this with environment variable, TF_VAR_oauth_token_id
  description = "Token ID of the VCS Connection (OAuth Connection Token) to use."
  type        = string
}

variable "tfe_hostname" {
  description = "The Terraform Enterprise hostname to connect to. Defaults to `app.terraform.io`. Can be overridden by setting the `TFE_HOSTNAME` environment variable."
  default     = "app.terraform.io"
  type        = string
}

variable "organization" {
  description = "Name of the organization."
  type        = string
}

variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "root_workspace" {
  description = "Name the root of all the workspaces."
  type        = string
  default     = "orchestration"
}

variable "saml_account_num" {
  type        = string
  description = "AWS-SAML Integration account number, mandatory"
}

variable "tags" {
  description = "These are TFC workspace tags, not AWS tags."
  type        = list(string)
  default     = []
}
