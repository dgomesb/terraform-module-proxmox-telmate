locals {
  is_clone  = var.clone != null
  is_create = !local.is_clone
}

resource "proxmox_lxc" "create" {

  count = var.lxc_count

  ## proxmox node
  target_node = var.target_node
  pool        = var.pool

  ## General
  vmid            = var.vmid_offset == 0 ? var.vmid + count.index : var.vmid_offset + count.index
  hostname        = var.lxc_count == 1 ? var.hostname : format("%s%02d", var.hostname, count.index + 1)
  password        = local.is_create ? var.password : null
  ssh_public_keys = var.ssh_public_keys
  unprivileged    = var.unprivileged
  description     = var.description
  arch            = var.arch
  cmode           = var.cmode
  console         = var.console
  protection      = var.protection
  tty             = var.tty

  ## Clone
  clone         = local.is_clone ? var.clone : null
  clone_storage = local.is_clone ? var.clone_storage : null
  full          = local.is_clone ? var.full : null

  ## Template (ONLY on create)
  ostemplate = local.is_create ? "${var.rootfs_storage}:vztmpl/${var.base_image_os}" : null

  ## Disks / TF will crash without rootfs defined
  dynamic "rootfs" {
    for_each = local.is_create ? [1] : []
    content {
      size    = var.rootfs_size
      storage = var.rootfs_storage
    }
  }

  dynamic "mountpoint" {
    for_each = var.mountpoint
    content {
      mp        = mountpoint.value.mp
      size      = mountpoint.value.size
      slot      = mountpoint.value.slot
      key       = mountpoint.value.key
      storage   = mountpoint.value.storage
      volume    = mountpoint.value.volume
      acl       = mountpoint.value.acl
      backup    = mountpoint.value.backup
      quota     = mountpoint.value.quota
      replicate = mountpoint.value.replicate
      shared    = mountpoint.value.shared
    }
  }

  ## CPU & Memory
  cores    = var.cores
  cpulimit = var.cores
  cpuunits = var.cpuunits
  memory   = var.memory
  swap     = var.swap

  ## Network
  dynamic "network" {
    for_each = var.network
    iterator = net
    content {
      name     = "eth${net.key}" # The name of the network interface as seen from inside the container (e.g. "eth0")
      bridge   = lookup(net.value, "bridge", null)
      firewall = lookup(net.value, "firewall", null)
      ip       = lookup(net.value, "ip", null)
      ip6      = lookup(net.value, "ip6", null)
      gw       = lookup(net.value, "gw", null)
      gw6      = lookup(net.value, "gw6", null)
      hwaddr   = lookup(net.value, "hwaddr", null)
      mtu      = lookup(net.value, "mtu", null)
      rate     = lookup(net.value, "rate", null)
      tag      = lookup(net.value, "tag", null)
    }
  }

  ## DNS
  nameserver   = var.nameserver
  searchdomain = var.searchdomain

  ## Extras
  start      = var.start
  onboot     = var.onboot
  startup    = try(format("order=%s", var.startup), null)
  hookscript = var.hookscript

  features {
    fuse   = var.features.fuse
    keyctl = var.features.keyctl
    #mknod   = var.features.mknod   # in proxmox wiki but not in the provider
    mount   = var.features.mount
    nesting = var.features.nesting
  }

}
