#!/bin/bash

# Reset the firewall rules
sudo ufw --force reset

# Set default policies to deny all incoming/outgoing traffic
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH access
sudo ufw allow ssh

# Allow HTTP/HTTPS traffic
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow DNS traffic
sudo ufw allow 53/tcp
sudo ufw allow 53/udp

# Allow NTP traffic
sudo ufw allow 123/udp

# Allow established connections to continue
sudo ufw allow established

# Kubernetes Master and Worker Nodes

# Allow incoming traffic for the Kubernetes API server
sudo ufw allow 6443/tcp

# Allow incoming traffic for the etcd server client API
sudo ufw allow 2379:2380/tcp

# Allow incoming traffic for the Kubelet API
sudo ufw allow 10250/tcp

# Allow incoming traffic for the kube-controller-manager
sudo ufw allow 10257/tcp

# Allow incoming traffic for the kube-scheduler
sudo ufw allow 10259/tcp

# Allow incoming traffic for the NodePort Services
sudo ufw allow 30000:32767/tcp

# Calico Network Plugin

# Allow incoming traffic for the Calico networking (BGP)
sudo ufw allow 179/tcp

# Allow incoming traffic for the Calico networking with IP-in-IP enabled (default)
sudo ufw allow proto 4

# Allow incoming traffic for the Calico networking with VXLAN enabled
sudo ufw allow 4789/udp

# Allow incoming traffic for the Calico networking with Typha enabled
sudo ufw allow 5473/tcp

# Allow incoming traffic for the Calico networking with IPv4 Wireguard enabled
sudo ufw allow 51820/udp

# Allow incoming traffic for the Calico networking with IPv6 Wireguard enabled
sudo ufw allow 51821/udp

# MetalLB L2 Operating Mode
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp

# Enable the firewall
sudo ufw --force enable
