/*
 * #  IAM kiosk
 * Terraform submodule which creates SAF2.0 compliant roles and policies.
*/
#
# Filename    : -iam-kiosk/modules/saml-roles
# Date        : June 15, 2023
# Author      : Tommy Hunt (thunt@citrusoft.org)
# Description : iam SAML-roles creation with role-name from yaml files.
#

terraform {
  # required_version = ">= 1.4" # terraform://version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [ aws.saml ]
    }
  }
}

data "aws_caller_identity" "saml" {
  provider = aws.saml
}

# data "aws_caller_identity" "partner" {
#   provider = aws.partner
# }

############
# SAML-Role
############
resource "aws_iam_role" "saml_integration_role" {
  provider                   = aws.saml

  # name                       = "AWS-A${trimprefix(var.tags["AppID"], "APP-")}-${var.tags["Environment"]}-${var.name}"
  name                       = "AWS-${var.name}"
  path                       = var.path
  description                = var.description

  assume_role_policy         = data.aws_iam_policy_document.trust_saml_policy.json
  managed_policy_arns        = var.managed_policies

  force_detach_policies      = var.force_detach_policies
  max_session_duration       = var.max_session_duration
  tags     = merge(merge(var.tags, var.optional_tags), {
                workspace = "ccoe-iam-${var.saml_account_num}"
              })
}

#########################################
# Trust PingFederate to Assume SAML-Role
#########################################
data "aws_iam_policy_document" "trust_saml_policy" {
  provider = aws.saml

  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.saml_account_num}:saml-provider/${var.saml_provider}"]
      # identifiers = ["arn:aws:iam::${data.aws_caller_identity.saml.account_id}:saml-provider/${var.saml_provider}"]
    }
    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = [
        "https://signin.aws.amazon.com/saml"
      ]
    }
    actions = [
      "sts:AssumeRoleWithSAML"
    ]
  }
}

#########################################
# Allow SAML-Role to Assume Partner-Role
#########################################
resource "aws_iam_role_policy" "assume_partner_policy" {
  provider = aws.saml

  name   = "assume-${var.name}-policy"
  role   = aws_iam_role.saml_integration_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${var.account_num}:role/${var.name}"
    }]
  })
}
