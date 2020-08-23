#!/bin/bash
echo $ANYCONNECT_PASSWORD|openconnect $ANYCONNECT_SERVER --user=$ANYCONNECT_USER --no-cert-check -b

sleep 5

iptables -t nat -A PREROUTING -i tun0 -p tcp --dport $RDPPort -j DNAT --to $RDPGateway:3389
iptables -t nat -A POSTROUTING -o tun0 -p tcp -d $RDPGateway --dport 3389 -j MASQUERADE
if [[ ! -z "$LasernetPort" ]]; then
  iptables -t nat -A PREROUTING -i tun0 -p tcp --dport $LasernetPort -j DNAT --to $RDPGateway:3479
  iptables -t nat -A POSTROUTING -o tun0 -p tcp -d $RDPGateway --dport 3479 -j MASQUERADE
fi


iptables -A FORWARD -i eth1 -j ACCEPT

route del -net 172.17.0.0 netmask 255.255.240.0  dev tun0

/bin/bash
