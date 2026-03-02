# Functions — sourced from zshrc

# Create a directory and cd into it
mkcd() { mkdir -p "$@" && cd "$_" }

# Fix route to devices behind VPN when there's a subnet conflict (macOS)
vpn-fix() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "vpn-fix is macOS only"
    return 1
  fi

  local iface
  iface=$(ifconfig | awk '/^utun/{iface=$1} /10\.10\.10\./{gsub(/:$/,"",iface); print iface}')

  if [[ -z "$iface" ]]; then
    echo "WireGuard interface not found — is VPN connected?"
    return 1
  fi

  if netstat -rn | grep -q "192.168.1 \+${iface}"; then
    echo "Route already set (192.168.1.0/24 → $iface)"
    return 0
  fi

  sudo -v -p "sudo password required to add route: " && \
  sudo route add 192.168.1.0/24 -interface "$iface" &>/dev/null && \
  echo "✓ Route added: 192.168.1.0/24 → $iface"
}
