resource "azurerm_virtual_wan" "main_wan" {
  name                = "${var.name}-vwan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

resource "azurerm_virtual_hub" "main_hub" {
  name                = "${var.name}-hub"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  virtual_wan_id      = azurerm_virtual_wan.main_wan.id
  address_prefix      = var.vpn_ip_network
}

resource "azurerm_vpn_gateway" "employee_gateway" {
  name                = "${var.name}-employee-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  virtual_hub_id      = azurerm_virtual_hub.main_hub.id
}