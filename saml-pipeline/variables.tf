/*
 * #  IAM kiosk
 * Terraform root-module which creates SAF2.0 compliant IAM resources:
 *  federated-roles = SAML Role + Partner Role + Policies
 *  service-accounts = User + Policies + Access Key
*/
#
# Filename    : -iam-kiosk
# Date        : Mar 16, 2023
# Author      : Tommy Hunt (thunt@citrusoft.org)
# Description : iam users, roles creation with policies from yaml files
#

variable "saml_account_num" {
  type        = string
  description = "AWS-SAML Integration account number, mandatory"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_role" {
  description = "AWS role to assume"
  type        = string
  default     = "CloudAdmin"
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

variable "AppID" {
  description = "Identify the application this asset belongs to by its AMPS APP ID.Format = APP-####"
  type        = number
}

variable "Environment" {
  type        = string
  description = "The environment in which the resource is provisioned and used, such as Dev, Test, QA, Prod."
}

variable "DataClassification" {
  type        = string
  description = "Classification of data - can be made conditionally required based on Compliance.One of the following: Public, Internal, Confidential, Restricted, Privileged (only one)"
}

variable "Compliance" {
  type        = string
  description = "Compliance	Identify assets with compliance requirements (SOX, HIPAA, etc.) Note: not adding NERC workloads to cloud"
}

variable "CRIS" {
  type        = string
  description = "Cyber Risk Impact Score High, Medium, Low (only one)"
}

variable "Notify" {
  type        = string
  description = "Who to notify for system failure or maintenance. Should be a group or list of email addresses."
}

variable "Owner" {
  type        = string
  description = "List three owners of the system, as defined by AMPS Director, Client Owner and IT Leadeg LANID1_LANID2_LANID3"
}

variable "optional_tags" {
  description = "Optional_tags"
  type        = map(string)
  default     = {}
}
