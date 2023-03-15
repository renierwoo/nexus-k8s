# The primary use-case for the null resource is as a do-nothing container
# for arbitrary actions taken by a provisioner.

#####################
### Initial Setup ###
#####################

resource "null_resource" "update_system_packages" {

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
      "sudo apt full-upgrade -y",
      "sudo apt autoremove -y"
    ]
  }
}

resource "null_resource" "change_hostname" {

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
      "if hostnamectl hostname | grep '${var.hostname}'; then echo 'Already changed'; else sudo hostnamectl set-hostname ${var.hostname}; fi"
    ]
  }

  depends_on = [null_resource.update_system_packages]
}


resource "null_resource" "change_hosts" {

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
      "if cat /etc/hosts | grep '127.0.1.1' | grep '${var.domain}'; then echo 'Already changed'; else sudo sed -i '/127.0.1.1/ s/$/ ${var.domain}/' /etc/hosts; fi",
      "if cat /etc/hosts | grep '${var.connection.host}' | grep '${var.domain}'; then echo 'Already changed'; else sudo sed -i '/${var.connection.host}/ s/$/ ${var.domain}/' /etc/hosts; fi"
    ]
  }

  depends_on = [null_resource.change_hostname]
}

####################################
### Setting Up Container Runtime ###
####################################

resource "null_resource" "uninstall_old_versions" {

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
      "for package in ${join(" ", var.old_package_versions)}; do sudo apt remove $package -y; done"
    ]
  }

  depends_on = [null_resource.change_hosts]
}

resource "null_resource" "setup_docker_repository" {

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
      "for package in ${join(" ", var.packages_apt_https)}; do sudo apt install $package -y; done",
      "sudo mkdir -m 0755 -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
    ]
  }

  depends_on = [null_resource.uninstall_old_versions]
}

resource "null_resource" "install_docker_engine" {

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
      "for package in ${join(" ", var.packages_for_docker)}; do sudo apt install $package -y; done",
      "containerd config default > /tmp/config.toml",
      "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /tmp/config.toml",
      "sudo chmod 644 /tmp/config.toml",
      "sudo chown root:root /tmp/config.toml",
      "sudo mv --force /tmp/config.toml /etc/containerd/",
      "sudo systemctl restart containerd"
    ]
  }

  depends_on = [null_resource.setup_docker_repository]
}

##########################################
### Setting Up Networking and Firewall ###
##########################################

resource "null_resource" "forwarding_ipv4_bridge" {

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
      "cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf",
      "overlay",
      "br_netfilter",
      "EOF",
      "sudo modprobe overlay",
      "sudo modprobe br_netfilter",
      # sysctl params required by setup, params persist across reboots
      "cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf",
      "net.bridge.bridge-nf-call-iptables  = 1",
      "net.bridge.bridge-nf-call-ip6tables = 1",
      "net.ipv4.ip_forward                 = 1",
      "EOF",
      # Apply sysctl params without reboot
      "sudo sysctl --system"
    ]
  }

  depends_on = [null_resource.install_docker_engine]
}

# Copy the firewall script to the remote instance
resource "null_resource" "configure_ufw" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  connection {
    type        = var.connection.type
    host        = var.connection.host
    user        = var.connection.user
    private_key = var.private_key
    # private_key = file(var.connection.private_key)
  }

  provisioner "file" {

    source      = "${path.module}/artifacts/firewall.sh"
    destination = "/tmp/firewall.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/firewall.sh",
      "/tmp/firewall.sh"
    ]
  }

  depends_on = [null_resource.forwarding_ipv4_bridge]
}
