variable "client_id" {
  sensitive   = true
  type        = string
  default     = ""
  description = "The Client Id"
}

variable "client_secret" {
  sensitive   = true
  type        = string
  default     = ""
  description = "The Client Secret"
}

variable "username" {
  sensitive   = true
  type        = string
  default     = ""
  description = "The Username"
}

variable "password" {
  sensitive   = true
  type        = string
  default     = ""
  description = "The Password"
}
