resource "null_resource" "disable_swap" {
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
      "set -eux",
      "echo Checking if swap is disabled",
      "if sudo cat /proc/swaps; then",
        "echo Swap usage is disabled",
      "else",
        "echo Swap usage is enabled",
        "echo Disabling swap usage.",
        "if sudo swapoff -a; then",
          "echo Swap usage disabled successfully.",
        "else",
          "echo An error ocurred during the disable process.",
        "fi",
        "echo Disabling swap usage permanently.",
        "if sudo sed -i -e '/swap/d' /etc/fstab; then",
          "echo Swap usage disabled permanently.",
        "else",
          "echo An error ocurred during the disable process.",
        "fi",
      "fi"
    ]
  }
}

resource "null_resource" "install_kubeadm_packages" {
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
      "set -eux",
      "echo Updating package list.",
      "if sudo apt update; then",
        "echo The package list has been updated.",
      "else",
        "echo An error ocurred during the update process",
      "fi",
      "echo Checking if the packages exists on the system.",
      "for package in apt-transport-https ca-certificates curl; do",
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
      "echo Checking if the kubernetes-archive-keyring GPG key exist.",
      "if [ -f '/etc/apt/keyrings/kubernetes-archive-keyring.gpg' ]; then",
        "echo The file '/etc/apt/keyrings/kubernetes-archive-keyring.gpg' already exists.",
      "else",
        "echo The file '/etc/apt/keyrings/kubernetes-archive-keyring.gpg' does not exist.",
        "echo Downloading the file '/etc/apt/keyrings/kubernetes-archive-keyring.gpg'.",
        "if curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg; then",
          "echo The file '/etc/apt/keyrings/kubernetes-archive-keyring.gpg' has been downloaded.",
        "else",
          "echo An error ocurred during the downloading process.",
        "fi",
      "fi",
      "echo Checking if the Kubernetes repository is configured on the system.",
      "if [ -f '/etc/apt/sources.list.d/kubernetes.list' ]; then",
        "echo The file '/etc/apt/sources.list.d/kubernetes.list' already exists.",
      "else",
        "echo The file '/etc/apt/sources.list.d/kubernetes.list' does not exist.",
        "echo Configuring the Kubernetes repository.",
        "if echo deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null; then",
          "echo The Kubernetes repository has been configured.",
        "else",
          "echo An error ocurred during the configuration process.",
        "fi",
      "fi",
      "echo Updating package list.",
      "if sudo apt update; then",
        "echo The package list has been updated.",
      "else",
        "echo An error ocurred during the update process",
      "fi",
      "echo Checking if the packages exists on the system.",
      "for package in kubelet kubeadm kubectl; do",
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
        "echo Holding package versions.",
        "if sudo apt-mark hold $package; then",
          "echo Package $package has been held successfully.",
        "else",
          "echo An error ocurred during the holding process.",
        "fi",
      "done"
    ]
  }

  depends_on = [null_resource.disable_swap]
}

resource "null_resource" "enabling_unsafe_sysctls" {
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
      "echo Checking if the '/etc/default/' folder exist.",
      "if [ -d '/etc/default/' ]; then",
        "echo The directory '/etc/default/' already exists.",
      "else",
        "echo The directory '/etc/default/' does not exist.",
        "echo Creating the directory '/etc/default/'.",
        "if sudo mkdir -p /etc/default/; then",
          "echo The directory '/etc/default/' has been created successfully.",
        "else",
          "echo An error ocurred during the creation process.",
        "fi",
      "fi",
      "echo Checking if the '/etc/default/kubelet' file exists.",
      "if [ -f '/etc/default/kubelet' ]; then",
        "echo The file '/etc/default/kubelet' already exists.",
          "if grep -q 'KUBELET_EXTRA_ARGS=--allowed-unsafe-sysctls net.ipv4.ip_forward' /etc/default/kubelet; then",
            "echo The unsafe sysctl 'net.ipv4.ip_forward' is already configured.",
          "else",
            "echo The unsafe sysctl 'net.ipv4.ip_forward' is not configured.",
            "echo Configuring the unsafe sysctl 'net.ipv4.ip_forward'.",
            "if echo KUBELET_EXTRA_ARGS=--allowed-unsafe-sysctls net.ipv4.ip_forward | sudo tee /etc/default/kubelet; then",
              "echo The unsafe sysctl 'net.ipv4.ip_forward' has been configured successfully.",
            "else",
              "echo An error ocurred during the configuration process.",
            "fi",
          "fi",
      "else",
        "echo The file '/etc/default/kubelet' does not exist.",
        "echo Creating the file '/etc/default/kubelet' and configuring the unsafe sysctl 'net.ipv4.ip_forward'.",
        "if echo KUBELET_EXTRA_ARGS=--allowed-unsafe-sysctls net.ipv4.ip_forward | sudo tee /etc/default/kubelet; then",
          "echo The file '/etc/default/kubelet' and the unsafe sysctl 'net.ipv4.ip_forward' have been created successfully.",
        "else",
          "echo An error ocurred during the creation process.",
        "fi",
      "fi",
    ]
  }

  depends_on = [null_resource.install_kubeadm_packages]
}

