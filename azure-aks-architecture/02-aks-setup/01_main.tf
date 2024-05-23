terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
  }
}

data "terraform_remote_state" "aks_cluster" {
  backend = "local"
  config = {
    path = "../01-infrastucture/terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.aks_cluster.outputs.cluster_kube_config[0].host
  username               = data.terraform_remote_state.aks_cluster.outputs.cluster_kube_config[0].username
  password               = data.terraform_remote_state.aks_cluster.outputs.cluster_kube_config[0].password
  client_certificate     = base64decode(data.terraform_remote_state.aks_cluster.outputs.cluster_kube_config[0].client_certificate)
  client_key             = base64decode(data.terraform_remote_state.aks_cluster.outputs.cluster_kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks_cluster.outputs.cluster_kube_config[0].cluster_ca_certificate)
}
