# 🧩 ANEXO I · Visual Studio Code como herramienta de administración

## 🎯 Objetivo

Utilizar **Visual Studio Code** como entorno integrado para editar los ficheros de configuración de las UT y ejecutar las pruebas directamente sobre **WSL2 + Ubuntu 26.04**.

La distribución recomendada de la ventana es:

```text
┌───────────────────────────────────────────────────────────────────────────┐
│ EXPLORADOR          │              EDITOR DE CÓDIGO                       │
│                     │                                                     │
│ 📁 sri/             │  /etc/bind/named.conf                              │
│ ├── UT1...          │  ┌───────────────────────────────────────────────┐  │
│ ├── UT2...          │  │ options {                                     │  │
│ ├── docker/         │  │     recursion yes;                            │  │
│ │   ├── ut1/        │  │     ...                                       │  │
│ │   ├── ut2/        │  │ }                                             │  │
│ │   └── ...         │  └───────────────────────────────────────────────┘  │
│ └── README.md       │                                                     │
├─────────────────────┴─────────────────────────────────────────────────────┤
│ 🐧 TERMINAL WSL2                                                         │
│ $ docker compose up -d                                                    │
│ $ docker compose ps                                                       │
│ $ docker compose logs -f dns                                              │
└───────────────────────────────────────────────────────────────────────────┘
```

VS Code permite dividir el editor en grupos y dispone de terminal integrado; la documentación oficial confirma tanto los grupos de edición como el terminal integrado. citeturn8search2turn8search3

---

## 1. 🐧 Preparar WSL2

Desde PowerShell:

```powershell
wsl --version
wsl --update
wsl --list --verbose
```

La distribución de trabajo debe utilizar **WSL 2**.

Ejemplo:

```text
NAME            STATE     VERSION
Ubuntu-26.04    Running   2
```

---

## 2. 🖥️ Instalar VS Code

Instalar Visual Studio Code en Windows y la extensión oficial **WSL**.

La extensión permite ejecutar VS Code conectado al entorno Linux de WSL, manteniendo la interfaz gráfica en Windows. citeturn8search4

Desde WSL:

```bash
cd ~/sri
code .
```

También puede abrirse la distribución desde VS Code mediante **WSL: Connect to WSL**.

---

## 3. 📁 Abrir el proyecto

Es preferible mantener el repositorio dentro del sistema de archivos Linux de WSL para trabajar con Docker y herramientas Linux de forma eficiente.

Ejemplo:

```bash
mkdir -p ~/proyectos
cd ~/proyectos
git clone <URL_DEL_REPOSITORIO>
cd <REPOSITORIO>
code .
```

Docker recomienda almacenar el código dentro de la distribución Linux de WSL cuando se utiliza Docker Desktop con WSL 2. citeturn9search2turn9search3

---

## 4. ✏️ Editar ficheros de configuración

Desde el Explorador de VS Code se pueden editar directamente:

```text
compose.yaml
Dockerfile
named.conf
*.conf
*.cfg
*.json
*.yaml
*.lua
*.xml
```

El flujo recomendado es:

```text
Explorador
    ↓
Abrir configuración
    ↓
Editar
    ↓
Guardar
    ↓
Validar en terminal
    ↓
Reiniciar/recrear servicio
    ↓
Comprobar
```

---

## 5. 🧪 Terminal WSL2

Abrir:

**Terminal → New Terminal**

El terminal integrado puede ejecutar `git`, `docker`, `ssh`, `dig`, `curl`, etc. citeturn8search2

Comprobar:

```bash
uname -a
cat /etc/os-release
docker version
docker compose version
```

---

## 6. 🐳 Docker desde VS Code

Con Docker Desktop configurado con integración WSL2:

```bash
docker ps
docker compose version
```

La integración permite utilizar Docker directamente desde la terminal de Ubuntu WSL2. citeturn9search1

---

## 7. 🧭 Flujo de trabajo recomendado

```text
┌──────────────┐
│ Explorador   │
└──────┬───────┘
       │ seleccionar fichero
       ▼
┌──────────────┐
│ Editor       │
└──────┬───────┘
       │ guardar
       ▼
┌──────────────┐
│ Terminal WSL │
└──────┬───────┘
       │ validar
       ▼
┌──────────────┐
│ Docker       │
└──────┬───────┘
       │ ejecutar
       ▼
┌──────────────┐
│ Logs / tests │
└──────────────┘
```

---

## 8. ⌨️ Atajos útiles

| Acción | Windows/Linux |
|---|---|
| Terminal | `Ctrl+`` |
| Dividir editor | `Ctrl+\\` |
| Grupo editor 1 | `Ctrl+1` |
| Grupo editor 2 | `Ctrl+2` |
| Command Palette | `Ctrl+Shift+P` |
| Buscar fichero | `Ctrl+P` |

Los atajos de división y grupos de editor forman parte de los comandos estándar de VS Code. citeturn8search8

---

## 9. 🔐 Seguridad

No editar ni guardar en el repositorio:

```text
contraseñas reales
claves privadas
API tokens
certificados privados
ficheros .env con secretos
```

Utilizar `.env.example` para documentar variables necesarias sin publicar secretos.
