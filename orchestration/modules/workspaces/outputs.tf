output "workspace_id" {
  value = resource.tfe_workspace.this.id
}

output "workspace_name" {
  value = resource.tfe_workspace.this.name
}
