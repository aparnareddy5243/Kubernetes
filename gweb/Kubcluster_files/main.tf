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
    # No key specified here
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

