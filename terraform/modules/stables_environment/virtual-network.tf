resource "azurerm_virtual_network" "main_network" {
  name                = "${var.name}-network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space = [var.ip_network]
}


resource "azurerm_subnet" "db_subnet" {
  name                              = "${var.name}-db-subnet"
  resource_group_name               = azurerm_resource_group.main.name
  virtual_network_name              = azurerm_virtual_network.main_network.name
  address_prefixes = [cidrsubnet(var.ip_network, 8, 0)]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "container_subnet" {
  name                              = "${var.name}-container-subnet"
  resource_group_name               = azurerm_resource_group.main.name
  virtual_network_name              = azurerm_virtual_network.main_network.name
  address_prefixes = [cidrsubnet(var.ip_network, 8, 1)]
  private_endpoint_network_policies = "Enabled"


  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }
}


resource "azurerm_subnet" "desktop_subnet" {
  address_prefixes = [
    cidrsubnet(var.ip_network, 8, 2),
  ]
  name                 = "desktops-${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main_network.name
}