resource "azurerm_virtual_network" "main_network" {
  name                = "${var.name}-network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space = [var.ip_network]
}