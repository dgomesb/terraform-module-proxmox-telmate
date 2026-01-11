## Provider variables
variable "proxmox_api_url" {}
variable "pm_user" {}
variable "pm_password" {}

## Proxmox Node
variable "target_node" {}
variable "rootfs_storage" {}

## LXC
variable "password" {}

#variable "lxc_count" {
#  default     = 1
#}
