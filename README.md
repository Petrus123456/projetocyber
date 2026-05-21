# 🔐 Projeto Cyber Lab (IaC com Podman)

## 📌 Visão Geral

Este projeto implementa um laboratório de Redes e Segurança da Informação utilizando containers e Infrastructure as Code (IaC).

O ambiente simula um cenário real com:

* Aplicação vulnerável (DVWA)
* Banco de dados isolado
* Máquina atacante
* Segmentação de rede (External / DMZ / Internal)
* Controle de acesso (Firewall conceitual)

---

## 🏗️ Arquitetura

O ambiente é dividido em três zonas:

* **External Network** → Usuários e atacante
* **DMZ** → Aplicação web (DVWA)
* **Internal Network** → Banco de dados (MySQL)

### 🔒 Regras de Segurança

* Users → DVWA ✔ permitido
* Attacker → DVWA ❌ bloqueado
* Attacker → Database ❌ bloqueado
* DVWA → Database ✔ permitido

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia     | Função               |
| -------------- | -------------------- |
| Podman         | Containers           |
| Podman Compose | Orquestração         |
| Ubuntu         | Base dos containers  |
| DVWA           | Aplicação vulnerável |
| MySQL          | Banco de dados       |

---

## 📂 Estrutura do Projeto

```
projeto-cyber/
│
├── podman-compose.yml
├── setup.sh
├── README.md
└── diagrams/
    └── arquitetura.png
```

---

## ⚙️ Pré-requisitos

### 💻 Hardware

* CPU: 2 cores (mínimo)
* RAM: 4 GB (mínimo)
* Disco: 10 GB livres

### 🖥️ Software

* Ubuntu 20.04+ ou WSL2
* Podman
* Python3 + pip

---

## 🚀 Como Executar

```bash
git clone <repo>
cd projeto-cyber
chmod +x setup.sh
./setup.sh
```

---

## 🌐 Acesso

```
http://localhost:8080
```

Login:

* user: admin
* senha: password

---

## 🧪 Testes

### Acesso pelo atacante (deve falhar)

```bash
curl http://dvwa
```

---

### Acesso pelo navegador (deve funcionar)

Abrir:

```
http://localhost:8080
```

---

### Acesso ao banco (deve falhar)

```bash
mysql -h db -u dvwa -p
```

---

## ⚠️ Vulnerabilidade Inicial

Na arquitetura inicial, o atacante conseguia acessar diretamente o banco.

Após a segmentação:

* acesso foi bloqueado
* rede isolada corretamente

---

## 🔒 Melhorias Implementadas

* Segmentação de rede
* Isolamento do atacante
* Separação em zonas (DMZ)
* Controle de acesso via firewall (conceitual)
* Base para firewall real (iptables)

---

## 🧠 Conceitos Aplicados

* Infrastructure as Code (IaC)
* Network Segmentation
* Defense in Depth
* Principle of Least Privilege

---

## 🧹 Parar o Ambiente

```bash
podman-compose down
```

---

## 📌 Observações

Este projeto é destinado para fins educacionais e não deve ser exposto à internet pública.

---

## 👨‍💻 Autor

Projeto desenvolvido para disciplina de Redes e Segurança.

## 🤝 Colaboradores

Agradecemos às seguintes pessoas que contribuíram para este projeto:

<table>
    <td align="center">
      <a href="#" title="defina o título do link">
        <img src="https://avatars.githubusercontent.com/u/203672299?v=4" width="100px;" alt="Eduardo Prado"/><br>
        <sub>
          <b>Eduardo Prado</b>
        </sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Petrus123456" title="Perfil Pedro">
        <img src="https://avatars.githubusercontent.com/u/276006314?v=4" width="100px;" alt="Pedro Brito"/><br>
        <sub>
          <b>Pedro Brito</b>
        </sub>
      </a>
    </td>
  </tr>
</table>



## 📝 Licença

/*Esse projeto está sob licença. Veja o arquivo [LICENÇA](LICENSE.md) para mais detalhes.
