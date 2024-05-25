terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name   = "ap_rg1"
    storage_account_name  = "terraform524"
    container_name        = "kubecontainer"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aparna_aks_rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "aparna_aks" {
  name                = var.azurerm_kubernetes_cluster
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aparna-aks"
  depends_on          = [azurerm_resource_group.aparna_aks_rg]

  default_node_pool {
    name       = "aparnapool"
    node_count = var.node_count
    vm_size    = "Standard_D2_v2"
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  service_principal {
    client_id     = "56062a47-bd5b-4f13-bb58-f0b482ec25c5"
    client_secret = "7e2729b0-e12c-4a5f-bb74-689e988c1c8d"
  }
}
