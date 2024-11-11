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

resource "azurerm_vpn_server_configuration" "ingress_vpn_config" {
  name                     = "employee-vpn-config"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  vpn_authentication_types = ["AAD"]

  azure_active_directory_authentication {
    tenant = "https://login.microsoftonline.com/aab67cdb-fd03-41d3-9ee1-5fec203fb36e"
    issuer = "https://sts.windows.net/aab67cdb-fd03-41d3-9ee1-5fec203fb36e/"
    audience = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
  }
}


resource "azurerm_point_to_site_vpn_gateway" "ingress_gateway" {
  name                        = "example-vpn-gateway"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  virtual_hub_id              = azurerm_virtual_hub.main_hub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.ingress_vpn_config.id
  scale_unit                  = 1
  connection_configuration {
    name = "vpn-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [
        var.vpn_gateway_ip_network
      ]
    }
  }
}

