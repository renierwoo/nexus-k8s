#!/bin/bash

# Set error mode to stop the script if there is an error.
set -e

# # Reset the firewall rules
# sudo ufw --force reset

# Verify if the default policy rule 'deny all incoming traffic' exists.
if sudo ufw status verbose | grep "deny (incoming)"; then
  echo "The default policy rule 'deny all incoming traffic' already exists"
else
  echo "Setting the default policy rule 'deny all incoming traffic'"
  sudo ufw default deny incoming
fi

# Verify if the default policy rule 'allow all outgoing traffic' exists.
if sudo ufw status verbose | grep "allow (outgoing)"; then
  echo "The default policy rule 'allow all outgoing traffic' already exists"
else
  echo "Setting the default policy rule 'allow all outgoing traffic'"
  sudo ufw default allow outgoing
fi

# Verify if the policy rule 'allow SSH access' exists.
if sudo ufw status verbose | grep "^22/tcp  "; then
  echo "The policy rule 'allow SSH access' already exists"
else
  echo "Setting the policy rule 'allow SSH access'"
  sudo ufw allow ssh
fi

# Verify if the policy rule 'allow HTTP traffic' exists.
if sudo ufw status verbose | grep "^80/tcp  "; then
  echo "The policy rule 'allow HTTP traffic' already exists"
else
  echo "Setting the policy rule 'allow HTTP traffic'"
  sudo ufw allow 80/tcp
fi

# Verify if the policy rule 'allow HTTPS traffic' exists.
if sudo ufw status verbose | grep "^443/tcp  "; then
  echo "The policy rule 'allow HTTPS traffic' already exists"
else
  echo "Setting the policy rule 'allow HTTPS traffic'"
  sudo ufw allow 443/tcp
fi

# Verify if the policy rule 'allow DNS over tcp traffic' exists.
if sudo ufw status verbose | grep "^53/tcp  "; then
  echo "The policy rule 'allow DNS over tcp traffic' already exists"
else
  echo "Setting the policy rule 'allow DNS over tcp traffic'"
  sudo ufw allow 53/tcp
fi

# Verify if the policy rule 'allow DNS over udp traffic' exists.
if sudo ufw status verbose | grep "^53/udp  "; then
  echo "The policy rule 'allow DNS over udp traffic' already exists"
else
  echo "Setting the policy rule 'allow DNS over udp traffic'"
  sudo ufw allow 53/udp
fi

# Verify if the policy rule 'allow NTP traffic' exists.
if sudo ufw status verbose | grep "^123/udp  "; then
  echo "The policy rule 'allow NTP traffic' already exists"
else
  echo "Setting the policy rule 'allow NTP traffic'"
  sudo ufw allow 123/udp
fi

# # Allow established connections to continue
# sudo ufw allow established

# Kubernetes Master and Worker Nodes

# Verify if the policy rule 'allow incoming traffic for the Kubernetes API server' exists.
if sudo ufw status verbose | grep "^6443/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the Kubernetes API server' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Kubernetes API server'"
  sudo ufw allow 6443/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the etcd server client API' exists.
if sudo ufw status verbose | grep "^2379:2380/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the etcd server client API' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the etcd server client API'"
  sudo ufw allow 2379:2380/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the Kubelet API' exists.
if sudo ufw status verbose | grep "^10250/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the Kubelet API' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Kubelet API'"
  sudo ufw allow 10250/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the kube-controller-manager' exists.
if sudo ufw status verbose | grep "^10257/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the kube-controller-manager' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the kube-controller-manager'"
  sudo ufw allow 10257/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the kube-scheduler' exists.
if sudo ufw status verbose | grep "^10259/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the kube-scheduler' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the kube-scheduler'"
  sudo ufw allow 10259/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the NodePort Services' exists.
if sudo ufw status verbose | grep "^30000:32767/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the NodePort Services' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the NodePort Services'"
  sudo ufw allow 30000:32767/tcp
fi

# Calico Network Plugin

# Verify if the policy rule 'allow incoming traffic for the Calico networking (BGP)' exists.
if sudo ufw status verbose | grep "^179/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the Calico networking (BGP)' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Calico networking (BGP)'"
  sudo ufw allow 179/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the Calico networking with VXLAN enabled' exists.
if sudo ufw status verbose | grep "^4789/udp  "; then
  echo "The policy rule 'allow incoming traffic for the Calico networking with VXLAN enabled' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Calico networking with VXLAN enabled'"
  sudo ufw allow 4789/udp
fi

# # Allow incoming traffic for the Calico networking with IP-in-IP enabled (default)
# sudo ufw allow proto 4

# Verify if the policy rule 'allow incoming traffic for the Calico networking with Typha enabled' exists.
if sudo ufw status verbose | grep "^5473/tcp  "; then
  echo "The policy rule 'allow incoming traffic for the Calico networking with Typha enabled' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Calico networking with Typha enabled'"
  sudo ufw allow 5473/tcp
fi

# Verify if the policy rule 'allow incoming traffic for the Calico networking with IPv4 Wireguard enabled' exists.
if sudo ufw status verbose | grep "^51820/udp  "; then
  echo "The policy rule 'allow incoming traffic for the Calico networking with IPv4 Wireguard enabled' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Calico networking with IPv4 Wireguard enabled'"
  sudo ufw allow 51820/udp
fi

# Verify if the policy rule 'allow incoming traffic for the Calico networking with IPv6 Wireguard enabled' exists.
if sudo ufw status verbose | grep "^51821/udp  "; then
  echo "The policy rule 'allow incoming traffic for the Calico networking with IPv6 Wireguard enabled' already exists"
else
  echo "Setting the policy rule 'allow incoming traffic for the Calico networking with IPv6 Wireguard enabled'"
  sudo ufw allow 51821/udp
fi

# Verify if the policy rule 'allow MetalLB L2 Operating Mode over tcp' exists.
if sudo ufw status verbose | grep "^7946/tcp  "; then
  echo "The policy rule 'allow MetalLB L2 Operating Mode over tcp' already exists"
else
  echo "Setting the policy rule 'allow MetalLB L2 Operating Mode over tcp'"
  sudo ufw allow 7946/tcp
fi

# Verify if the policy rule 'allow MetalLB L2 Operating Mode over udp' exists.
if sudo ufw status verbose | grep "^7946/udp  "; then
  echo "The policy rule 'allow MetalLB L2 Operating Mode over udp' already exists"
else
  echo "Setting the policy rule 'allow MetalLB L2 Operating Mode over udp'"
  sudo ufw allow 7946/udp
fi

# Verify if the firewall is active.
if sudo ufw status verbose | grep "Status: active"; then
  echo "The firewall is already active"
else
  echo "The firewall is disabled, enabling it now..."
  sudo ufw --force enable
fi
