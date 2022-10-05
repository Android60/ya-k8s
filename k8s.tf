resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_kubernetes_cluster" "my_cluster" {
  name        = "mylab"
  description = "My k8s cluster"

  network_id     = yandex_vpc_network.network-1.id


  master {
    version = "1.22"
    zonal {
      zone      = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-1.id
    }

    public_ip = true


    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = "ajeq3554hq74mm5jsu0j"
  node_service_account_id = "ajeq3554hq74mm5jsu0j"

  labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

}
