#####################
### Initial Setup ###
#####################

resource "null_resource" "update_system" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo Updating package list.",
      "if sudo apt update; then",
        "echo The package list has been updated.",
      "else",
        "echo An error ocurred during the update process",
      "fi",
      "echo Upgrading all packages to the latest version.",
      "if sudo apt full-upgrade -y; then",
        "echo All packages have been upgraded to the latest version.",
      "else",
        "echo An error ocurred during the upgrade process",
      "fi",
      "echo Removing all deprecated packages from the system.",
      "if sudo apt autoremove -y; then",
        "echo All deprecated packages have been removed from the system.",
      "else",
        "echo An error ocurred during the removal process",
      "fi"
    ]
  }
}

resource "null_resource" "set_hostname" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo Checking if the hostname is configured.",
      "if hostnamectl hostname | grep '${var.hostname}'; then",
        "echo The hostname is already configured",
      "else",
        "echo The hostname is not configured.",
        "echo Configuring the hostname.",
        "if sudo hostnamectl set-hostname ${var.hostname}; then",
          "echo The hostname has been configured.",
        "else",
          "echo An error ocurred during the configuration process",
        "fi",
      "fi"
    ]
  }

  depends_on = [null_resource.update_system]
}


resource "null_resource" "set_hosts" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo 'Checking if the domain is configured (Part 1).'",
      "if cat /etc/hosts | grep '127.0.1.1' | grep '${var.domain}'; then",
        "echo The domain is already configured.",
      "else",
        "echo The domain is not configured",
        "echo Configuring the domain.",
        "if sudo sed -i '/127.0.1.1/ s/$/ ${var.domain}/' /etc/hosts; then",
          "echo The domain is configured",
        "else",
          "echo An error ocurred during the configuration process",
        "fi",
      "fi",
      "echo 'Checking if the domain is configured (Part 2).'",
      "if cat /etc/hosts | grep '${var.connection.host}' | grep '${var.domain}'; then",
        "echo The domain is already configured.",
      "else",
        "echo The domain is not configured",
        "echo Configuring the domain.",
        "if sudo sed -i '/${var.connection.host}/ s/$/ ${var.domain}/' /etc/hosts; then",
          "echo The domain is configured",
        "else",
          "echo An error ocurred during the configuration process",
        "fi",
      "fi"
    ]
  }

  depends_on = [null_resource.set_hostname]
}

####################################
### Setting Up Container Runtime ###
####################################

resource "null_resource" "uninstall_old_versions" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo Checking if there are old versions of Docker packages on the system.",
      "for package in ${join(" ", var.old_package_versions)}; do",
        "if dpkg-query -s $package > /dev/null 2>&1; then",
          "echo The package $package is already installed",
          "echo Removing the package $package from the system.",
          "if sudo apt remove -y $package; then",
            "echo The package $package has been removed successfully",
          "else",
            "echo An error ocurred during the removal process",
          "fi",
        "else",
          "echo The package $package is not installed",
        "fi",
      "done"
    ]
  }

  depends_on = [null_resource.set_hosts]
}

resource "null_resource" "setup_docker_repository" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo Checking if the Docker packages are installed.",
      "for package in ${join(" ", var.packages_apt_https)}; do",
        "if dpkg-query -s $package > /dev/null 2>&1; then",
          "echo The package $package is already installed.",
        "else",
          "echo The package $package is not installed.",
          "echo Installing package $package.",
          "if sudo apt install -y $package; then",
            "echo The package $package has been installed successfully.",
          "else",
            "echo An error ocurred during the installation process.",
          "fi",
        "fi",
      "done",
      "echo Checking if the GPG key folder exist.",
      "if [ -d '/etc/apt/keyrings' ]; then",
        "echo The directory '/etc/apt/keyrings' already exists.",
      "else",
        "echo The directory '/etc/apt/keyrings' does not exist.",
        "echo Creating the directory '/etc/apt/keyrings'.",
        "if sudo mkdir -m 0755 -p /etc/apt/keyrings; then",
          "echo The directory '/etc/apt/keyrings' has been created successfully.",
        "else",
          "echo An error ocurred during the creation process.",
        "fi",
      "fi",
      "echo Checking if the Docker GPG key exist.",
      "if [ -f '/etc/apt/keyrings/docker.gpg' ]; then",
        "echo The file '/etc/apt/keyrings/docker.gpg' already exists.",
      "else",
        "echo The file '/etc/apt/keyrings/docker.gpg' does not exist.",
        "echo Downloading the file '/etc/apt/keyrings/docker.gpg'.",
        "if curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg; then",
          "echo The file '/etc/apt/keyrings/docker.gpg' has been downloaded.",
        "else",
          "echo An error ocurred during the downloading process.",
        "fi",
      "fi",
      "echo Checking if the Docker repository is configured on the system.",
      "if [ -f '/etc/apt/sources.list.d/docker.list' ]; then",
        "echo The file '/etc/apt/sources.list.d/docker.list' already exists.",
      "else",
        "echo The file '/etc/apt/sources.list.d/docker.list' does not exist.",
        "echo Configuring the Docker repository.",
        "if echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null; then",
          "echo The Docker repository has been configured.",
        "else",
          "echo An error ocurred during the configuration process.",
        "fi",
      "fi"
    ]
  }

  depends_on = [null_resource.uninstall_old_versions]
}

