resource "null_resource" "install_calico_calicoctl" {
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
    source      = "${path.module}/artifacts/tigera-operator.yaml"
    destination = "/tmp/tigera-operator.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/artifacts/custom-resources.yaml"
    destination = "/tmp/custom-resources.yaml"
  }

  provisioner "remote-exec" {

    inline = [
      "echo Enabling error checking and debugging options.",
      "set -eux",
      "echo Checking if Tigera-Operator is already installed.",
      "if kubectl get crd installations.operator.tigera.io; then",
        "echo Tigera-Operator is already installed. Skipping installation.",
      "else",
        "echo Tigera-Operator is not installed.",
        "echo Installing Tigera-Operator.",
        "kubectl create -f /tmp/tigera-operator.yaml",
        "echo Tigera-Operator installed.",
      "fi",
      "echo Checking if custom-resources is already installed.",
      "if kubectl get installation default; then",
        "echo Custom-resources is already installed. Skipping installation.",
      "else",
        "echo Custom-resources is not installed.",
        "echo Installing custom-resources.",
        "kubectl create -f /tmp/custom-resources.yaml",
        "echo Custom-resources installed.",
      "fi",
      "echo Checking if the master is tainted.",
      "if kubectl get nodes -o json | jq '.items[] | select(.spec.taints != null) | .spec.taints[] | select(.key == \"node-role.kubernetes.io/master\")'; then",
        "echo The master is tainted.",
        "echo Removing the taints on the master so that you can schedule pods on it.",
        "kubectl taint nodes --all node-role.kubernetes.io/control-plane-",
        "kubectl taint nodes --all node-role.kubernetes.io/master-",
      "else",
        "echo The master is not tainted. Skipping removal of taints.",
      "fi",
      "echo Checking if calicoctl is already installed.",
      "if calicoctl version; then",
        "echo calicoctl is already installed. Skipping installation.",
      "else",
        "echo calicoctl is not installed.",
        "echo Installing calicoctl.",
        "if curl -L https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64 -o calicoctl; then",
          "echo calicoctl downloaded.",
        "else",
          "An error ocurred during the removal process",
        "fi",
        "echo Checking if calicoctl is executable.",
        "if [ -x ./calicoctl ]; then",
          "echo calicoctl is executable. Skipping chmod.",
        "else",
          "echo calicoctl is not executable. Changing permissions.",
          "sudo chmod +x ./calicoctl",
        "fi",
        "echo Checking if calicoctl is in /usr/local/bin.",
        "if [ -f /usr/local/bin/calicoctl ]; then",
          "echo calicoctl is in /usr/local/bin. Skipping mv.",
        "else",
          "echo Moving calicoctl to /usr/local/bin.",
          "sudo mv ./calicoctl /usr/local/bin/",
        "fi",
      "fi",
    ]
  }
}
