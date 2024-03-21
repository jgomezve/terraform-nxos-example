variable "interface_id" {
  type = string
}

variable "h_version" {
  type    = string
  default = "v2"
}

variable "group" {
  type = number
}

variable "vip" {
  type = string
}

variable "priority" {
  type = number
}