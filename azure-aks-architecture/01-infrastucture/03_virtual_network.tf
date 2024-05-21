resource "azurerm_virtual_network" "azure_vnet" {
  address_space       = local.vnet_address_space
  name                = local.vnet_name
  location            = azurerm_resource_group.azure_grp.location
  resource_group_name = azurerm_resource_group.azure_grp.name


  depends_on = [azurerm_resource_group.azure_grp]
}

resource "azurerm_subnet" "azure_subnet" {
  resource_group_name  = azurerm_resource_group.azure_grp.name
  virtual_network_name = azurerm_virtual_network.azure_vnet.name
  for_each             = local.subnets
  name                 = each.key
  address_prefixes     = [each.value]

  depends_on = [azurerm_virtual_network.azure_vnet]
}
