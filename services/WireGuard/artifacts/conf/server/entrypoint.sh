#!/bin/sh

# Check if the WireGuard configuration file is present
if [ ! -f /etc/wireguard/wg0.conf ]; then
  echo "Error: WireGuard configuration file not found at /etc/wireguard/wg0.conf"
  exit 1
fi

# Start the WireGuard interface and enable logging.
wg-quick up wg0 > /var/log/wireguard.log 2>&1

# Display WireGuard logs
tail -f /var/log/wireguard.log
