#!/bin/bash
echo $ANYCONNECT_PASSWORD|openconnect $ANYCONNECT_SERVER --user=$ANYCONNECT_USER --no-cert-check -b

sleep 5

iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 803389 -j DNAT --to 10.0.2.51:3389
iptables -t nat -A POSTROUTING -o tun0 -p tcp -d 10.0.2.51 --dport 3389 -j MASQUERADE

iptables -A FORWARD -i eth1 -j ACCEPT

route del -net 172.17.0.0 netmask 255.255.240.0  dev tun0

/bin/bash
