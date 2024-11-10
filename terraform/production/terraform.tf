terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "nyragovtrontf"
    container_name       = "tfstate"
    key                  = "/production.terraform.tfstate"
  }
}

provider "azurerm" {

}


module "stables" {
  source         = "../modules/stables_environment"
  name           = "production"
  ip_network     = "10.0.0.0/16"
  vpn_ip_network = "10.1.0.0/16"
}
