terraform {
  required_providers {
    nxos = {
      source = "CiscoDevNet/nxos"
    }
  }
}

provider "nxos" {
  username = "admin"
  password = "admin"
  url      = "https://sbx-nxos-mgmt.cisco.com"
}

resource "nxos_ospf" "ospfEntity" {
  admin_state = "enabled"
}

resource "nxos_ospf_instance" "ospfInst" {
  name = var.name

  depends_on = [nxos_ospf.ospfEntity]
}

resource "nxos_ospf_vrf" "ospfDom" {
  instance_name = var.name
  name          = var.vrf
  router_id     = var.router_id

  depends_on = [
    nxos_ospf_instance.ospfInst
  ]
}

resource "nxos_ospf_interface" "ospfIf" {
  for_each      = { for iface in var.interfaces : iface.id => iface }
  instance_name = var.name
  vrf_name      = var.vrf
  interface_id  = each.value.id
  area          = each.value.area
  depends_on = [
    nxos_ospf_vrf.ospfDom,
    nxos_physical_interface.l1PhysIf
  ]
}

resource "nxos_physical_interface" "l1PhysIf" {
  for_each     = { for iface in var.interfaces : iface.id => iface }
  interface_id = each.value.id
  admin_state  = "up"
  layer        = "Layer3"
}