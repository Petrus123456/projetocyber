# 🔐 Projeto Cyber Lab  
### Laboratório de Redes e Segurança com Podman e IaC

## 📌 Visão Geral

O Projeto Cyber Lab é um laboratório acadêmico desenvolvido com foco em Redes de Computadores, Segurança da Informação e Infrastructure as Code (IaC).

O ambiente simula uma infraestrutura segmentada contendo:

- Aplicação web vulnerável (DVWA)
- Banco de dados MySQL
- Host atacante
- Firewall Linux com iptables
- Segmentação de rede (External / DMZ / Internal)

O projeto foi desenvolvido utilizando containers Podman e orquestração com Podman Compose.

---

# 🏗️ Arquitetura da Infraestrutura

![Arquitetura](diagrams/arquitetura.png)

A infraestrutura foi segmentada em três zonas principais:

| Zona | Descrição |
|---|---|
| External Network | Simula internet e hosts externos |
| DMZ Network | Contém a aplicação DVWA |
| Internal Network | Contém o banco de dados MySQL |

---

# 🔒 Regras de Segurança

A arquitetura implementa conceitos básicos de segurança defensiva:

- Users → DVWA ✔ permitido
- DVWA → Database ✔ permitido
- Segmentação lógica entre redes
- Isolamento do banco de dados
- Controle de acesso utilizando iptables
- Aplicação do princípio do menor privilégio

---

# 🛠️ Tecnologias Utilizadas

| Tecnologia | Função |
|---|---|
| Podman | Containerização |
| Podman Compose | Orquestração |
| Ubuntu | Base dos containers |
| DVWA | Aplicação vulnerável |
| MySQL 5.7 | Banco de dados |
| iptables | Controle de acesso |
| Linux Networking | Segmentação de rede |

---

# 📂 Estrutura do Projeto

```text
projeto-cyber/
│
├── docs/
│   └── explicacao.md
│
├── diagrams/
│   └── arquitetura.png
│
├── scripts/
│   └── test.sh
│
├── podman-compose.yml
├── setup.sh
└── README.md

## 👨‍💻 Autor

Projeto desenvolvido para disciplina de Programação para Redes.

---

## 🤝 Colaboradores

Agradecemos às seguintes pessoas que contribuíram para este projeto:

<table>
  <tr>
  
    <td align="center">
      <a href="https://github.com/edudsprado">
        <img src="https://avatars.githubusercontent.com/u/203672299?v=4" width="100px;" alt="Eduardo Prado"/><br>
        <sub>
          <b>Eduardo Prado</b>
        </sub>
      </a>
    </td>

    <td align="center">
      <a href="https://github.com/Petrus123456">
        <img src="https://avatars.githubusercontent.com/u/276006314?v=4" width="100px;" alt="Pedro Brito"/><br>
        <sub>
          <b>Pedro Brito</b>
        </sub>
      </a>
    </td>

  </tr>
</table>

---

## 📝 Licença

Este projeto foi desenvolvido para fins acadêmicos e educacionais.
