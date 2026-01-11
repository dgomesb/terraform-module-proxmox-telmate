## https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/lxc

## Provider variables

variable "arch" {
  description = "Sets the container OS architecture type"
  type        = string
  default     = "amd64"
}

variable "bwlimit" {
  description = "A number for setting the override I/O bandwidth limit (in KiB/s)"
  type        = number
  default     = null
}

variable "clone" {
  description = "The lxc vmid to clone"
  type        = number
  default     = null
}

variable "clone_storage" {
  description = "Target storage for full clone"
  type        = string
  default     = null

  validation {
    condition = (
      var.clone == null || (var.clone != null && var.clone_storage != null)
    )
    error_message = "clone_storage must be defined when cloning a container."
  }

}

variable "cmode" {
  description = "Configures console mode"
  type        = string
  default     = "tty"
}

variable "console" {
  description = "A boolean to attach a console device to the container"
  type        = bool
  default     = true
}

variable "cores" {
  description = "The number of cores assigned to the container. A container can use all available cores by default"
  type        = number
  default     = 1
}

## tf apply fails when updating LXCs. As a workaround cpulimit needs to match cores value
## check future provider versions (newer than 3.0.2-rc05)
#variable "cpulimit" {
#  description = "A number to limit CPU usage by"
#  type        = number
#  default     = 0  # unlimited
#}

variable "cpuunits" {
  description = "A number of the CPU weight that the container possesses"
  type        = number
  default     = 100
}

variable "description" {
  description = "Sets the container description seen in the web interface"
  type        = string
  default     = "Created by Terraform"
}

variable "features" {
  description = "An object for allowing the container to access advanced features"
  type = object({
    fuse   = optional(bool, false) # A boolean for enabling FUSE mounts
    keyctl = optional(bool, false) # For unprivileged containers only. This is required to use docker inside a container.
    #mknod  = optional(bool, false)  # Allow unprivileged containers to use mknod() to add certain device nodes
    mount   = optional(string, null) # Defines the filesystem types (separated by semicolons) that are allowed to be mounted
    nesting = optional(bool, true)   # Best used with unprivileged containers with additional id mapping. Note that this will expose procfs and sysfs contents of the host to the guest
  })
  default = {}
}

variable "force" {
  description = "A boolean that allows the overwriting of pre-existing containers"
  type        = bool
  default     = false
}

variable "full" {
  description = "When cloning, create a full copy of all disks. This is always done when you clone a normal CT. For CT template it creates a linked clone by default."
  type        = bool
  default     = true
}

variable "hastate" {
  description = "Requested HA state for the resource. One of started, stopped, enabled, disabled, or ignored"
  type        = string
  default     = null
}

variable "hagroup" {
  description = "The HA group identifier the resource belongs to (requires hastate to be set!)"
  type        = string
  default     = null
}

variable "hookscript" {
  description = "A string containing a volume identifier to a script that will be executed during various steps throughout the container's lifetime. The script must be an executable file"
  type        = string
  default     = null
}

variable "hostname" {
  description = "Specifies the host name of the container"
  type        = string
}

variable "ignore_unpack_errors" {
  description = "A boolean that determines if template extraction errors are ignored during container creation"
  type        = bool
  default     = true
}

variable "lock" {
  description = "A string for locking or unlocking the VM"
  type        = string
  default     = null
}

variable "memory" {
  description = "A number containing the amount of RAM to assign to the container (in MiB)"
  type        = number
  default     = 1024
}

variable "mountpoint" {
  description = "A list of objects defining volumes to use as container mount points"
  type = list(object({
    mp        = string                 # The path to the mount point as seen from inside the container. The path must not contain symlinks for security reasons
    size      = string                 # Size of the underlying volume. Must end in T, G, M, or K (e.g. "1T", "1G", "1024M" , "1048576K"). Note that this is a read only value.
    slot      = string                 # A string containing the number that identifies the mount point (i.e. the n in mp[n])
    key       = number                 # The number that identifies the mount point (i.e. the n in mp[n]).
    storage   = string                 # A string containing the volume , directory, or device to be mounted into the container (at the path specified by mp). E.g. local-lvm, local-zfs, local etc.
    volume    = optional(string, null) # Without 'volume' defined, Proxmox will try to create a volume with the value of 'storage' + : + 'size' (without the trailing G)
    acl       = optional(bool, false)  # A boolean for enabling ACL support
    backup    = optional(bool, false)  # A boolean for including the mount point in backups
    quota     = optional(bool, false)  # A boolean for enabling user quotas inside the container for this mount point
    replicate = optional(bool, false)  # A boolean for including this volume in a storage replica job
    shared    = optional(bool, false)  # A boolean for marking the volume as available on all nodes
  }))
  default = []
  validation {
    condition = alltrue([
      for mp in var.mountpoint : can(regex("^[0-9]+(T|G|M|K)$", mp.size))
    ])
    error_message = "Size must end in T, G, M, or K (e.g., '1T', '1G', '1024M', '1048576K')."
  }
}

variable "nameserver" {
  description = "The DNS server IP address used by the container. If neither nameserver nor searchdomain are specified, the values of the Proxmox host will be used by default."
  type        = string
  default     = null
}

