module "clone" {
  source = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc?ref=v0.1.0"

  ## Provider variables
  proxmox_api_url = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password

  ## Proxmox node
  target_node   = var.target_node
  clone_storage = var.clone_storage

  ## General
  vmid     = 999
  hostname = "test"
  clone    = "9000"

}
