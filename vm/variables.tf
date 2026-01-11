## https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/lxc

## Provider variables

## my custom variables

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
