variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "ip_network" {
  description = "The IP network for the environment"
  type        = string
}

variable "vpn_ip_network" {
  description = "The IP network for the VPN"
  type        = string
}

variable "vpn_gateway_ip_network" {
  description = "The IP network for the VPN Gateway"
  type        = string
}