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

resource "nxos_rest" "hsrpEntity" {
  dn         = "sys/hsrp"
  class_name = "hsrpEntity"
  content = {
    adminSt = "enabled"
  }
}

resource "nxos_rest" "hsrpInst" {
  dn         = "${nxos_rest.hsrpEntity.id}/inst"
  class_name = "hsrpInst"
  content = {
    adminSt = "enabled"
  }
}

resource "nxos_rest" "hsrpIf" {
  dn         = "${nxos_rest.hsrpInst.id}/if-[${var.interface_id}]"
  class_name = "hsrpIf"
  content = {
    id      = var.interface_id
    version = var.h_version
  }
}

resource "nxos_rest" "hsrpGroup" {
  dn         = "${nxos_rest.hsrpIf.id}/grp-[${var.group}]-[ipv4]"
  class_name = "hsrpGroup"
  content = {
    af   = "ipv4"
    id   = var.group
    ip   = var.vip
    prio = var.priority
  }
}