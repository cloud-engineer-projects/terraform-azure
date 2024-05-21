resource "azurerm_kubernetes_cluster" "app_aks" {
  name                                = local.cluster_name
  location                            = azurerm_resource_group.azure_grp.location
  resource_group_name                 = azurerm_resource_group.azure_grp.name
  automatic_channel_upgrade           = local.cluster_automatic_upgrade_type
  dns_prefix                          = local.cluster_dns_prefix
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = true

  #Default local authorization is used


  default_node_pool {
    name           = local.cluster_agent_pool_name
    node_count     = local.cluster_agent_node_count
    vm_size        = local.cluster_agent_pool_size
    vnet_subnet_id = azurerm_subnet.azure_subnet[local.aks_subnet_name].id
  }

  network_profile {
    network_plugin = local.cluster_network_profile
    dns_service_ip = local.cluster_dns_service_ip
    service_cidr   = local.cluster_service_cidr
    network_policy = local.cluster_network_policy
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_virtual_network.azure_vnet, azurerm_subnet.azure_subnet]

}
