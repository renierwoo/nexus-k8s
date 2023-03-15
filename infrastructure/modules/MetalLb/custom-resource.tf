# resource "kubectl_manifest" "metal_lb_ipaddresspool" {
#   yaml_body = <<EOF
# apiVersion: metallb.io/v1beta1
# kind: IPAddressPool
# metadata:
#   name: metallb-pool
#   namespace: metallb-system
# spec:
#   addresses:
#     - ${var.connection.host}/32
#   autoAssign: true
#   avoidBuggyIPs: true
# EOF
# }

# resource "kubectl_manifest" "metal_lb_l2advertisement" {
#   yaml_body = <<EOF
# apiVersion: metallb.io/v1beta1
# kind: L2Advertisement
# metadata:
#   name: metallb-l2-config
#   namespace: metallb-system
# spec:
#   ipAddressPools:
#     - metallb-pool
# EOF
# }

# data "template_file" "metal_lb_ipaddresspool" {
#   template = <<EOF
# apiVersion: metallb.io/v1beta1
# kind: IPAddressPool
# metadata:
#   name: metallb-pool
#   namespace: metallb-system
# spec:
#   addresses:
#     - ${var.connection.host}/32
#   autoAssign: true
#   avoidBuggyIPs: true
# EOF
# }

# data "template_file" "metal_lb_l2advertisement" {
#   template = <<EOF
# apiVersion: metallb.io/v1beta1
# kind: L2Advertisement
# metadata:
#   name: metallb-l2-config
#   namespace: metallb-system
# spec:
#   ipAddressPools:
#     - metallb-pool
# EOF
# }

# The primary use-case for the null resource is as a do-nothing container
# for arbitrary actions taken by a provisioner.

# resource "null_resource" "metallb_custom_resources" {

#   # Changes to the build_number variable require re-execution of the tasks on the VPS.
#   triggers = {
#     build_number = "${timestamp()}"
#   }

#   provisioner "remote-exec" {

#     connection {
#       type        = var.connection.type
#       host        = var.connection.host
#       user        = var.connection.user
#       private_key = "${file(var.connection.private_key)}"
#     }

#     inline = [
#       "echo '${data.template_file.metal_lb_ipaddresspool.rendered}' | kubectl apply -f -",
#       "echo '${data.template_file.metal_lb_l2advertisement.rendered}' | kubectl apply -f -"
#     ]
#   }
# }

# data "template_file" "metal_lb_ipaddresspool" {
#   template = "${file("ipaddresspool.tpl")}"

#   vars = {
#     host = var.connection.host
#   }
# }

# data "template_file" "metal_lb_l2advertisement" {
#   template = "${file("l2advertisement.tpl")}"
# }

# The primary use-case for the null resource is as a do-nothing container
# for arbitrary actions taken by a provisioner.

resource "null_resource" "metallb_custom_resources" {

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
      "cat <<EOF | kubectl apply -f -",
      templatefile(("${path.module}/artifacts/ipaddresspool.yaml"), { host = var.connection.host }),
      "EOF",
      "cat <<EOF | kubectl apply -f -",
      templatefile(("${path.module}/artifacts/l2advertisement.yaml"), { host = var.connection.host }),
      "EOF"
      # "sed 's/%%VAR1%%/${data.template_file.metal_lb_ipaddresspool.host}/g ipaddresspool.yaml | kubectl apply -f -",
      # "sed 's/%%VAR1%%/${data.template_file.metal_lb_ipaddresspool.host}/g ipaddresspool.yaml | kubectl apply -f -"
    ]
  }

  depends_on = [helm_release.metal_lb]
}
