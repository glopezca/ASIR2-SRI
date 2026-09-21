# 🐙 ANEXO III · Git, GitHub, Codespaces y Visual Studio Code

## 🎯 Objetivo

Aprender a:

1. crear un repositorio GitHub;
2. manejarlo desde la interfaz gráfica;
3. trabajar con Git desde la terminal;
4. abrirlo en GitHub Codespaces;
5. editarlo desde Visual Studio Code;
6. ejecutar las infraestructuras Docker Compose del Anexo IV.

---

# 1. 📦 Crear el repositorio

Desde GitHub:

**New repository** → nombre → visibilidad → **Create repository**.

GitHub documenta la creación de repositorios desde la interfaz web y permite elegir visibilidad, README, `.gitignore` y licencia. citeturn10search0turn10search1

Nombre sugerido:

```text
sri-asir-laboratorio
```

---

# 2. 🖥️ Estructura

```text
sri-asir-laboratorio/
├── README.md
├── ANEXO-I-VSCode-WSL2.md
├── ANEXO-II-Docker-WSL2.md
├── ANEXO-III-Git-GitHub-Codespaces-VSCode.md
├── ANEXO-IV-Docker-Compose-UT1-UT8.md
├── UT1-*.md
├── UT2-*.md
├── ...
├── UT8-*.md
├── docker/
│   ├── ut1/
│   ├── ut2/
│   ├── ...
│   └── ut8/
├── scripts/
├── .devcontainer/
└── .github/workflows/
```

---

# 3. 🧰 Git desde la terminal

Configurar identidad:

```bash
git config --global user.name "Nombre Apellido"
git config --global user.email "correo@example.com"
```

Inicializar:

```bash
git init
git add .
git commit -m "Inicio del material SRI"
```

Git distingue el directorio de trabajo, el área de preparación (*staging*) y el historial de commits. citeturn10search2turn10search6

---

# 4. 🔗 Conectar con GitHub

```bash
git remote add origin https://github.com/USUARIO/sri-asir-laboratorio.git
git branch -M main
git push -u origin main
```

Comprobar:

```bash
git remote -v
git status
git log --oneline --decorate --graph -10
```

GitHub documenta `origin` como nombre habitual del remoto y los formatos HTTPS/SSH para las URL remotas. citeturn10search14

---

# 5. 🔄 Flujo diario

```bash
git status
git pull
git add .
git diff --cached
git commit -m "Actualizar UT3"
git push
```

No utilizar:

```bash
git add .
git commit -m "cosas"
git push --force
```

sin comprender antes qué se está publicando.

---

# 6. 🖱️ GitHub Desktop

GitHub Desktop permite crear, clonar, modificar, confirmar y publicar repositorios mediante interfaz gráfica sin utilizar directamente la línea de comandos. citeturn10search4

Flujo:

```text
Repository
    ↓
Changes
    ↓
Seleccionar archivos
    ↓
Commit
    ↓
Push origin
```

Es especialmente útil para alumnado que está aprendiendo Git y necesita visualizar la relación entre cambios, staging, commit y remoto.

---

# 7. 🌐 Interfaz web de GitHub

Desde la web pueden realizarse:

- edición de archivos;
- creación de archivos;
- commits;
- ramas;
- pull requests;
- revisión de cambios;
- gestión de issues.

El README aparece automáticamente como portada del repositorio. citeturn10search1

---

# 8. ☁️ GitHub Codespaces

Un Codespace proporciona un entorno de desarrollo basado en un **dev container** ejecutado sobre una máquina virtual. La configuración puede definirse mediante `.devcontainer/devcontainer.json`. citeturn0search0turn0search3

Crear un Codespace:

```text
GitHub
  ↓
Code
  ↓
Codespaces
  ↓
Create codespace on main
```

---

# 9. 🧩 Dev Container incluido en este repositorio

Este repositorio incluye:

```text
.devcontainer/devcontainer.json
```

Su función es preparar:

- VS Code remoto;
- Docker;
- Docker Compose;
- GitHub CLI;
- extensión Docker;
- soporte YAML;
- puertos de las prácticas.

GitHub permite personalizar el dev container mediante `devcontainer.json`, Dockerfile y/o Compose. citeturn0search0turn0search3

---

# 10. 🐳 Docker dentro de Codespaces

El Anexo IV está preparado para ejecutarse dentro del Codespace.

Comprobar:

```bash
docker version
docker compose version
```

Después:

```bash
./scripts/verify-compose.sh --config-only
```

Y para una prueba completa:

```bash
./scripts/verify-compose.sh
```

GitHub documenta que Codespaces utiliza Docker y que Docker-in-Docker puede utilizarse cuando se necesita acceder a imágenes/servicios Docker desde el codespace. citeturn11search3

---

# 11. 🖥️ VS Code + Codespace

El flujo de trabajo recomendado es:

```text
GitHub
  │
  ▼
Codespace
  │
  ▼
Visual Studio Code
  │
  ├── Explorador
  ├── Editor
  └── Terminal
          │
          ▼
       Docker
          │
          ▼
      Docker Compose
```

El repositorio aparece normalmente bajo `/workspaces/<repositorio>` dentro del Codespace. citeturn11search10

---

# 12. 🔄 Reconstruir el Codespace

Si se modifica `.devcontainer/devcontainer.json`:

**Ctrl+Shift+P → Codespaces: Rebuild Container**

GitHub documenta esta operación como el mecanismo para aplicar cambios en la configuración del dev container. citeturn11search11

---

# 13. 🧪 Ejemplo completo

```bash
git clone https://github.com/USUARIO/sri-asir-laboratorio.git
cd sri-asir-laboratorio
code .
```

En Codespaces:

```bash
cd /workspaces/sri-asir-laboratorio
./scripts/verify-compose.sh --config-only
```

Después:

```bash
cd docker/ut5
docker compose up -d
curl http://localhost:8080/
docker compose down
```

---

# 14. 🔐 No subir secretos

El repositorio incluye un `.gitignore` orientado a impedir la publicación accidental de:

```text
.env
*.key
*.pem
*.p12
*.pfx
```

Antes de publicar:

```bash
git status
git diff --cached
```

---

# 15. 🧠 Concepto clave

```text
Git       = control de versiones
GitHub    = colaboración y repositorio remoto
Codespace = entorno de desarrollo remoto
VS Code   = interfaz de desarrollo
Docker    = contenedores
Compose   = definición de infraestructura
```
