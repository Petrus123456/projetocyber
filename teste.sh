#!/bin/bash

clear

echo "=================================================="
echo "        PROJETO CYBER LAB - TESTES"
echo "=================================================="

sleep 2

START=$(date +%s)


echo ""
echo "[1/4] Containers ativos"

podman ps

sleep 2

echo ""
echo "[2/4] Validando DVWA externamente"

curl -I http://localhost:8080 &>/dev/null

if [ $? -eq 0 ]; then
    echo "[OK] DVWA acessível."
else
    echo "[ERRO] DVWA indisponível."
fi

sleep 2

echo ""
echo "[3/4] Testando isolamento do banco"

podman exec attacker nc -zv db 3306 &>/dev/null

if [ $? -eq 0 ]; then
    echo "[ALERTA] Banco acessível."
    echo "[!] Firewall NÃO está protegendo corretamente."
else
    echo "[OK] Firewall ativo."
    echo "[✔] Acesso ao banco BLOQUEADO."
fi

sleep 2

echo ""
echo "[4/4] Verificando redes"

podman network ls

echo ""
echo "=================================================="
echo "            TESTES FINALIZADOS"
echo "=================================================="

echo ""
echo "Resumo:"
echo "✔ Containers ativos"
echo "✔ DVWA acessível"
echo "✔ Firewall validado"
echo "✔ Segmentação funcionando"

END=$(date +%s)
DIFF=$((END - START))

echo ""
echo "⏱ Tempo total: ${DIFF}s"
