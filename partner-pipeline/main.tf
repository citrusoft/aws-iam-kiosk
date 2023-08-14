/*
 * #  IAM kiosk
 * Terraform root-module which creates SAF2.0 compliant IAM resources:
 *  federated-roles = Partner Role + Policies
 *  service-accounts = User + Policies + Access Key
*/
#
# Filename    : -iam-kiosk
# Date        : Mar 16, 2023
# Author      : Tommy Hunt (thunt@citrusoft.org)
# Description : For partner accounts, iam users and roles creation with policies from yaml files
#
terraform {
  # required_version = ">= 1.4.0" # terraform://version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"
  default_tags {
    tags = {
      Environment = "Test"
      Name        = "Provider Tag"
    }
  }
}

provider "aws" {
  alias  = "partner"
  region = "${local.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.target_account_id}:role/${var.aws_role}"
  }
}

provider "aws" {
  alias  = "saml"
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.saml_account_num}:role/${var.aws_role}"
  }
}

data "aws_caller_identity" "saml" {
  provider = aws.saml
}

data "aws_caller_identity" "partner" {
  provider = aws.partner
}

locals {
  AppID              = var.AppID
  Environment        = var.Environment
  DataClassification = var.DataClassification
  CRIS               = var.CRIS
  Notify             = var.Notify
  Owner              = var.Owner
  Compliance         = var.Compliance
  optional_tags      = var.optional_tags
  aws_region         = var.aws_region
  saml_account_num   = var.saml_account_num
  target_account_id  = var.target_account_id

  ### Read, Parse & Encode Role specification
  role_specs = [ for filename in fileset(path.module, "../resources/${var.target_account_id}/federated-roles/*.yaml"): {
    key              = filename
    role_yaml_map    = yamldecode(file(filename))
  }]
  role_specifications = { for rspec in local.role_specs : rspec.key => rspec.role_yaml_map}

  ###### Read, Parse & Encode User specification
  user_specs = [ for filename in fileset(path.module, "../resources/${var.target_account_id}/service-accounts/*.yaml"): {
    key              = filename
    user_yaml_map    = yamldecode(file(filename))
  }]
  user_specifications = { for uspec in local.user_specs : uspec.key => uspec.user_yaml_map}
  # Save any Default tags from the workspace/commandline.
  tags = {
    AppID              = var.AppID
    Environment        = var.Environment
    DataClassification = var.DataClassification
    CRIS               = var.CRIS
    Notify             = var.Notify
    Owner              = var.Owner
    Compliance         = var.Compliance
  }
}

#################################
# FEDERATED ROLES Specification
# PARTNER Role Creation
#################################
module "federated_roles" {
  source = "./modules/federated-roles"
  providers = {
    aws.partner = aws.partner
  }

  for_each          = local.role_specifications
  account_num       = regex("[0-9]{12}", each.key)  # parse AWS acct #
  saml_account_num  = var.saml_account_num
  name              = each.value["Name"]
  managed_policies  = lookup(each.value, "ManagedPolicyArns", [])
  inline_policies   = lookup(each.value, "Statement", null) != null ? (
                    [ jsonencode({ "Version" : "2012-10-17", "Statement" : each.value["Statement"] })]
                    ) : ( [] )
  tags              = merge(merge(local.tags, local.optional_tags), lookup(each.value, "Tags", {})) # Precedence = yaml, optional, default
}

###################################
# SERVICE ACCOUNT Specification
# Create managed policy and user
###################################
module "service_accounts" {
  source = "./modules/service-accounts"
  providers = {
    aws.partner = aws.partner
  }

  for_each          = local.user_specifications
  account_num       = local.target_account_id
  name              = each.value["Name"]
  managed_policies  = lookup(each.value, "ManagedPolicyArns", [])
  inline_policies   = lookup(each.value, "Statement", null) != null ? (
                    [ jsonencode({ "Version" : "2012-10-17", "Statement" : each.value["Statement"] })]
                    ) : ( [] )
  tags              = merge(merge(local.tags, local.optional_tags), lookup(each.value, "Tags", {})) # Precedence = yaml, optional, default
}
