#!/bin/bash

echo "[+] Aplicando regras de firewall..."

# bloquear attacker -> db
iptables -A FORWARD -s 10.89.7.0/24 -d 10.89.6.0/24 -j DROP

# permitir dvwa -> db
iptables -A FORWARD -s 10.89.8.0/24 -d 10.89.6.0/24 -j ACCEPT

echo "[+] Firewall aplicado"
