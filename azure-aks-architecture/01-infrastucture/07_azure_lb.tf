resource "azurerm_public_ip" "app_ip" {
  name                = local.public_ip_name
  resource_group_name = azurerm_resource_group.azure_grp.name
  location            = azurerm_resource_group.azure_grp.location
  allocation_method   = "Static"

  depends_on = [azurerm_key_vault_access_policy.assign_identity_to_app_node_pool]
}

resource "azurerm_lb" "app_lb" {
  name                = local.lb_name
  location            = azurerm_resource_group.azure_grp.location
  resource_group_name = azurerm_resource_group.azure_grp.name

  frontend_ip_configuration {
    name                 = local.lb_frontend_configuration
    public_ip_address_id = azurerm_public_ip.app_ip.id
  }

  depends_on = [azurerm_public_ip.app_ip]
}
