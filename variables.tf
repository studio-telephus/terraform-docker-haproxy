variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "networks_advanced" {
  type = list(any)
}

variable "upload_dirs" {
  type    = list(string)
  default = []
}

variable "exec_enabled" {
  type    = bool
  default = true
}

variable "exec" {
  type    = string
  default = "/mnt/install.sh"
}

variable "local_exec_interpreter" {
  type    = list(string)
  default = ["/bin/bash", "-c"]
}

variable "environment" {
  type    = map(any)
  default = {}
}

variable "bind_port" {
  type = number
}

variable "servers" {
  type = list(object({
    address = string
    port    = string
  }))
}

variable "stats_auth_username" {
  type    = string
  default = "haproxy-stats"
}

variable "stats_auth_password" {
  type      = string
  sensitive = true
}

variable "restart" {
  type    = string
  default = "unless-stopped"
}
