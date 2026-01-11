terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure

  ## Logging
  #pm_log_enable = true
  #pm_log_file   = "terraform-plugin-proxmox.log"
  #pm_debug      = true
  #pm_log_levels = {
  #  _default    = "debug"
  #  _capturelog = ""
  #}

}
