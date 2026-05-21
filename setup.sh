#!/bin/bash

echo "🚀 Iniciando setup do Cyber Lab..."

# Atualizar sistema
echo "🔄 Atualizando pacotes..."
sudo apt update -y

# Instalar dependências básicas
echo "📦 Instalando dependências..."
sudo apt install -y podman python3 python3-pip curl

# Instalar podman-compose
echo "⚙️ Instalando podman-compose..."
pip3 install podman-compose

# Verificar instalações
echo "🔍 Verificando instalações..."
podman --version
podman-compose --version

# Subir ambiente
echo "🚀 Subindo containers..."
podman-compose up -d

echo "⏳ Aguarde alguns segundos para inicialização..."

# Mensagem final
echo "✅ Ambiente pronto!"
echo "🌐 Acesse: http://localhost:8080"
echo "🔐 Login: admin / password"
