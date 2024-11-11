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
  subscription_id = "3157762c-4d55-46a5-aa50-6175c7d4426d"
}
