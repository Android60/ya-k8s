resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = yandex_kubernetes_cluster.my_cluster.id
  name        = "my-node-group"
  version     = "1.22"

  labels = {
    "project" = "kubelab"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids          = [yandex_vpc_subnet.subnet-1.id]
    }

    resources {
      memory = 2
      core_fraction = 5
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "friday"
      start_time = "23:00"
      duration   = "4h30m"
    }
  }
}