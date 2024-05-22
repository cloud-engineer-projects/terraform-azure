resource "azurerm_kubernetes_cluster_node_pool" "app_node_pool" {
  for_each              = local.app_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.app_aks.id
  vm_size               = local.cluster_app_pool_size
  vnet_subnet_id        = azurerm_subnet.azure_subnet[local.aks_subnet_name].id
  node_count            = each.value

  node_labels = {
    "node" = "app"
  }

  depends_on = [azurerm_kubernetes_cluster.app_aks]
}
