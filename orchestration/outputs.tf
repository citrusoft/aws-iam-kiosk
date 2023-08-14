output "workspace" {
  value       = local.workspaces
  description = "results from the module to create workspaces"
}

output "resource_files" {
  value       = local.resource_files
  description = "list of input files"
}
output "accounts" {
  value       = local.account_set
  description = "set of accounts"
}
