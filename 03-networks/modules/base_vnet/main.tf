locals {

  all_snets = merge(
    var.enable_bastion && var.env == "hub"
    ? local.bastion_snet
    : {},
    var.enable_firewall && var.env == "hub"
    ? local.firewall_snet
    : {},
    var.snets
  )

  bastion_snet = {

    AzureBastionSubnet = {
      name              = "AzureBastionSubnet"
      address_prefixes  = var.bastion_address_prefixes
      service_endpoints = []

      nsg_name = "bastion"
      nsg_rules = {
        "bastionAllowHTTPSInbound" = {
          name                       = "bastionAllowHTTPSInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["443"]
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }
        "bastionAllowGatewayManagerInbound" = {
          name                       = "bastionAllowGatewayManagerInbound"
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["443"]
          source_address_prefix      = "GatewayManager"
          destination_address_prefix = "*"
        }
        "bastionAllowAzureLBInbound" = {
          name                       = "AllowAzureLBInbound"
          priority                   = 300
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["443"]
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
        }
        "bastionAllowBastionHostCommunication" = {
          name                       = "AllowBastionHostCommunication"
          priority                   = 400
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["5701", "8080"]
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
        }
        "bastionAllowRdpSshOutbound" = {
          name                       = "AllowRdpSshOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["22", "3389"]
          source_address_prefix      = "*"
          destination_address_prefix = "VirtualNetwork"
        }
        "bastionAllowBastionHostCommunicationOutbound" = {
          name                       = "AllowBastionHostCommunicationOutbound"
          priority                   = 110
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["5701", "8080"]
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
        }
        "bastionAllowAzureCloudOutbound" = {
          name                       = "AllowAzureCloudOutbound"
          priority                   = 120
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["443"]
          source_address_prefix      = "*"
          destination_address_prefix = "AzureCloud"
        }
        "bastionAllowGetSessionInformation" = {
          name                       = "AllowGetSessionInformation"
          priority                   = 130
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["80"]
          source_address_prefix      = "*"
          destination_address_prefix = "Internet"
        }

      }

      # route bastion traffic through firewall ?
      # https://learn.microsoft.com/en-us/azure/bastion/bastion-faq#udr

      # NSG
      # default inbound rule allows source VirtualNetwork and destination VirtualNetwork https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview#allowvnetinbound
      # default outbound rule allows source VirtualNetwork and destination VirtualNetwork https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview#allowvnetoutbound
      # HERE, VirtualNetwork scope includes single vnet
      # BUT, when you peer 2 vnets in Azure with a default setting of "Traffic to remote virtual network" as Allow https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering?tabs=peering-portal#create-a-peering
      # Then, VirtualNetwork scope changes to include both vnets
      # Hence, traffic between 2 vnets is allowed and
      # nsg rules are not required
    },

  }

  firewall_snet = {

    AzureFirewallSubnet = {
      name              = "AzureFirewallSubnet"
      address_prefixes  = var.firewall_address_prefixes
      service_endpoints = []

    }
  }

  nsg_rules = flatten([
    for i in values(local.all_snets) : [
      for k, v in coalesce(try(i.nsg_rules, null), {}) : {
        nsg_name                   = i.nsg_name
        name                       = v.name
        priority                   = v.priority
        direction                  = v.direction
        access                     = v.access
        protocol                   = v.protocol
        source_port_ranges         = v.source_port_ranges
        destination_port_ranges    = v.destination_port_ranges
        source_address_prefix      = v.source_address_prefix
        destination_address_prefix = v.destination_address_prefix
      }

    ]
  ])

  routes = flatten([
    for i in values(local.all_snets) : [
      for j in coalesce(try(i.routes, null), []) : {
        route_table_name       = i.route_table_name
        route_name             = j.route_name
        address_prefix         = j.address_prefix
        next_hop_type          = j.next_hop_type
        next_hop_in_ip_address = j.next_hop_in_ip_address
      }

    ]
  ])

}
