# The primary use-case for the null resource is as a do-nothing container
# for arbitrary actions taken by a provisioner.

resource "null_resource" "disable_swap" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {

    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
      # private_key = file(var.connection.private_key)
    }

    inline = [
      "sudo swapoff -a",
      "sudo sed -i -e '/swap/d' /etc/fstab"
    ]
  }
}

resource "null_resource" "install_kubeadm_packages" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {

    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
      # private_key = file(var.connection.private_key)
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y apt-transport-https ca-certificates curl",
      "sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
      "echo deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt update",
      "sudo apt install -y kubelet kubeadm kubectl",
      "sudo apt-mark hold kubelet kubeadm kubectl"
    ]
  }

  depends_on = [null_resource.disable_swap]
}

resource "null_resource" "enabling_unsafe_sysctls" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {

    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
      # private_key = file(var.connection.private_key)
    }

    inline = [
      "sudo mkdir -p /etc/default/",
      "echo KUBELET_EXTRA_ARGS=--allowed-unsafe-sysctls net.ipv4.ip_forward | sudo tee /etc/default/kubelet"
    ]
  }

  depends_on = [null_resource.install_kubeadm_packages]
}

resource "null_resource" "init_k8s" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {

    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
      # private_key = file(var.connection.private_key)
    }

    inline = [
      "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p $HOME/.kube",
      "sudo cp --force /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config"
    ]
  }

  depends_on = [null_resource.enabling_unsafe_sysctls]
}

resource "null_resource" "install_helm" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {

    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
      # private_key = file(var.connection.private_key)
    }

    inline = [
      "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
      "chmod 700 get_helm.sh",
      "./get_helm.sh"
    ]
  }

  depends_on = [null_resource.init_k8s]
}
