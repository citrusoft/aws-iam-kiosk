terraform {
  cloud {
    organization = "citrusoft" # See var.organization

    workspaces {
      name = "orchestration" # See var.root_workspace
    }
  }
}
