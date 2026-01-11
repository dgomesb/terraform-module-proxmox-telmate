module "lxc" {

  source = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc?ref=v0.1.0"

  ## Provider variables
  proxmox_api_url = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password

  ## Proxmox Node
  target_node    = var.target_node
  rootfs_storage = var.rootfs_storage

  ## General
  vmid          = 900
  hostname      = "test"
  password      = var.password
  base_image_os = "alpine-3.23-cloud.tar.xz"

  ## Disks
  #rootfs_size = "16G" # Default: "32G"
  #rootfs_storage = "local-hdd" # Default: "pve01-nvme"

  ## Mount point(s)
  #mountpoint = []

  ## Network
  #network      = [{}]

  ## Extras
  start = true # Default: false

}

#module "app" {
#
#  source      = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc?ref=v0.1.0"
#
#  ## Provider variables
#  proxmox_api_url = var.proxmox_api_url
#  pm_user         = var.pm_user
#  pm_password     = var.pm_password
#
#  vmid_offset = 901
#  lxc_count   = 3
#
#  hostname      = "app"
#  password      = var.password
#  base_image_os = "alpine-edge.tar.xz"
#
#  network = [
#    for i in range(var.lxc_count) :
#    { ip = "10.0.0.${201 + i}/24", gw = "10.0.0.1" }
#  ]
#
#  ## Extras
#  start = true # Default: false
#}

#module "web" {
#  source      = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc?ref=v0.1.0"
#
#  ## Provider variables
#  proxmox_api_url = var.proxmox_api_url
#  pm_user         = var.pm_user
#  pm_password     = var.pm_password
#
#  vmid_offset = 904
#  lxc_count   = 2
#
#  hostname      = "web"
#  password      = var.password
#  base_image_os = "alpine-edge.tar.xz"
#
#  ## Extras
#  start = true # Default: false
#}
