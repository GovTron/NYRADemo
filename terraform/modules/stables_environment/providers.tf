terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  features {

  }
  subscription_id = "9e9dd15c-8d12-442b-b517-95396b6596aa"
}