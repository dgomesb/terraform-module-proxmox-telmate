# module-proxmox-telmate

## Create CT/LXC

### [Unprivileged Containers](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_unprivileged_containers)

Unprivileged containers use a new kernel feature called user namespaces. The root UID 0 inside the container is mapped to an unprivileged user outside the container. This means that most security issues (container escape, resource abuse, etc.) in these containers will affect a random unprivileged user, and would be a generic kernel security bug rather than an LXC issue. The LXC team thinks unprivileged containers are safe by design.

This is the default option when creating a new container.

### [Privileged Containers](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_privileged_containers)

Security in containers is achieved by using mandatory access control AppArmor restrictions, seccomp filters and Linux kernel namespaces. The LXC team considers this kind of container as unsafe, and they will not consider new container escape exploits to be security issues worthy of a CVE and quick fix. That's why privileged containers should only be used in trusted environments.

## Notes

- [Telmate provider](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) has an issue when updating LXCs. For now, as a workaround, `cpulimit` value should match `cores` value.
  - Github issue: https://github.com/Telmate/terraform-provider-proxmox/issues/1427

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 3.0.2-rc07 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 3.0.2-rc07 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_lxc.create](https://registry.terraform.io/providers/Telmate/proxmox/3.0.2-rc07/docs/resources/lxc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arch"></a> [arch](#input\_arch) | Sets the container OS architecture type | `string` | `"amd64"` | no |
| <a name="input_base_image_os"></a> [base\_image\_os](#input\_base\_image\_os) | The base image OS | `string` | `"ubuntu-24.04-standard_24.04-2_amd64.tar.zst"` | no |
| <a name="input_bwlimit"></a> [bwlimit](#input\_bwlimit) | A number for setting the override I/O bandwidth limit (in KiB/s) | `number` | `null` | no |
| <a name="input_clone"></a> [clone](#input\_clone) | The lxc vmid to clone | `number` | `null` | no |
| <a name="input_clone_storage"></a> [clone\_storage](#input\_clone\_storage) | Target storage for full clone | `string` | `null` | no |
| <a name="input_cmode"></a> [cmode](#input\_cmode) | Configures console mode | `string` | `"tty"` | no |
| <a name="input_console"></a> [console](#input\_console) | A boolean to attach a console device to the container | `bool` | `true` | no |
| <a name="input_cores"></a> [cores](#input\_cores) | The number of cores assigned to the container. A container can use all available cores by default | `number` | `1` | no |
| <a name="input_cpuunits"></a> [cpuunits](#input\_cpuunits) | A number of the CPU weight that the container possesses | `number` | `100` | no |
| <a name="input_description"></a> [description](#input\_description) | Sets the container description seen in the web interface | `string` | `"Created by Terraform"` | no |
| <a name="input_features"></a> [features](#input\_features) | An object for allowing the container to access advanced features | <pre>object({<br/>    fuse   = optional(bool, false) # A boolean for enabling FUSE mounts<br/>    keyctl = optional(bool, false) # For unprivileged containers only. This is required to use docker inside a container.<br/>    #mknod  = optional(bool, false)  # Allow unprivileged containers to use mknod() to add certain device nodes<br/>    mount   = optional(string, null) # Defines the filesystem types (separated by semicolons) that are allowed to be mounted<br/>    nesting = optional(bool, true)   # Best used with unprivileged containers with additional id mapping. Note that this will expose procfs and sysfs contents of the host to the guest<br/>  })</pre> | `{}` | no |
| <a name="input_force"></a> [force](#input\_force) | A boolean that allows the overwriting of pre-existing containers | `bool` | `false` | no |
| <a name="input_full"></a> [full](#input\_full) | When cloning, create a full copy of all disks. This is always done when you clone a normal CT. For CT template it creates a linked clone by default. | `bool` | `true` | no |
| <a name="input_hagroup"></a> [hagroup](#input\_hagroup) | The HA group identifier the resource belongs to (requires hastate to be set!) | `string` | `null` | no |
| <a name="input_hastate"></a> [hastate](#input\_hastate) | Requested HA state for the resource. One of started, stopped, enabled, disabled, or ignored | `string` | `null` | no |
| <a name="input_hookscript"></a> [hookscript](#input\_hookscript) | A string containing a volume identifier to a script that will be executed during various steps throughout the container's lifetime. The script must be an executable file | `string` | `null` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Specifies the host name of the container | `string` | n/a | yes |
| <a name="input_ignore_unpack_errors"></a> [ignore\_unpack\_errors](#input\_ignore\_unpack\_errors) | A boolean that determines if template extraction errors are ignored during container creation | `bool` | `true` | no |
| <a name="input_lock"></a> [lock](#input\_lock) | A string for locking or unlocking the VM | `string` | `null` | no |
| <a name="input_lxc_count"></a> [lxc\_count](#input\_lxc\_count) | Number of containers to be created. When greater than 1 VMID must be set to 0 so next available VMID is used | `number` | `1` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | A number containing the amount of RAM to assign to the container (in MiB) | `number` | `1024` | no |
| <a name="input_mountpoint"></a> [mountpoint](#input\_mountpoint) | A list of objects defining volumes to use as container mount points | <pre>list(object({<br/>    mp        = string                 # The path to the mount point as seen from inside the container. The path must not contain symlinks for security reasons<br/>    size      = string                 # Size of the underlying volume. Must end in T, G, M, or K (e.g. "1T", "1G", "1024M" , "1048576K"). Note that this is a read only value.<br/>    slot      = string                 # A string containing the number that identifies the mount point (i.e. the n in mp[n])<br/>    key       = number                 # The number that identifies the mount point (i.e. the n in mp[n]).<br/>    storage   = string                 # A string containing the volume , directory, or device to be mounted into the container (at the path specified by mp). E.g. local-lvm, local-zfs, local etc.<br/>    volume    = optional(string, null) # Without 'volume' defined, Proxmox will try to create a volume with the value of 'storage' + : + 'size' (without the trailing G)<br/>    acl       = optional(bool, false)  # A boolean for enabling ACL support<br/>    backup    = optional(bool, false)  # A boolean for including the mount point in backups<br/>    quota     = optional(bool, false)  # A boolean for enabling user quotas inside the container for this mount point<br/>    replicate = optional(bool, false)  # A boolean for including this volume in a storage replica job<br/>    shared    = optional(bool, false)  # A boolean for marking the volume as available on all nodes<br/>  }))</pre> | `[]` | no |
| <a name="input_nameserver"></a> [nameserver](#input\_nameserver) | The DNS server IP address used by the container. If neither nameserver nor searchdomain are specified, the values of the Proxmox host will be used by default. | `string` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | A list of objects defining network interfaces for the container. | <pre>list(object({<br/>    bridge   = optional(string, "vmbr0") # The bridge to attach the network interface to (e.g. "vmbr0")<br/>    firewall = optional(bool, true)      # A boolean to enable the firewall on the network interface<br/>    gw       = optional(string)          # The IPv4 address belonging to the network interface's default gateway.<br/>    gw6      = optional(string)          # The IPv6 address of the network interface's default gateway<br/>    hwaddr   = optional(string)          # A string to set a common MAC address with the I/G (Individual/Group) bit not set. Automatically determined if not set<br/>    ip       = optional(string, "dhcp")  # The IPv4 address of the network interface. Can be a static IPv4 address (in CIDR notation), "dhcp", or "manual"<br/>    ip6      = optional(string)          # The IPv6 address of the network interface. Can be a static IPv6 address (in CIDR notation), "auto" , "dhcp", or "manual"<br/>    mtu      = optional(string)          # A string to set the MTU on the network interface<br/>    rate     = optional(number, null)    # A number that sets rate limiting on the network interface (Mbps)<br/>    tag      = optional(number, null)    # A number that specifies the VLAN tag of the network interface. Automatically determined if not set<br/>  }))</pre> | <pre>[<br/>  {}<br/>]</pre> | no |
| <a name="input_onboot"></a> [onboot](#input\_onboot) | A boolean that determines if the container will start on boot | `bool` | `false` | no |
| <a name="input_ostype"></a> [ostype](#input\_ostype) | The operating system type, used by LXC to set up and configure the container. Automatically determined if not set | `string` | `null` | no |
| <a name="input_password"></a> [password](#input\_password) | Sets the root password inside the container | `string` | `null` | no |
| <a name="input_pm_password"></a> [pm\_password](#input\_pm\_password) | User password | `string` | n/a | yes |
| <a name="input_pm_tls_insecure"></a> [pm\_tls\_insecure](#input\_pm\_tls\_insecure) | Disable TLS verification while connecting to the proxmox server | `bool` | `true` | no |
| <a name="input_pm_user"></a> [pm\_user](#input\_pm\_user) | The user, remember to include the authentication realm such as myuser@pam or myuser@pve | `string` | n/a | yes |
| <a name="input_pool"></a> [pool](#input\_pool) | The name of the Proxmox resource pool to add this container to | `string` | `null` | no |
| <a name="input_protection"></a> [protection](#input\_protection) | A boolean that enables the protection flag on this container. Stops the container and its disk from being removed/updated | `bool` | `false` | no |
| <a name="input_proxmox_api_url"></a> [proxmox\_api\_url](#input\_proxmox\_api\_url) | Provide the url of the host you would like the API to communicate on.<br/>It is safe to default to setting this as the URL for what you used<br/>as your `proxmox_host`, although they can be different | `string` | n/a | yes |
| <a name="input_restore"></a> [restore](#input\_restore) | A boolean to mark the container creation/update as a restore task. | `bool` | `false` | no |
| <a name="input_rootfs_size"></a> [rootfs\_size](#input\_rootfs\_size) | Size of the underlying volume. | `string` | `"32G"` | no |
| <a name="input_rootfs_storage"></a> [rootfs\_storage](#input\_rootfs\_storage) | A string containing the volume , directory, or device to be mounted into the container (at the path specified by mp). | `string` | `null` | no |
| <a name="input_searchdomain"></a> [searchdomain](#input\_searchdomain) | Sets the DNS search domains for the container. If neither nameserver nor searchdomain are specified, the values of the Proxmox host will be used by default | `string` | `null` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | Multi-line string of SSH public keys that will be added to the container. Can be defined using heredoc syntax | `string` | `""` | no |
| <a name="input_start"></a> [start](#input\_start) | A boolean that determines if the container is started after creation | `bool` | `false` | no |
| <a name="input_startup"></a> [startup](#input\_startup) | The startup and shutdown behaviour of the container | `number` | `null` | no |
| <a name="input_swap"></a> [swap](#input\_swap) | A number that sets the amount of swap memory available to the container | `number` | `512` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags of the container, semicolon-delimited (e.g. 'terraform;test'). This is only meta information | `string` | `null` | no |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | A string containing the cluster node name | `string` | n/a | yes |
| <a name="input_template"></a> [template](#input\_template) | A boolean that determines if this container is a template | `bool` | `false` | no |
| <a name="input_tty"></a> [tty](#input\_tty) | A number that specifies the TTYs available to the container | `number` | `2` | no |
| <a name="input_unique"></a> [unique](#input\_unique) | A boolean that determines if a unique random ethernet address is assigned to the container | `bool` | `true` | no |
| <a name="input_unprivileged"></a> [unprivileged](#input\_unprivileged) | A boolean that makes the container run as an unprivileged user | `bool` | `true` | no |
| <a name="input_vmid"></a> [vmid](#input\_vmid) | A number that sets the VMID of the container. If set to 0, the next available VMID is used | `number` | `0` | no |
| <a name="input_vmid_offset"></a> [vmid\_offset](#input\_vmid\_offset) | VMID offset value when lxc\_count > 1 | `number` | `0` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
