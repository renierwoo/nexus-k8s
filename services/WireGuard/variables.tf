###########################
### WireGuard variables ###
###########################

variable "tools_namespace_name" {
  type        = string
  default     = "tools"
  description = "Metadata namespace name."
}

variable "wireguard_server" {
  type = object({
    private_key = string
    public_key = string
    ip_address = string
    dns = string
    mtu = string
    listen_port = string
    post_up = string
    post_down = string
  })
}

variable "wireguard_peers" {
  type = list(object({
    comment = string
    private_key = string
    public_key = string
    allowed_ips = string
  }))
}

variable "domain" {
  type        = string
  description = "The domain for the naked site."
}

variable "wireguard_domain" {
  type        = string
  description = "The domain for the WireGuard site."
}
