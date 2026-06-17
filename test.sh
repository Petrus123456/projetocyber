#!/bin/bash

clear

echo "========================================="
echo " TESTES DO PROJETO CYBER LAB"
echo "========================================="
echo ""

FALHAS=0

echo "[1/6] Verificando containers ativos..."

for container in firewall attacker dvwa db
do
    if podman ps --format "{{.Names}}" | grep -wq "$container"; then
        echo "[OK] $container está ativo."
    else
        echo "[ERRO] $container não está ativo."
        FALHAS=$((FALHAS+1))
    fi
done

echo ""
echo "[2/6] Verificando IP Forward no firewall..."

IP_FORWARD=$(podman exec firewall bash -c "cat /proc/sys/net/ipv4/ip_forward")

if [ "$IP_FORWARD" = "1" ]; then
    echo "[OK] IP Forward está ativo."
else
    echo "[ERRO] IP Forward está desativado."
    FALHAS=$((FALHAS+1))
fi

echo ""
echo "[3/6] Testando acesso do attacker ao DVWA..."

if podman exec attacker nc -zvw 3 10.10.20.10 80 >/dev/null 2>&1; then
    echo "[OK] attacker acessa DVWA na porta 80."
else
    echo "[ERRO] attacker NÃO conseguiu acessar o DVWA."
    FALHAS=$((FALHAS+1))
fi

echo ""
echo "[4/6] Testando bloqueio do attacker ao banco..."

if podman exec attacker nc -zvw 3 10.10.30.10 3306 >/dev/null 2>&1; then
    echo "[ERRO] attacker conseguiu acessar o banco. Isso não deveria acontecer."
    FALHAS=$((FALHAS+1))
else
    echo "[OK] attacker foi bloqueado ao tentar acessar o banco."
fi

echo ""
echo "[5/6] Testando acesso do DVWA ao banco..."

if podman exec dvwa bash -c "timeout 3 bash -c '</dev/tcp/10.10.30.10/3306'" >/dev/null 2>&1; then
    echo "[OK] DVWA acessa o banco na porta 3306."
else
    echo "[ERRO] DVWA não conseguiu acessar o banco."
    FALHAS=$((FALHAS+1))
fi

echo ""
echo "[6/6] Regras atuais do firewall:"
podman exec firewall iptables -L FORWARD -v -n --line-numbers

echo ""
echo "========================================="

if [ "$FALHAS" -eq 0 ]; then
    echo " TODOS OS TESTES PASSARAM COM SUCESSO"
else
    echo " TESTES FINALIZADOS COM $FALHAS FALHA(S)"
fi

echo "========================================="