variable "network" {
  description = "A list of objects defining network interfaces for the container."
  type = list(object({
    bridge   = optional(string, "vmbr0") # The bridge to attach the network interface to (e.g. "vmbr0")
    firewall = optional(bool, true)      # A boolean to enable the firewall on the network interface
    gw       = optional(string)          # The IPv4 address belonging to the network interface's default gateway.
    gw6      = optional(string)          # The IPv6 address of the network interface's default gateway
    hwaddr   = optional(string)          # A string to set a common MAC address with the I/G (Individual/Group) bit not set. Automatically determined if not set
    ip       = optional(string, "dhcp")  # The IPv4 address of the network interface. Can be a static IPv4 address (in CIDR notation), "dhcp", or "manual"
    ip6      = optional(string)          # The IPv6 address of the network interface. Can be a static IPv6 address (in CIDR notation), "auto" , "dhcp", or "manual"
    mtu      = optional(string)          # A string to set the MTU on the network interface
    rate     = optional(number, null)    # A number that sets rate limiting on the network interface (Mbps)
    tag      = optional(number, null)    # A number that specifies the VLAN tag of the network interface. Automatically determined if not set
  }))
  default = [{}] # DHCP as default

  validation {
    condition = (
      length([
        for net in var.network :
        net
        if try(net.gw, null) != null
      ]) <= 1
    )
    error_message = "Only one network interface may define an IPv4 gateway (gw)."
  }
}

variable "onboot" {
  description = "A boolean that determines if the container will start on boot"
  type        = bool
  default     = false
}

variable "ostype" {
  description = "The operating system type, used by LXC to set up and configure the container. Automatically determined if not set"
  type        = string
  default     = null
}

variable "password" {
  description = "Sets the root password inside the container"
  sensitive   = true
  type        = string
  default     = null

  validation {
    condition     = (var.clone != null || (var.clone == null && var.password != null && var.password != ""))
    error_message = "A password needs to be defined"
  }
}

variable "pool" {
  description = "The name of the Proxmox resource pool to add this container to"
  type        = string
  default     = null
}

variable "protection" {
  description = "A boolean that enables the protection flag on this container. Stops the container and its disk from being removed/updated"
  type        = bool
  default     = false
}

variable "restore" {
  description = "A boolean to mark the container creation/update as a restore task."
  type        = bool
  default     = false
}

variable "rootfs_size" {
  description = "Size of the underlying volume."
  type        = string
  default     = "32G"

  validation {
    condition     = can(regex("^[0-9]+(T|G|M|K)$", var.rootfs_size))
    error_message = "Size must end in T, G, M, or K (ex.: '1T', '1G', '1024M', '1048576K')."
  }
}

variable "rootfs_storage" {
  description = "A string containing the volume , directory, or device to be mounted into the container (at the path specified by mp)."
  type        = string
  default     = null

  validation {
    condition = (
      var.clone != null || (var.clone == null && var.rootfs_storage != null)
    )
    error_message = "rootfs_storage must be defined when creating a new container."
  }
}

variable "searchdomain" {
  description = "Sets the DNS search domains for the container. If neither nameserver nor searchdomain are specified, the values of the Proxmox host will be used by default"
  type        = string
  default     = null
}

variable "ssh_public_keys" {
  description = "Multi-line string of SSH public keys that will be added to the container. Can be defined using heredoc syntax"
  type        = string
  default     = ""
}

variable "start" {
  description = "A boolean that determines if the container is started after creation"
  type        = bool
  default     = false
}

variable "startup" {
  description = "The startup and shutdown behaviour of the container"
  type        = number
  default     = null
}

variable "swap" {
  description = "A number that sets the amount of swap memory available to the container"
  type        = number
  default     = 512
}

variable "tags" {
  description = "Tags of the container, semicolon-delimited (e.g. 'terraform;test'). This is only meta information"
  type        = string
  default     = null
}

variable "target_node" {
  description = "A string containing the cluster node name"
  type        = string
}

variable "template" {
  description = "A boolean that determines if this container is a template"
  type        = bool
  default     = false
}

variable "tty" {
  description = "A number that specifies the TTYs available to the container"
  type        = number
  default     = 2
}

variable "unique" {
  description = "A boolean that determines if a unique random ethernet address is assigned to the container"
  type        = bool
  default     = true
}

variable "unprivileged" {
  description = "A boolean that makes the container run as an unprivileged user"
  type        = bool
  default     = true
}

variable "vmid" {
  description = "A number that sets the VMID of the container. If set to 0, the next available VMID is used"
  type        = number
  default     = 0
  validation {
    condition     = var.vmid == 0 || var.vmid >= 100
    error_message = "The VM ID must be either 0 or a number >= 100 (not yet in use)"
  }
}

## my custom variables

variable "vmid_offset" {
  description = "VMID offset value when lxc_count > 1"
  type        = number
  default     = 0
}

variable "base_image_os" {
  description = "The base image OS"
  type        = string
  default     = "ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "lxc_count" {
  description = "Number of containers to be created. When greater than 1 VMID must be set to 0 so next available VMID is used"
  type        = number
  default     = 1
  validation {
    condition     = var.lxc_count >= 1
    error_message = "lxc_count must be >= 1"
  }
}

## Proxmox variables

variable "proxmox_api_url" {
  type        = string
  description = <<-EOT
    Provide the url of the host you would like the API to communicate on.
    It is safe to default to setting this as the URL for what you used
    as your `proxmox_host`, although they can be different
  EOT
}

variable "pm_user" {
  description = "The user, remember to include the authentication realm such as myuser@pam or myuser@pve"
  type        = string
}

variable "pm_password" {
  description = "User password"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Disable TLS verification while connecting to the proxmox server"
  type        = bool
  default     = true
}
