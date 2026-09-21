
---

# 🧰 Anexos de laboratorio y desarrollo

Las ocho UT constituyen el núcleo conceptual y práctico del material. A partir de esta versión se incorporan cuatro anexos que **no formaban parte de la versión original del libro** y que tienen como finalidad proporcionar un entorno moderno, reproducible y versionable para el laboratorio.

La secuencia propuesta pasa a ser:

```text
📚 UT1–UT8
    │
    ├── 🧩 Anexo I · VS Code + WSL2
    │
    ├── 🐳 Anexo II · Docker + WSL2 + Compose
    │
    ├── 🐙 Anexo III · Git + GitHub + Codespaces
    │
    └── 🚀 Anexo IV · UT1–UT8 con Docker Compose
```

---

## 🧩 ANEXO I · Visual Studio Code + WSL2

[**Abrir Anexo I — Visual Studio Code como herramienta de administración**](ANEXO-I-VSCode-WSL2.md)

Introduce un entorno de trabajo dividido en:

```text
┌──────────────────┬────────────────────────────────────┐
│ 📁 Explorador    │ ✏️ Editor de configuración         │
│                  │                                    │
├──────────────────┴────────────────────────────────────┤
│ 🐧 Terminal WSL2                                     │
└───────────────────────────────────────────────────────┘
```

Se utiliza para editar YAML, JSON, BIND, Apache, Nginx, Kea, Prosody, Dockerfiles y Compose directamente sobre WSL2.

---

## 🐳 ANEXO II · Docker + WSL2

[**Abrir Anexo II — Instalación de Docker en WSL2 y Docker Compose**](ANEXO-II-Docker-WSL2.md)

Incluye:

- instalación y comprobación de WSL2;
- Docker Desktop con backend WSL2;
- integración con Ubuntu 26.04;
- imágenes;
- contenedores;
- redes;
- volúmenes;
- Dockerfile;
- Docker Compose;
- healthchecks;
- profiles;
- limpieza;
- seguridad;
- primeros laboratorios.

---

## 🐙 ANEXO III · Git + GitHub + Codespaces + VS Code

[**Abrir Anexo III — Git, GitHub, Codespaces y Visual Studio Code**](ANEXO-III-Git-GitHub-Codespaces-VSCode.md)

Incluye dos vías de trabajo:

### 🖥️ Local

```text
Windows
  │
  └── VS Code
       │
       └── WSL2 Ubuntu 26.04
             │
             └── Docker
```

### ☁️ GitHub Codespaces

```text
GitHub
  │
  └── Codespace
       │
       └── VS Code
            ├── 📁 Explorador
            ├── ✏️ Editor
            └── 🐳 Terminal + Docker
```

También incluye el `.devcontainer/devcontainer.json` utilizado por el repositorio.

---

# 🚀 ANEXO IV · Docker Compose para UT1–UT8

[**Abrir Anexo IV — UT1–UT8 ejecutables con Docker Compose**](ANEXO-IV-Docker-Compose-UT1-UT8.md)

Este anexo contiene la adaptación ejecutable de los servicios de las ocho UT:

| UT | Laboratorio Compose | Servicio principal |
|---:|---|---|
| 1 | [`docker/ut1`](docker/ut1/) | TCP/IP / cliente-servidor |
| 2 | [`docker/ut2`](docker/ut2/) | Kea DHCP |
| 3 | [`docker/ut3`](docker/ut3/) | BIND9 |
| 4 | [`docker/ut4`](docker/ut4/) | vsftpd + OpenSSH/SFTP |
| 5 | [`docker/ut5`](docker/ut5/) | Apache + Nginx reverse proxy |
| 6 | [`docker/ut6`](docker/ut6/) | Postfix + Dovecot mediante docker-mailserver |
| 7 | [`docker/ut7`](docker/ut7/) | Prosody + InspIRCd + INN |
| 8 | [`docker/ut8`](docker/ut8/) | Icecast + Nginx RTMP/HLS + FFmpeg |

### 🧪 Verificación rápida

Desde la raíz:

```bash
./scripts/verify-compose.sh --config-only
```

Y, si Docker está disponible:

```bash
./scripts/verify-compose.sh
```

El repositorio incluye además un workflow de GitHub Actions:

```text
.github/workflows/compose-tests.yml
```

que valida y construye los ocho stacks automáticamente en cada `push` y `pull_request`.

---

# 🔬 Diferencia entre las tres plataformas de laboratorio

| Plataforma | Utilidad principal |
|---|---|
| **Cisco Packet Tracer** | Redes, routers, switches, DHCP y simulación L2/L3 |
| **VirtualBox + Ubuntu 26.04 Server** | Administración de un servidor Linux completo y servicios del sistema |
| **WSL2 + Docker Compose** | Infraestructura reproducible, automatización y despliegue como código |
| **GitHub Codespaces + Docker Compose** | Mismo laboratorio desde un entorno remoto y versionado en GitHub |

La intención no es sustituir una plataforma por otra, sino hacer visible la relación entre **red → sistema operativo → servicio → automatización → documentación**.

---

# 🔁 Flujo de trabajo recomendado para el curso

```text
                    📚 CONCEPTO
                        │
                        ▼
                 🧪 Packet Tracer
                        │
                        ▼
              🖥️ Ubuntu Server / VM
                        │
                        ▼
                  🐳 Docker Compose
                        │
                        ▼
                    🐙 GitHub
                        │
                 ┌──────┴──────┐
                 ▼             ▼
             Local WSL2    Codespaces
                 │             │
                 └──────┬──────┘
                        ▼
                  🔎 PRUEBAS
                        │
                        ▼
                   📝 DOCUMENTACIÓN
```

---

# 🧪 Validación técnica de los anexos

La segunda revisión técnica de las UT corrigió previamente errores de sintaxis y configuraciones aisladas. En esta nueva fase se añade una infraestructura Compose específica y un mecanismo automatizado de validación.

La validación prevista se divide en tres niveles:

### Nivel 1 · Sintaxis

```bash
docker compose config
```

### Nivel 2 · Build

```bash
docker compose build
```

### Nivel 3 · Smoke test

Arranque del servicio y prueba funcional mínima mediante `curl`, `dig`, `nc`, `ping` o herramientas específicas.

> ⚠️ El entorno de ejecución de esta conversación **no dispone actualmente de un Docker Engine operativo**, por lo que no sería correcto afirmar que los ocho stacks han sido ejecutados extremo a extremo aquí. Se ha validado la estructura YAML y se han diseñado los smoke tests y el workflow de GitHub Actions para que esa comprobación se realice automáticamente en un entorno Docker real.

---

# 📚 Documentación externa utilizada para los anexos

Las instrucciones de instalación y funcionamiento se han contrastado con documentación actual de los proyectos:

- [Docker Engine en Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Docker Desktop + WSL2](https://docs.docker.com/desktop/features/wsl/)
- [Visual Studio Code + WSL](https://code.visualstudio.com/docs/remote/wsl-tutorial)
- [GitHub Codespaces / dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration)
- [GitHub — crear repositorios](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [Git — documentación oficial](https://git-scm.com/book/en/v2)
- [Docker Compose Specification](https://docs.docker.com/reference/compose-file/)

Estas referencias complementan el libro; **no forman parte del contenido original del manual**.
