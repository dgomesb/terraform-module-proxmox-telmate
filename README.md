# terraform-module-proxmox-telmate

Make sure to read the official documentation on how to create a Proxmox user and role for Terraform.

- TF Provider: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
- Github: https://github.com/Telmate/terraform-provider-proxmox

I wrote this module to learn more about Terraform and to automate my homelab. I would appreciate any code changes or suggestions.

## Container/LXC

### Create

These are some default values when creating a new unprivileged container:

- vCPU: `1`
- RAM: `1024MiB`
- SWAP: `512MiB`
- DISK: `32GiB` (without mountpoints)
- Network: `DHCP`

#### Examples

- Single container:

```terraform
module "lxc" {
  source  = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc#?ref=v0.1.0"

  ## Provider variables
  proxmox_api_url = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password

  ## Proxmox Node
  target_node    = var.target_node
  rootfs_storage = var.rootfs_storage

  ## General
  vmid            = 900
  hostname        = "myLXC"
  password        = var.password
  base_image_os   = "alpine-3.23-cloud.tar.xz"

  ## Extras
  start = true
}
```

- Multiple containers:

```terraform
module "app" {

  source  = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc#?ref=v0.1.0"

  ## Provider variables
  proxmox_api_url = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password

  ## Proxmox Node
  target_node    = var.target_node
  rootfs_storage = var.rootfs_storage

  vmid_offset = 9001
  lxc_count   = 3

  ## General
  hostname        = "app"
  password        = var.password
  base_image_os   = "alpine-3.23-cloud.tar.xz"

  # for static IPs
  network = [
    for i in range(var.lxc_count) :
    { ip = "10.0.0.${201 + i}/24", gw = "10.0.0.1" }
  ]

  ## Extras
  start = true
}
```

### Clone

⚠️ Needs to be fixed.

#### Example

```terraform
module "lxc" {
  source = "github.com/dgomesb/terraform-module-proxmox-telmate.git/lxc?ref=v0.1.0"

  ## Provider variables
  proxmox_api_url = var.proxmox_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password

  ## Proxmox node
  target_node   = var.target_node
  clone_storage = var.clone_storage

  ## General
  vmid          = 999
  hostname      = "cloned"
  clone         = "9000"

}
```

### Virtual Machine

### Create

- to be done

### Clone

- to be done
