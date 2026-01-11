### Base image OS

```
base_image_os = "alpine-edge.tar.gz"  # Default: ubuntu-24.04.tar.xz
```

### Disks

```
  rootfs_size    = "8G"         # Default: "32G"
  rootfs_storage = "local-hdd"  # Default: "local-data"
```

### Multiple NICs

```
  network = [
    {}, #dhcp
    {
      ip       = "10.0.0.250/24"
      gw       = "10.0.0.1"
    }
  ]
```

### Multiple mountpoints

```
  mountpoint = [
    {
      mp        = "/mnt/data"
      volume    = "/mnt/data"
      size      = "100G"
      slot      = "1"
      key       = 1
      storage   = "local-lvm"
      acl       = true
      backup    = false
      quota     = true
      replicate = false
      shared    = true
    },
    {
      mp        = "/mnt/logs"
      volume    = "/mnt/logs"
      size      = "50G"
      slot      = "2"
      key       = 2
      storage   = "local"
    }
  ]
```

### count_lxc > 1

When count > 1, `VMID` will be automaticlly set to `0` and the next available VMID is used".

```
count_lxc = 3
hostname  = "app"  # Will be created: app01, app02, app03

```
