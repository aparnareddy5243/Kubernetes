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
    key                   = "terraform_dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aparna_aks_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_kubernetes_cluster" "aparna_aks" {
  name                = var.azurerm_kubernetes_cluster
  location            = azurerm_resource_group.aparna_aks_rg.location
  resource_group_name = azurerm_resource_group.aparna_aks_rg.name
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
}
