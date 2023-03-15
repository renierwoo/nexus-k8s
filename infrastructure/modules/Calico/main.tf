# The primary use-case for the null resource is as a do-nothing container
# for arbitrary actions taken by a provisioner.

resource "null_resource" "install_calico_calicoctl" {

  # Changes to the build_number variable require re-execution of the tasks on the VPS.
  triggers = {
    build_number = "${timestamp()}"
  }

  connection {
    type        = var.connection.type
    host        = var.connection.host
    user        = var.connection.user
    private_key = var.private_key
    # private_key = "${file(var.connection.private_key)}"
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
      "kubectl create -f /tmp/tigera-operator.yaml",
      "kubectl create -f /tmp/custom-resources.yaml",
      # Remove the taints on the master so that you can schedule pods on it.
      "kubectl taint nodes --all node-role.kubernetes.io/control-plane-",
      "kubectl taint nodes --all node-role.kubernetes.io/master-",
      "curl -L https://github.com/projectcalico/calico/releases/latest/download/calicoctl-linux-amd64 -o calicoctl",
      "sudo chmod +x ./calicoctl",
      "sudo mv ./calicoctl /usr/local/bin/"
    ]
  }
}
