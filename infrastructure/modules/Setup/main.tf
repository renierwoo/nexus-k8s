# The primary use-case for the null resource is as a do-nothing container
# for arbitrary actions taken by a provisioner.

#####################
### Initial Setup ###
#####################

resource "null_resource" "update_system" {

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
    }

    inline = [
      "# Update the package list.",
      "sudo apt update",
      "# Upgrade all packages to the latest version.",
      "sudo apt full-upgrade -y",
      "# Remove all the deprecated packages from the system.",
      "sudo apt autoremove -y"
    ]
  }
}

resource "null_resource" "set_hostname" {

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
    }

    inline = [
      "# Set the return variable to 0.",
      "RETVAL=0",
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "# Verify if the hostname is already set.",
      "if hostnamectl hostname | grep '${var.hostname}'; then",
        "echo 'Already changed'",
      "else",
        "# If the hostname is not set, run the command to set it.",
        "sudo hostnamectl set-hostname ${var.hostname}",
      "fi",
      "# Exit from script with the appropriate return variable.",
      "exit $RETVAL"
    ]
  }

  depends_on = [null_resource.update_system]
}


resource "null_resource" "set_hosts" {

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
    }

    inline = [
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "# Verify if the domain is already set.",
      "if cat /etc/hosts | grep '127.0.1.1' | grep '${var.domain}'; then",
        "echo 'Already changed'",
      "else",
        "# If the domain is not set, run the command to set it.",
        "sudo sed -i '/127.0.1.1/ s/$/ ${var.domain}/' /etc/hosts",
      "fi",
      "# Verify if the domain is already set.",
      "if cat /etc/hosts | grep '${var.connection.host}' | grep '${var.domain}'; then",
        "echo 'Already changed'",
      "else",
        "# If the domain is not set, run the command to set it.",
        "else sudo sed -i '/${var.connection.host}/ s/$/ ${var.domain}/' /etc/hosts",
      "fi"
    ]
  }

  depends_on = [null_resource.set_hostname]
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
    }

    inline = [
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "# Verify if an old version of the package exists in the system.",
      "for package in ${join(" ", var.old_package_versions)}; do",
        "if dpkg-query -s $package > /dev/null 2>&1; then",
          "echo The package $package is already installed",
          "sudo apt remove -y $package",
          "echo The package $package has been uninstalled successfully",
        "else",
          "echo The package $package is not installed",
        "fi",
      "done"
    ]
  }

  depends_on = [null_resource.set_hosts]
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
    }

    inline = [
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "# Verify if a package is installed and if not proceed with its installation.",
      "for package in ${join(" ", var.packages_apt_https)}; do",
        "if dpkg-query -s $package > /dev/null 2>&1; then",
          "echo The package $package is already installed",
        "else",
          "echo Installing package $package",
          "sudo apt install -y $package",
          "echo The package $package has been installed successfully",
        "fi",
      "done",
      "# Verify if the GPG key folder exist.",
      "if [ -d '/etc/apt/keyrings' ]; then",
        "echo The directory '/etc/apt/keyrings' already exists",
      "else",
        "echo The directory '/etc/apt/keyrings' does not exist, creating it now ...",
        "sudo mkdir -m 0755 -p /etc/apt/keyrings",
        "echo The directory '/etc/apt/keyrings' has been created successfully",
      "fi",
      "# Verify if the Docker GPG key exist.",
      "if [ -f '/etc/apt/keyrings/docker.gpg' ]; then",
        "echo The file '/etc/apt/keyrings/docker.gpg' already exists",
      "else",
        "echo The file '/etc/apt/keyrings/docker.gpg' does not exist, downloading it now ...",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg",
      "fi",
      "# Verify if the Docker repository is configured in the system.",
      "if [ -f '/etc/apt/sources.list.d/docker.list' ]; then",
        "echo The file '/etc/apt/sources.list.d/docker.list' already exists",
      "else",
        "echo The file '/etc/apt/sources.list.d/docker.list' does not exist, configuring the Docker repository now ...",
        "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "fi"
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
    }

    inline = [
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "# Verify if the packages exists in the system.",
      "for package in ${join(" ", var.packages_for_docker)}; do",
        "if dpkg-query -s $package > /dev/null 2>&1; then",
          "echo The package $package is already installed",
        "else",
          "echo Installing package $package",
          "sudo apt install -y $package",
        "fi",
      "done",
      "# Verify if the '/etc/containerd/config.toml' file exist.",
      "if [ -f '/etc/containerd/config.toml' ]; then",
        "echo The file '/etc/containerd/config.toml' already exists",
      "else",
        "echo The file '/etc/containerd/config.toml' does not exist, creating it now ...",
        "containerd config default > /tmp/config.toml",
        "sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /tmp/config.toml",
        "sudo chmod 644 /tmp/config.toml",
        "sudo chown root:root /tmp/config.toml",
        "sudo mv --force /tmp/config.toml /etc/containerd/",
        "sudo systemctl restart containerd",
      "fi"
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
    }

    inline = [
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "# Verify if the '/etc/modules-load.d/k8s.conf' file exist.",
      "if [ -f '/etc/modules-load.d/k8s.conf' ]; then",
        "echo The file '/etc/modules-load.d/k8s.conf' already exists",
      "else",
        "echo The file '/etc/modules-load.d/k8s.conf' does not exist, creating it now ...",
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
      "fi"
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
  }

  provisioner "file" {

    source      = "${path.module}/artifacts/firewall.sh"
    destination = "/tmp/firewall.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "# Set error mode to stop the script if there is an error.",
      "set -e",
      "chmod +x /tmp/firewall.sh",
      "/tmp/firewall.sh"
    ]
  }

  depends_on = [null_resource.forwarding_ipv4_bridge]
}
