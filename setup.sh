#!/bin/bash

set -e

clear

echo "========================================="
echo " PROJETO CYBER LAB - SETUP AUTOMATICO"
echo "========================================="
echo ""

PROJECT_NAME=$(basename "$PWD")

EXTERNAL_NET="${PROJECT_NAME}_external_net"
DMZ_NET="${PROJECT_NAME}_dmz_net"
INTERNAL_NET="${PROJECT_NAME}_internal_net"

echo "[1/8] Verificando arquivos necessários..."

if [ ! -f "podman-compose.yml" ]; then
    echo "[ERRO] Arquivo podman-compose.yml não encontrado."
    exit 1
fi

if [ ! -f "firewall.sh" ]; then
    echo "[ERRO] Arquivo firewall.sh não encontrado."
    exit 1
fi

if [ ! -f "test.sh" ]; then
    echo "[ERRO] Arquivo test.sh não encontrado."
    exit 1
fi

echo "[OK] Arquivos encontrados."

echo ""
echo "[2/8] Verificando Podman e podman-compose..."

if ! command -v podman >/dev/null 2>&1; then
    echo "[ERRO] Podman não está instalado."
    exit 1
fi

if ! command -v podman-compose >/dev/null 2>&1; then
    echo "[ERRO] podman-compose não está instalado."
    exit 1
fi

echo "[OK] Podman e podman-compose encontrados."

echo ""
echo "[3/8] Limpando ambiente antigo..."

podman-compose down >/dev/null 2>&1 || true
podman rm -f firewall dvwa db attacker >/dev/null 2>&1 || true
podman network rm "$EXTERNAL_NET" "$DMZ_NET" "$INTERNAL_NET" >/dev/null 2>&1 || true
podman network prune -f >/dev/null 2>&1 || true

echo "[OK] Ambiente limpo."

echo ""
echo "[4/8] Subindo containers..."

podman-compose up -d

echo ""
echo "[5/8] Conectando firewall nas redes DMZ e interna..."

podman network connect --ip 10.10.20.254 "$DMZ_NET" firewall >/dev/null 2>&1 || true
podman network connect --ip 10.10.30.254 "$INTERNAL_NET" firewall >/dev/null 2>&1 || true

echo "[OK] Firewall conectado nas redes."

echo ""
echo "[6/8] Instalando dependências nos containers..."

echo "[+] Firewall..."
podman exec firewall bash -c "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y iptables iproute2 curl netcat-openbsd"

echo "[+] Attacker..."
podman exec attacker bash -c "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y iproute2 curl netcat-openbsd"

echo "[+] DVWA..."
podman exec dvwa bash -c "cat > /etc/apt/sources.list << 'APT_EOF'
deb [trusted=yes] http://archive.debian.org/debian stretch main contrib non-free
deb [trusted=yes] http://archive.debian.org/debian-security stretch/updates main contrib non-free
APT_EOF"

podman exec dvwa bash -c "cat > /etc/apt/apt.conf.d/99archive << 'APTCONF_EOF'
Acquire::Check-Valid-Until \"false\";
Acquire::AllowInsecureRepositories \"true\";
APT::Get::AllowUnauthenticated \"true\";
APTCONF_EOF"

podman exec dvwa bash -c "apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true || true"
podman exec dvwa bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated iproute2"

echo "[+] Database..."
podman exec db sh -c "yum install -y iproute nmap-ncat"

echo "[OK] Dependências instaladas."

echo ""
echo "[7/8] Aplicando regras do firewall..."

chmod +x firewall.sh
./firewall.sh

echo ""
echo "[8/8] Executando testes automatizados..."

chmod +x test.sh
./test.sh

echo ""
echo "========================================="
echo " SETUP FINALIZADO"
echo "========================================="
echo ""
echo "Acesse o DVWA em:"
echo "http://localhost:8080"
echo ""
