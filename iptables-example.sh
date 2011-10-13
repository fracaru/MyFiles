#!/bin/bash

# Flush all chains
iptables -F

# Delete non standards chains
iptables -X

# Drop all packets
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Accept local interface
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow DNS (port 53)
iptables -A INPUT  -i eth0 --protocol udp --source-port 53 -j ACCEPT
iptables -A OUTPUT -o eth0 --protocol udp --destination-port 53 -j ACCEPT
iptables -A INPUT  -i eth0 --protocol tcp --source-port 53 -j ACCEPT
iptables -A OUTPUT -o eth0 --protocol tcp --destination-port 53 -j ACCEPT 

# Allow port 80 (http)
iptables -A INPUT  -i eth0 --protocol tcp --source-port 80 -j ACCEPT
iptables -A OUTPUT -o eth0 --protocol tcp --destination-port 80 -j ACCEPT

# Allow ssh (22)
iptables -A OUTPUT -o eth0 -p tcp --sport 22 -j ACCEPT
iptables -A INPUT  -i eth0 -p tcp --dport 22 -j ACCEPT


# Allow smpt (25)
iptables -A OUTPUT -p tcp --dport 25 -o eth0 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --sport 25 -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow application server (ports 80, 443, 8080, 8443)
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -j ACCEPT
iptables -A INPUT  -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 8080 -j ACCEPT
iptables -A INPUT  -i eth0 -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443 -j ACCEPT
iptables -A INPUT  -i eth0 -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 8443 -j ACCEPT
iptables -A INPUT  -i eth0 -p tcp --dport 8443 -j ACCEPT


iptables -A INPUT -j LOG --log-prefix "INPUT : " --log-level 4
iptables -A OUTPUT -j LOG --log-prefix "OUTPUT : " --log-level 4
iptables -A FORWARD -j LOG --log-prefix "TRANSFER : " --log-level 4

# redirection port 443 -> 8443
iptables -t nat -A PREROUTING -j REDIRECT -p tcp --destination-port 443 --to-ports 8443

# Allow ICMP output
iptables -A OUTPUT -p icmp --icmp-type 8 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0 -m state --state ESTABLISHED,RELATED -j ACCEPT
#Allow ssh output
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

