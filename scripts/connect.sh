#!/bin/bash

echo "Build VPN connection to" "$ANYCONNECT_SERVER"
echo "Build VPN connection with user" "$ANYCONNECT_USER"
echo "Build VPN connection with Servercert" "$ServerCert"

if [[ ! -z "$ServerCert" ]]; then 
  echo $ANYCONNECT_PASSWORD|openconnect $ANYCONNECT_SERVER --user=$ANYCONNECT_USER --servercert $ServerCert
else
  echo $ANYCONNECT_PASSWORD|openconnect $ANYCONNECT_SERVER --user=$ANYCONNECT_USER
fi

sleep 5

nft -f /etc/nftables/ipv4-nat;

nft add table nat;
nft add chain nat post { type nat hook postrouting priority 0 \; }
nft add chain nat pre { type nat hook prerouting priority 0 \; }
nft add rule nat postrouting masquerade random;

nft add rule nat post iif eth0 oif tun0 snat $RDPGateway;
nft add rule nat pre tcp dport 3389 iif eth0 dnat $RDPGateway:3389;
echo "Build RDP Forward to Server" "$RDPGateway"
echo "Build RDP Forward and publish this via port" "$RDPPort"
if [[ ! -z "$LasernetPort" ]]; then 
  nft add rule nat pre tcp dport $LasernetPort iif eth0 dnat $RDPGateway:3479;
  echo "Build Lasernet Forward and publish this via port" "$LasernetPort"
fi

nft add rule filter iif eth0 oif tun0 accept
iptables -A FORWARD -i eth1 -j ACCEPT

route del -net 172.17.0.0 netmask 255.255.240.0  dev tun0

/bin/bash
