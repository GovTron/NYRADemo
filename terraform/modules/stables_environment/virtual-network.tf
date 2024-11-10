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

resource "azurerm_subnet" "firewall_subnet" {
  name = "AzureFirewallSubnet"
  address_prefixes = [
    cidrsubnet(var.ip_network, 8, 3),
  ]
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main_network.name
}


resource "azurerm_public_ip" "main_waf" {
  name                = "main_waf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_firewall" "waf" {
  name                = "firewall"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.main_waf.id
  }
}