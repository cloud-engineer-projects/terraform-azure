# resource "azurerm_key_vault" "app_keyvault" {
#   name                        = local.keyvault_name
#   location                    = azurerm_resource_group.azure_grp.location
#   resource_group_name         = azurerm_resource_group.azure_grp.name
#   enabled_for_disk_encryption = local.keyvault_enabled_for_disk_encryption
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = local.keyvault_soft_deletion_retention_days
#   purge_protection_enabled    = local.keyvault_purge_protection_enabled

#   sku_name = local.keyvault_sku_name

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     #given all permission to current tenant user
#     key_permissions = [
#       "Backup",
#       "Create",
#       "Delete",
#       "DeleteIssuers",
#       "Get",
#       "GetIssuers",
#       "Import",
#       "List",
#       "ListIssuers",
#       "ManageContacts",
#       "ManageIssuers",
#       "Purge",
#       "Recover",
#       "Restore",
#       "Sign",
#       "UnwrapKey",
#       "Update",
#       "Verify",
#       "WrapKey",
#     ]

#     secret_permissions = [
#       "Backup",
#       "Delete",
#       "Get",
#       "List",
#       "Purge",
#       "Recover",
#       "Restore",
#       "Set",
#     ]

#     certificate_permissions = [
#       "Create",
#       "Delete",
#       "DeleteIssuers",
#       "Get",
#       "GetIssuers",
#       "Import",
#       "List",
#       "ListIssuers",
#       "ManageContacts",
#       "ManageIssuers",
#       "Purge",
#       "Recover",
#       "SetIssuers",
#       "Update",
#     ]

#     storage_permissions = [
#       "Backup",
#       "Delete",
#       "DeleteSas",
#       "Get",
#       "GetSas",
#       "List",
#       "ListSas",
#       "Purge",
#       "Recover",
#       "RegenerateKey",
#       "Restore",
#       "Set",
#       "SetSas",
#       "Update",
#     ]
#   }

#   depends_on = [azurerm_kubernetes_cluster_node_pool.app_node_pool]
# }
