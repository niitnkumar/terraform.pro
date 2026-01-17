locals {
  name_prefix = var.name

  common_tags = {
    environment = var.environment
    owner      = var.owner
    project    = var.project
  }
}
