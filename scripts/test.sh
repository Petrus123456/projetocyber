#!/bin/bash

echo "================================="
echo " Testando conectividade DVWA"
echo "================================="

curl -I http://localhost:8080

echo ""
echo "================================="
echo " Containers ativos"
echo "================================="

podman ps

echo ""
echo "================================="
echo " Redes"
echo "================================="

podman network ls
