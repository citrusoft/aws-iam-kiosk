/*
 * # TFC Workspaces
 * Terraform module that provisions the workspaces
*/
#
#  Filename    : modules/workspaces/main.tf
#  Date        : 08 Feb 2022
#  Author      : Tommy Hunt (thunt@citrusoft.org)
#  Description : creates the workspace resources in TFC
#
locals {
  tag_names = var.tag_names
}

# Create the workspace
resource "tfe_workspace" "this" {
  name                  = "ccoe-iam-${var.name}"
  organization          = var.organization
  project_id            = var.project_id
  auto_apply            = var.auto_apply
  file_triggers_enabled = var.file_triggers_enabled
  queue_all_runs        = var.queue_all_runs
  terraform_version     = var.terraform_version
  trigger_patterns      = var.trigger_patterns
  working_directory     = var.working_directory
  assessments_enabled   = var.drift_detection
  tag_names             = [for tag in var.tag_names : lower(tag)]
  vcs_repo {
    branch              = var.branch
    identifier          = var.identifier
    # ingress_submodules = var.ingress_submodules
    oauth_token_id      = var.oauth_token_id
  }
}

# Add the workspace id as environment variable
resource "tfe_variable" "workspace_id" {
  workspace_id = tfe_workspace.this.id
  category     = "env"
  key          = "TF_VAR_workspace_id"
  value        = tfe_workspace.this.id
}

# Add the workspace name as environment variable
resource "tfe_variable" "workspace_name" {
  workspace_id = tfe_workspace.this.id
  category     = "env"
  key          = "TF_VAR_workspace_name"
  value        = tfe_workspace.this.name
}

# Get the varset_id. Varset must already exist.
data "tfe_variable_set" "varset" {
  name         = var.varset
  organization = var.organization
}

resource "tfe_workspace_variable_set" "associate" {
  workspace_id    = tfe_workspace.this.id
  variable_set_id = data.tfe_variable_set.varset.id
}

# Attach varset to workspace
# resource "tfe_workspace_variable_set" "attach_varset" {
#   variable_set_id = data.tfe_variable_set.this.id
#   workspace_id    = tfe_workspace.this.id
# }

# Attach policy set to workspace
# data "tfe_policy_set" "this" {
#   name         = "${var.policy_env}-policy-set"
#   organization = var.organization
# }
# resource "tfe_workspace_policy_set" "this" {
#   policy_set_id = data.tfe_policy_set.this.id
#   workspace_id  = tfe_workspace.this.id
# }

## This is defective at the moment. Cannot add runtask to workspace from tfc only Prisma.
# Use Python to attach existing runtask to workspaces
# resource "null_resource" "add-runtask" {
#   provisioner "local-exec" {
#     command = "python3 ${path.module}/add_runtask.py -w ${tfe_workspace.this.id} -r ${local.runtask_id} -t ${var.tfe_token}"
#   }
# }
