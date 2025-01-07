locals {
  rg_name   = azurerm_resource_group.net.name
  vnet_name = azurerm_virtual_network.vnet.name

  all_snets = merge(
    length(var.bastion_address_prefixes) > 0 && var.env == "hub"
    ? local.bastion_snet
    : {},
    length(var.firewall_address_prefixes) > 0 && var.env == "hub"
    ? local.firewall_snet
    : {},
    length(var.appgw_address_prefixes) > 0 && var.env != "hub"
    ? local.appgw_snet
    : {},
    length(var.pe_address_prefixes) > 0 && var.env != "hub"
    ? local.pe_snet
    : {},
    length(var.apim_address_prefixes) > 0 && var.env != "hub"
    ? local.apim_snet
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
          name                       = "bastionAllowAzureLBInbound"
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
          name                       = "bastionAllowBastionHostCommunication"
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
          name                       = "bastionAllowRdpSshOutbound"
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
          name                       = "bastionAllowBastionHostCommunicationOutbound"
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
          name                       = "bastionAllowAzureCloudOutbound"
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
          name                       = "bastionAllowGetSessionInformation"
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
      name             = "AzureFirewallSubnet"
      address_prefixes = var.firewall_address_prefixes

    }
  }

  appgw_snet = {

    appgwsubnet = {
      name             = "appgwsubnet"
      address_prefixes = var.appgw_address_prefixes
      nsg_name         = "appgw"
      nsg_rules = {
        "appgwAllowHTTPSInbound" = {
          name                       = "appgwAllowHTTPSInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["443"]
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }
        "appgwAllowHTTPInbound" = {
          name                       = "appgwAllowHTTPInbound"
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["80"]
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }
        "appgwAllowGatewayManagerInbound" = {
          name                       = "appgwAllowGatewayManagerInbound"
          priority                   = 300
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["65200-65535"]
          source_address_prefix      = "GatewayManager"
          destination_address_prefix = "*"
        }
        "appgwAllowAzureLBInbound" = {
          name                       = "appgwAllowAzureLBInbound"
          priority                   = 400
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_ranges         = ["*"]
          destination_port_ranges    = ["443"]
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
        }
      }
    }
  }

  pe_snet = {

    pesubnet = {
      name                              = "pesubnet"
      address_prefixes                  = var.pe_address_prefixes
      private_endpoint_network_policies = "Disabled"
    }
  }

  apim_snet = {

    apimsubnet = {
      name                              = "apimsubnet"
      address_prefixes                  = var.apim_address_prefixes
      private_endpoint_network_policies = "Disabled"
      nsg_name                          = "apim"
      # For testing allow all inbound and outbound
      # Correct list of rules at https://learn.microsoft.com/en-gb/azure/api-management/virtual-network-reference?tabs=stv2
      nsg_rules = {
        "apimAllowAllInbound" = {
          name                       = "apimAllowAllInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
        "apimAllowAllOutbound" = {
          name                       = "apimAllowAllOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      }
    }
  }

  nsg_rules = flatten([
    for i in values(local.all_snets) : [
      for k, v in try(i.nsg_rules, {}) : {
        nsg_name                   = i.nsg_name
        name                       = v.name
        priority                   = v.priority
        direction                  = v.direction
        access                     = v.access
        protocol                   = v.protocol
        source_port_range          = try(v.source_port_range, null)
        source_port_ranges         = try(v.source_port_ranges, null)
        destination_port_range     = try(v.destination_port_range, null)
        destination_port_ranges    = try(v.destination_port_ranges, null)
        source_address_prefix      = v.source_address_prefix
        destination_address_prefix = v.destination_address_prefix
      }

    ]
  ])

  routes = flatten([
    for i in values(local.all_snets) : [
      for j in try(i.routes, []) : {
        route_table_name       = i.route_table_name
        route_name             = j.route_name
        address_prefix         = j.address_prefix
        next_hop_type          = j.next_hop_type
        next_hop_in_ip_address = j.next_hop_in_ip_address
      }

    ]
  ])



}
