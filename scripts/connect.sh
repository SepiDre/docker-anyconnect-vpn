#!/bin/bash

echo "Build VPN connection to" "$ANYCONNECT_SERVER"
echo "Build VPN connection with user" "$ANYCONNECT_USER"
echo "Build VPN connection with Servercert" "$ServerCert"


echo $ANYCONNECT_PASSWORD|openconnect $ANYCONNECT_SERVER --user=$ANYCONNECT_USER --servercert $ServerCert

sleep 5
sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A PREROUTING -i tun0 -p tcp --dport $RDPPort -j DNAT --to $RDPGateway:3389
iptables -t nat -A POSTROUTING -o tun0 -p tcp -d $RDPGateway --dport 3389 -j MASQUERADE
echo "Build RDP Forward to Server" "$RDPGateway"
echo "Build RDP Forward and publish this via port" "$RDPPort"
if [[ ! -z "$LasernetPort" ]]; then
  iptables -t nat -A PREROUTING -i tun0 -p tcp --dport $LasernetPort -j DNAT --to $RDPGateway:3479
  iptables -t nat -A POSTROUTING -o tun0 -p tcp -d $RDPGateway --dport 3479 -j MASQUERADE
  echo "Build Lasernet Forward and publish this via port" "$LasernetPort"
fi


iptables -A FORWARD -i eth1 -j ACCEPT

route del -net 172.17.0.0 netmask 255.255.240.0  dev tun0

/bin/bash
