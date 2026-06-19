#!/bin/bash

clear

FALHAS=0

linha() {
    echo "============================================================"
}

secao() {
    echo ""
    linha
    echo "$1"
    linha
}

ok() {
    echo "[OK] $1"
}

erro() {
    echo "[ERRO] $1"
    FALHAS=$((FALHAS+1))
}

secao " PROJETO CYBER LAB "

echo "Objetivo dos testes:"
echo ""
echo "  Attacker -> DVWA:      PERMITIDO   porta 80"
echo "  Attacker -> Database:  BLOQUEADO   porta 3306"
echo "  DVWA     -> Database:  PERMITIDO   porta 3306"
echo ""

secao "[1/7] CONTAINERS ATIVOS"

echo "Lista atual de containers:"
echo ""

podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""

for container in firewall attacker dvwa db
do
    if podman ps --format "{{.Names}}" | grep -wq "$container"; then
        ok "$container está ativo."
    else
        erro "$container não está ativo."
    fi
done

secao "[2/7] ENDEREÇAMENTO DO FIREWALL"

echo "Interfaces e IPs do firewall:"
echo ""

podman inspect firewall --format '{{range $name, $net := .NetworkSettings.Networks}}{{println $name "->" $net.IPAddress}}{{end}}'

echo ""

secao "[3/7] IP FORWARD DO FIREWALL"

IP_FORWARD=$(podman exec firewall bash -c "cat /proc/sys/net/ipv4/ip_forward")

echo "Valor atual de /proc/sys/net/ipv4/ip_forward:"
echo ""
echo "  ip_forward = $IP_FORWARD"
echo ""

if [ "$IP_FORWARD" = "1" ]; then
    ok "IP Forward está ATIVO. O firewall pode rotear pacotes entre redes."
else
    erro "IP Forward está DESATIVADO. O firewall não está roteando pacotes."
fi

secao "[4/7] ROTAS CONFIGURADAS"

echo "Rotas do attacker:"
podman exec attacker ip route

echo ""
echo "Rotas do DVWA:"
podman exec dvwa ip route

echo ""
echo "Rotas do Database:"
podman exec db sh -c "/sbin/ip route"

secao "[5/7] TESTES DE ACESSO"

echo "Teste 1: Attacker acessando DVWA na porta 80"
echo "Esperado: PERMITIDO"
echo ""

if podman exec attacker nc -zvw 3 10.10.20.10 80 >/dev/null 2>&1; then
    ok "Attacker conseguiu acessar a DVWA na porta 80."
else
    erro "Attacker NÃO conseguiu acessar a DVWA na porta 80."
fi

echo ""
echo "Teste 2: Attacker tentando acessar Database na porta 3306"
echo "Esperado: BLOQUEADO"
echo ""

if podman exec attacker nc -zvw 3 10.10.30.10 3306 >/dev/null 2>&1; then
    erro "Attacker conseguiu acessar o Database. Isso NÃO deveria acontecer."
else
    ok "Attacker foi bloqueado ao tentar acessar o Database."
fi

echo ""
echo "Teste 3: DVWA acessando Database na porta 3306"
echo "Esperado: PERMITIDO"
echo ""

if podman exec dvwa bash -c "timeout 3 bash -c '</dev/tcp/10.10.30.10/3306'" >/dev/null 2>&1; then
    ok "DVWA conseguiu acessar o Database na porta 3306."
else
    erro "DVWA NÃO conseguiu acessar o Database."
fi

secao "[6/7] REGRAS ATUAIS DO FIREWALL"

echo "Política e contadores da chain FORWARD:"
echo ""

podman exec firewall iptables -L FORWARD -v -n --line-numbers

echo ""
echo "Leitura esperada:"
echo ""
echo "  Regra ACCEPT External -> DMZ porta 80 deve ter pacotes."
echo "  Regra DROP External -> Internal porta 3306 deve ter pacotes."
echo "  Regra ACCEPT DMZ -> Internal porta 3306 deve ter pacotes."

secao "[7/7] RESUMO FINAL"

if [ "$FALHAS" -eq 0 ]; then
    echo "[SUCESSO] TODOS OS TESTES PASSARAM."
    echo ""
    echo "Resultado validado:"
    echo ""
    echo "  Attacker -> DVWA:      PERMITIDO"
    echo "  Attacker -> Database:  BLOQUEADO"
    echo "  DVWA     -> Database:  PERMITIDO"
    echo ""
    echo "O firewall está controlando o tráfego entre as redes."
else
    echo "[ATENÇÃO] TESTES FINALIZADOS COM $FALHAS FALHA(S)."
    echo ""
    echo "Revise as rotas, o IP Forward e as regras do iptables."
fi

linha
