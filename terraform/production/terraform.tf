terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform2"
    storage_account_name = "nyragovtrontf2"
    container_name       = "tfstate2"
    key                  = "/production.terraform.tfstate"
  }
}

provider "azurerm" {

}


module "stables" {
  source                 = "../modules/stables_environment"
  name                   = "production"
  ip_network             = "10.0.0.0/16"
  vpn_ip_network         = "10.1.0.0/16"
  vpn_gateway_ip_network = "10.2.0.0/16"
  bastion_address_prefix = "10.0.127.0/24"
}
