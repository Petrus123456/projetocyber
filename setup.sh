#!/bin/bash

echo "========================================="
echo " PROJETO CYBER LAB - SETUP AUTOMATICO"
echo "========================================="

sleep 2

echo "[+] Atualizando pacotes..."
sudo apt update -y

echo "[+] Verificando Podman..."

if ! command -v podman &> /dev/null
then
    echo "[!] Podman nao encontrado. Instalando..."
    sudo apt install -y podman
else
    echo "[OK] Podman ja instalado."
fi

echo "[+] Verificando podman-compose..."

if ! command -v podman-compose &> /dev/null
then
    echo "[!] podman-compose nao encontrado. Instalando..."
    sudo apt install -y podman-compose
else
    echo "[OK] podman-compose ja instalado."
fi

echo "[+] Subindo containers..."
podman-compose up -d

sleep 5

echo "[+] Containers ativos:"
podman ps

echo ""
echo "========================================="
echo " LABORATORIO INICIADO COM SUCESSO"
echo "========================================="
echo ""
echo "DVWA:"
echo "http://localhost:8080"
echo ""
echo "Use CTRL+C para sair."
