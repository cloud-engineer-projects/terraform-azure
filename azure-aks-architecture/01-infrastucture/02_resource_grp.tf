resource "azurerm_resource_group" "azure_grp" {
  name     = local.resource_grp_name
  location = local.resource_grp_location
}
