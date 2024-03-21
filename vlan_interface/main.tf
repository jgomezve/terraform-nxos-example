terraform {
  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
    }
  }
}

provider "nxos" {
  username = "admin"
  password = "admin"
  url      = "https://sbx-nxos-mgmt.cisco.com"
}

resource "nxos_bridge_domain" "my_vlan" {
  fabric_encap = "vlan-10"
  name         = "MGMT_VLAN"
}

resource "nxos_physical_interface" "my_interface" {
  interface_id             = "eth1/10"
  access_vlan              = "vlan-10"
  admin_state              = "up"
  layer                    = "Layer2"
  mode                     = "access"
  depends_on               = [ nxos_bridge_domain.my_vlan ]
}