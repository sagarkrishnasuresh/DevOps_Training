# Networking Basics Notes

## Common Commands:

### Interface Information
- Check network interface status:
  ```bash
  ip link
  ```

### IP Address Information
- View IP addresses assigned to interfaces:
  ```bash
  ip addr
  ```

### Assign IP Address
- Assign an IP address to an interface (`eth0` in this example):
  ```bash
  ip addr add 192.168.1.10/24 dev eth0
  ```

### Routing Table Information
- Display the routing table:
  ```bash
  ip route
  ```

### Add Route
- Add a new route via a gateway:
  ```bash
  ip route add 192.168.1.0/24 via 192.168.2.1
  ```

- Alternative command to show routing:
  ```bash
  route
  ```

### IP Forwarding
- Check if IP forwarding is enabled (`1` means enabled, `0` means disabled):
  ```bash
  cat /proc/sys/net/ipv4/ip_forward
  ```

## Notes:

- **`ip link`** is used to manage network interfaces.
- **`ip addr`** manages IP addresses and their assignment.
- **`ip route`** manages routing tables, which determine how packets traverse the network.
- **IP forwarding** allows the machine to route packets between networks; typically required for routers and gateways.


