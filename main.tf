locals {
  haproxy_nodes = [for i, item in var.servers : {
    key : "HAPROXY_NODE_${i}",
    value : "${item.address}:${item.port}"
  }]
}

resource "null_resource" "container_environment" {
  triggers = {
    for item in local.haproxy_nodes : item.key => item.value
  }
}

module "container_haproxy" {
  source                 = "github.com/studio-telephus/terraform-docker-container.git?ref=main"
  name                   = var.name
  image                  = var.image
  networks               = var.networks
  mount_dirs             = concat(["${path.module}/filesystem", ], var.mount_dirs)
  entrypoint             = ["/usr/sbin/init"]
  exec_enabled           = var.exec_enabled
  exec                   = var.exec
  local_exec_interpreter = var.local_exec_interpreter
  environment = merge(
    null_resource.container_environment.triggers,
    {
      "BIND_PORT"                   = var.bind_port
      "HAPROXY_STATS_AUTH_USERNAME" = var.stats_auth_username
      "HAPROXY_STATS_AUTH_PASSWORD" = var.stats_auth_password
    },
    var.environment
  )
  restart = var.restart
}
