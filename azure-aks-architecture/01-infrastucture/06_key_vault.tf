resource "azurerm_key_vault" "app_keyvault" {
  name                        = local.keyvault_name
  location                    = azurerm_resource_group.azure_grp.location
  resource_group_name         = azurerm_resource_group.azure_grp.name
  enabled_for_disk_encryption = local.keyvault_enabled_for_disk_encryption
  tenant_id                   = local.tenant_id
  soft_delete_retention_days  = local.keyvault_soft_deletion_retention_days
  purge_protection_enabled    = local.keyvault_purge_protection_enabled

  sku_name = local.keyvault_sku_name

  depends_on = [azurerm_kubernetes_cluster_node_pool.app_node_pool]
}

resource "null_resource" "assign_identity" {
  provisioner "local-exec" {
    command = <<EOT
      powershell -File ./scripts/assign_identity.ps1 -RESOURCE_GROUP "MC_${azurerm_resource_group.azure_grp.name}_${local.cluster_name}_southindia" -CLUSTER_NAME "${local.cluster_name}" -NODE_POOL_NAME "${local.cluster_app_node_pool_names[0]}" > ./scripts/identity_output.json
    EOT
  }

  depends_on = [azurerm_kubernetes_cluster_node_pool.app_node_pool]
}

data "local_file" "identity_output" {
  filename   = "./scripts/identity_output.json"
  depends_on = [null_resource.assign_identity]
}

locals {
  identity_output = jsondecode(data.local_file.identity_output.content)
}

resource "azurerm_key_vault_access_policy" "assign_identity_to_app_node_pool" {
  key_vault_id = azurerm_key_vault.app_keyvault.id
  tenant_id    = local.tenant_id
  object_id    = local.identity_output.userAssignedIdentities["/subscriptions/${local.subscription_id}/resourceGroups/MC_${azurerm_resource_group.azure_grp.name}_${local.cluster_name}_southindia/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.cluster_name}-${local.cluster_agent_pool_name}"].principalId

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "Set",
  ]
}

