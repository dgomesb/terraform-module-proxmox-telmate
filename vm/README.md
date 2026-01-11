# module-proxmox-telmate

## Virtual Machine

### Create

### Clone

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
| [proxmox_vm_qemu.vm](https://registry.terraform.io/providers/Telmate/proxmox/3.0.2-rc07/docs/resources/vm_qemu) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pm_password"></a> [pm\_password](#input\_pm\_password) | User password | `string` | n/a | yes |
| <a name="input_pm_tls_insecure"></a> [pm\_tls\_insecure](#input\_pm\_tls\_insecure) | Disable TLS verification while connecting to the proxmox server | `bool` | `true` | no |
| <a name="input_pm_user"></a> [pm\_user](#input\_pm\_user) | The user, remember to include the authentication realm such as myuser@pam or myuser@pve | `string` | n/a | yes |
| <a name="input_proxmox_api_url"></a> [proxmox\_api\_url](#input\_proxmox\_api\_url) | Provide the url of the host you would like the API to communicate on.<br/>It is safe to default to setting this as the URL for what you used<br/>as your `proxmox_host`, although they can be different | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
