variable "env" {
  type     = string
  nullable = false
}

variable "bu" {
  type     = string
  nullable = false
}

variable "app" {
  type     = string
  nullable = false
}

variable "location" {
  type     = string
  nullable = false
  default  = "westus"
}

variable "vnet_address_space" {
  type     = list(string)
  nullable = false
}

variable "snets" {
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string), [])
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool, true)

    enable_nat = optional(bool, false)

    nsg_name = optional(string, null)
    nsg_rules = optional(map(object(
      {
        name                       = string
        priority                   = string
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = optional(string)
        source_port_ranges         = optional(list(string))
        destination_port_range     = optional(string)
        destination_port_ranges    = list(string)
        source_address_prefix      = string
        destination_address_prefix = string
      }
    )), {})

    route_table_name = optional(string, null)
    routes = optional(list(object(
      {
        route_name             = string
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = optional(string)
      }
    )), [])
  }))
  nullable = false
  default  = {}
}

variable "bastion_address_prefixes" {
  type     = list(string)
  nullable = false
  default  = []
}

variable "firewall_address_prefixes" {
  type     = list(string)
  nullable = false
  default  = []
}

variable "private_dns_zones" {
  type     = list(string)
  nullable = false
  default  = []
}

variable "appgw_address_prefixes" {
  type     = list(string)
  nullable = false
  default  = []
}

variable "pe_address_prefixes" {
  type     = list(string)
  nullable = false
  default  = []
}

variable "apim_address_prefixes" {
  type     = list(string)
  nullable = false
  default  = []
}
