/*
 * Terraform submodule creating NIST compliant roles and policies.
*/
#
# Filename    : modules/federated-roles/variables.tf
# Date        : Mar 16, 2023
# Author      : Tommy Hunt (thunt@citrusoft.org)
# Description : iam roles creation with policies from yaml files.
#

variable "account_num" {
  type        = string
  description = "Target AWS account number, mandatory"
  default     = null
}

variable "saml_account_num" {
  type        = string
  description = "AWS account number of SAML auth, mandatory"
  default     = 739846873405
}

variable "saml_provider" {
  description = "Internet Domain name of SAML provider."
  type        = string
  default     = "itiamping.cloud.citrusoft.org"
}

variable "name" {
  description = "Unique name for the role"
  type        = string
  default     = null
}

variable "path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "description" {
  description = "IAM Role description"
  type        = string
  default     = ""
}

variable "inline_policies" {
  description = "A string of json."
  type        = list(string)
  default     = []
}

variable "managed_policies" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "tags" {
  description = "citrusoft's standard AWS tags."
  type        = map(string)
  default     = {}
}

variable "optional_tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}
