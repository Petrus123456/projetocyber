#!/bin/bash

echo "========================================="
echo " CONFIGURANDO FIREWALL DO PROJETO CYBER"
echo "========================================="

echo "[1/5] Ativando IP Forward no firewall..."
podman exec firewall bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

echo "[2/5] Configurando rotas nos containers..."

podman exec attacker ip route replace 10.10.20.0/24 via 10.10.10.254
podman exec attacker ip route replace 10.10.30.0/24 via 10.10.10.254

podman exec dvwa ip route replace 10.10.10.0/24 via 10.10.20.254
podman exec dvwa ip route replace 10.10.30.0/24 via 10.10.20.254

podman exec db sh -c "/sbin/ip route replace 10.10.10.0/24 via 10.10.30.254"
podman exec db sh -c "/sbin/ip route replace 10.10.20.0/24 via 10.10.30.254"

echo "[3/5] Limpando regras antigas..."

podman exec firewall bash -c "
iptables -F
iptables -t nat -F

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
"

echo "[4/5] Aplicando regras de firewall..."

podman exec firewall bash -c "
iptables -A FORWARD -s 10.10.10.0/24 -d 10.10.20.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 10.10.20.0/24 -d 10.10.10.0/24 -p tcp --sport 80 -j ACCEPT

iptables -A FORWARD -s 10.10.10.0/24 -d 10.10.30.0/24 -p tcp --dport 3306 -j DROP

iptables -A FORWARD -s 10.10.20.0/24 -d 10.10.30.0/24 -p tcp --dport 3306 -j ACCEPT
iptables -A FORWARD -s 10.10.30.0/24 -d 10.10.20.0/24 -p tcp --sport 3306 -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -d 10.10.20.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.10.20.0/24 -d 10.10.30.0/24 -j MASQUERADE
"

echo "[5/5] Regras aplicadas:"
podman exec firewall iptables -L FORWARD -v -n --line-numbers

echo ""
echo "========================================="
echo " FIREWALL CONFIGURADO COM SUCESSO"
echo "========================================="