resource "null_resource" "init_k8s" {
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
      "echo Checking if the Kubernetes is already initialized.",
      "if [ -d '/etc/kubernetes/' ] && [ -f '/etc/kubernetes/admin.conf' ] && kubectl get nodes > /dev/null 2>1; then",
        "echo The Kubernetes cluster is already initialized.",
      "else",
        "echo Initializing the Kubernetes cluster.",
        "if sudo kubeadm init --pod-network-cidr=10.244.0.0/16; then",
          "echo The Kubernetes cluster has been initialized successfully.",
        "else",
          "echo An error ocurred during the initialization process.",
        "fi",
      "fi",
      "echo Checking if the '.kube' folder exists.",
      "if [ -d '$HOME/.kube' ]; then",
        "echo The '.kube' folder already exists.",
      "else",
        "echo The '.kube' folder does not exist.",
        "echo Creating the '.kube' folder.",
        "if mkdir -p $HOME/.kube; then",
          "echo The '.kube' folder has been created successfully.",
        "else",
          "echo An error ocurred during the creation process.",
        "fi",
      "fi",
      "echo Checking if the 'config' file exists.",
      "if [ -f '$HOME/.kube/config' ]; then",
        "echo The 'config' file already exists.",
      "else",
        "echo The 'config' file does not exist.",
        "echo Creating the 'config' file.",
        "if sudo cp --force /etc/kubernetes/admin.conf $HOME/.kube/config; then",
          "echo The 'config' file has been created successfully.",
        "else",
          "echo An error ocurred during the creation process.",
        "fi",
      "fi",
      "echo Checking if the 'config' file is owned by the current user.",
      "if [ $(stat -c '%u:%g' $HOME/.kube/config) = $(id -u):$(id -g) ]; then",
        "echo The 'config' file is owned by the current user.",
      "else",
        "echo The 'config' file is not owned by the current user.",
        "echo Changing the ownership of the 'config' file.",
        "if sudo chown $(id -u):$(id -g) $HOME/.kube/config; then",
          "echo The ownership of the 'config' file has been changed successfully.",
        "else",
          "echo An error ocurred during the ownership change process.",
        "fi",
      "fi",
    ]
  }

  depends_on = [null_resource.enabling_unsafe_sysctls]
}

resource "null_resource" "install_helm" {
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
      "echo Checking if the 'helm' command is already installed.",
      "if helm version > /dev/null 2>1; then",
        "echo The 'helm' command is already installed.",
      "else",
        "echo The 'helm' command is not installed.",
        "echo Downloading the 'helm' script.",
        "if curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3; then",
          "echo The 'helm' script has been downloaded successfully.",
        "else",
          "echo An error ocurred during the downloading process.",
        "fi",
      "fi",
      "echo Checking if the 'get_helm.sh' file has type 700 permissions.",
      "if [ $(stat -c '%a' $FILE) -eq 700 ]; then",
        "echo The 'get_helm.sh' file has type 700 permissions.",
      "else",
        "echo The 'get_helm.sh' file has not type 700 permissions.",
        "echo Changing the permissions of the 'get_helm.sh' file.",
        "if chmod 700 get_helm.sh; then",
          "echo The permissions of the 'get_helm.sh' file have been changed successfully.",
        "else",
          "echo An error ocurred during the permissions change process.",
        "fi",
      "fi",
      "echo Installing the 'helm' command.",
      "if ./get_helm.sh; then",
        "echo The 'helm' command has been installed successfully.",
      "else",
        "echo An error ocurred during the installation process.",
      "fi",
    ]
  }

  depends_on = [null_resource.init_k8s]
}
