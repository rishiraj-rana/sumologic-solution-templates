# ********************** App ********************** #
locals {
  memcached_app_id = "d3cdd540-dde5-4eec-bb62-f363a79885e5"
  memcached_app_name = "Memcached"
  memcached_app_description = "This folder is created by Terraform.DO NOT DELETE."
}
resource "null_resource" "install_memcached_app" {
  count      = contains(local.database_engines_values, "memcached") ? 1 : 0
  triggers = {
    api_endpoint      = local.sumologic_api_endpoint
    organization      = var.sumologic_organization_id
    solution_version = local.solution_version
  }
  depends_on = [
    sumologic_folder.root_apps_folder
  ]
  provisioner "local-exec" {
    command = <<EOT
      curl -s --request POST '${local.sumologic_api_endpoint}/v1/apps/${local.memcached_app_id}/install' \
            --header 'Accept: application/json' \
            --header 'Content-Type: application/json' \
            -u ${var.sumologic_access_id}:${var.sumologic_access_key} \
          --data-raw '{ "name": "${local.memcached_app_name}", "description": "${local.memcached_app_description}", "destinationFolderId": "${sumologic_folder.root_apps_folder.id}"}}'
    EOT
  }
}
