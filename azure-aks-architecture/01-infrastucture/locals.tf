locals {
  #resource_grp
  resource_grp_name     = "app-grp"
  resource_grp_location = "South India"
  tenant_id             = "6e804f24-0209-4dcd-ac89-97525eddbd30"
  subscription_id       = "d7317d85-a58f-4e68-9b4e-b53b855a72fa"

  #virtual_network
  vnet_name             = "app-vnet"
  vnet_address_space    = ["10.0.0.0/16"]
  subnet_names          = ["aks-subnet", "app-subnet1", "app-subnet2"]
  subnet_address_spaces = ["10.0.0.0/21", "10.0.8.0/24", "10.0.9.0/24"]
  aks_subnet_name       = "aks-subnet"

  subnets = { for idx, name in local.subnet_names :
    name => local.subnet_address_spaces[idx]
  }

  #cluster
  cluster_name                   = "app-aks"
  cluster_dns_prefix             = "appaks"
  cluster_automatic_upgrade_type = "stable"
  cluster_network_profile        = "azure"
  cluster_network_policy         = "azure"
  cluster_load_balancer_sku      = "Standard"
  cluster_dns_service_ip         = "10.0.10.10"
  cluster_service_cidr           = "10.0.10.0/24"
  #cluster agent pool config
  cluster_agent_pool_size  = "Standard_DS2_v2"
  cluster_agent_node_count = 1
  cluster_agent_pool_name  = "agentpool"
  #cluster app pool config
  cluster_app_pool_size       = "Standard_DS2_v2"
  cluster_app_node_pool_names = ["apppool"]
  cluster_app_node_count      = [1]

  #app-keyvault
  keyvault_name                         = "app-keyvault-t21as"
  keyvault_sku_name                     = "standard"
  keyvault_purge_protection_enabled     = false
  keyvault_soft_deletion_retention_days = 7
  keyvault_enabled_for_disk_encryption  = true

  app_pools = { for idx, name in local.cluster_app_node_pool_names :
    name => local.cluster_app_node_count[idx]
  }

  #lb
  public_ip_name            = "app-public-ip"
  lb_name                   = "app-lb"
  lb_frontend_configuration = "FrontEndIP"
  #cluster_availability_zone = [""] no zone is available for south india
}