resource "null_resource" "install_docker_engine" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo Checking if the packages exists on the system.",
      "for package in ${join(" ", var.packages_for_docker)}; do",
        "if dpkg-query -s $package > /dev/null 2>&1; then",
          "echo The package $package is already installed",
        "else",
          "echo The package $package is not installed.",
          "echo Installing package $package.",
          "if sudo apt install -y $package; then",
            "echo The package $package has been installed successfully.",
          "else",
            "echo An error ocurred during the installation process.",
          "fi",
        "fi",
      "done",
      "echo Checking if the '/etc/containerd/config.toml' file exist.",
      "if [ -f '/etc/containerd/config.toml' ]; then",
        "echo The file '/etc/containerd/config.toml' already exists",
      "else",
        "echo The file '/etc/containerd/config.toml' does not exist.",
        "echo Creating the file '/etc/containerd/config.toml'.",
        "containerd config default > /tmp/config.toml",
        "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /tmp/config.toml",
        "sudo chmod 644 /tmp/config.toml",
        "sudo chown root:root /tmp/config.toml",
        "sudo mv --force /tmp/config.toml /etc/containerd/",
        "sudo systemctl restart containerd",
        "echo The file '/etc/containerd/config.toml' has been created successfully.",
      "fi"
    ]
  }

  depends_on = [null_resource.setup_docker_repository]
}

##########################################
### Setting Up Networking and Firewall ###
##########################################

resource "null_resource" "forwarding_ipv4_bridge" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "remote-exec" {
    connection {
      type        = var.connection.type
      host        = var.connection.host
      user        = var.connection.user
      private_key = var.private_key
    }

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "echo Checking if the '/etc/modules-load.d/k8s.conf' file exist.",
      "if [ -f '/etc/modules-load.d/k8s.conf' ]; then",
        "echo The file '/etc/modules-load.d/k8s.conf' already exists",
      "else",
        "echo The file '/etc/modules-load.d/k8s.conf' does not exist.",
        "echo Creating the file '/etc/modules-load.d/k8s.conf'.",
        "cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf",
        "overlay",
        "br_netfilter",
        "EOF",
        "sudo modprobe overlay",
        "sudo modprobe br_netfilter",
        "# sysctl params required by setup, params persist across reboots",
        "cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf",
        "net.bridge.bridge-nf-call-iptables  = 1",
        "net.bridge.bridge-nf-call-ip6tables = 1",
        "net.ipv4.ip_forward = 1",
        "EOF",
        "# Apply sysctl params without reboot",
        "sudo sysctl --system",
        "echo The file '/etc/modules-load.d/k8s.conf' has been created successfully.",
      "fi"
    ]
  }

  depends_on = [null_resource.install_docker_engine]
}

# Copy the firewall script to the remote instance
resource "null_resource" "configure_ufw" {
  triggers = {
    build_number = "${timestamp()}"
  }

  connection {
    type        = var.connection.type
    host        = var.connection.host
    user        = var.connection.user
    private_key = var.private_key
  }

  provisioner "file" {
    source      = "${path.module}/artifacts/firewall.sh"
    destination = "/tmp/firewall.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Enabling error checking and debugging options.",
      "set -euxo pipefail",
      "chmod +x /tmp/firewall.sh",
      "/tmp/firewall.sh"
    ]
  }

  depends_on = [null_resource.forwarding_ipv4_bridge]
}
