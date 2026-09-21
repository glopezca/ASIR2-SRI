# 🐳 ANEXO II · Docker en WSL2

## 🎯 Objetivo

Instalar un entorno Docker para ejecutar los laboratorios SRI en la máquina local y comprender:

- imágenes;
- contenedores;
- redes;
- volúmenes;
- Dockerfile;
- Docker Compose;
- logs;
- healthchecks;
- publicación de puertos;
- ciclo de vida de una infraestructura.

---

# 1. 🏗️ Arquitectura recomendada en Windows

```text
WINDOWS 11
    │
    ├── Visual Studio Code
    │
    └── Docker Desktop
             │
             ▼
           WSL2
             │
       Ubuntu 26.04
             │
             ▼
       Docker Engine
             │
       ┌─────┼─────┐
       ▼     ▼     ▼
     UT1   UT3    UT8
```

Docker Desktop utiliza WSL 2 como backend de Linux y permite habilitar la integración de Docker con una distribución WSL concreta. citeturn9search0turn9search1

> **Recomendación:** no instalar simultáneamente un `dockerd` independiente dentro de Ubuntu WSL2 si se va a utilizar Docker Desktop. Docker documenta que ejecutar ambos puede provocar conflictos. citeturn9search1

---

# 2. 🪟 Comprobar WSL2

PowerShell:

```powershell
wsl --version
wsl --update
wsl --list --verbose
```

Si Ubuntu aparece como versión 1:

```powershell
wsl --set-version Ubuntu-26.04 2
```

---

# 3. 🐳 Docker Desktop

Instalar Docker Desktop para Windows seleccionando el backend WSL2.

Después:

**Settings → General → Use WSL 2 based engine**

Y:

**Settings → Resources → WSL Integration**

Activar la distribución Ubuntu 26.04.

Docker documenta este procedimiento y señala que la integración permite ejecutar los comandos `docker` directamente desde la distribución WSL. citeturn9search1

---

# 4. ✅ Comprobación

Desde Ubuntu:

```bash
docker version
docker compose version
docker run --rm hello-world
```

Debe aparecer información del cliente y del servidor Docker.

---

# 5. 🧱 Conceptos básicos

## Imagen

Plantilla inmutable a partir de la cual se crean contenedores.

```bash
docker image ls
```

## Contenedor

Instancia ejecutable de una imagen.

```bash
docker ps
docker ps -a
```

## Red

```bash
docker network ls
```

## Volumen

```bash
docker volume ls
```

---

# 6. 🚀 Primer contenedor

```bash
docker run --rm -it ubuntu:26.04 bash
```

Dentro:

```bash
cat /etc/os-release
exit
```

---

# 7. 🌐 Publicar puertos

```bash
docker run --rm -d --name web -p 8080:80 nginx
```

Comprobar:

```bash
docker ps
curl http://localhost:8080
```

Eliminar:

```bash
docker stop web
```

---

# 8. 💾 Volúmenes

```bash
docker volume create sri-data
```

Utilizarlo:

```bash
docker run --rm -v sri-data:/data ubuntu:26.04 \
  bash -lc 'echo "SRI" > /data/prueba.txt'
```

Consultar:

```bash
docker run --rm -v sri-data:/data ubuntu:26.04 \
  cat /data/prueba.txt
```

---

# 9. 🧱 Dockerfile

Ejemplo:

```dockerfile
FROM ubuntu:26.04
RUN apt-get update \\
 && apt-get install -y --no-install-recommends nginx \\
 && rm -rf /var/lib/apt/lists/*
CMD ["nginx", "-g", "daemon off;"]
```

Construir:

```bash
docker build -t sri-web:1.0 .
```

---

# 10. 🧩 Docker Compose

Docker Compose permite definir servicios, redes, volúmenes, puertos y comprobaciones en un único fichero. La especificación actual es la **Compose Specification**. citeturn0search15

Ejemplo:

```yaml
services:
  web:
    image: nginx
    ports:
      - "8080:80"
```

Arrancar:

```bash
docker compose up -d
```

Estado:

```bash
docker compose ps
```

Logs:

```bash
docker compose logs -f
```

Parar:

```bash
docker compose down
```

---

# 11. 🩺 Healthchecks

Compose permite definir `healthcheck` para comprobar el estado funcional de un servicio. citeturn0search5

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/"]
  interval: 5s
  timeout: 3s
  retries: 10
```

Y utilizar:

```yaml
depends_on:
  web:
    condition: service_healthy
```

Esto es preferible a asumir que «el contenedor arrancó» equivale a «el servicio está operativo».

---

# 12. 🧪 Profiles

Compose permite utilizar perfiles para activar determinados servicios solo cuando son necesarios. citeturn0search2turn0search13

```yaml
services:
  web:
    image: nginx

  debug:
    image: alpine
    profiles: [debug]
```

```bash
docker compose --profile debug up
```

---

# 13. 🧹 Limpieza

```bash
docker compose down
```

Para eliminar volúmenes del proyecto:

```bash
docker compose down -v
```

Para limpieza global, actuar con precaución:

```bash
docker system df
docker system prune
```

---

# 14. 🔐 Seguridad

Docker publica puertos del contenedor fuera de la red interna. No asumir que una aplicación queda protegida por UFW simplemente porque UFW está activo; Docker documenta consideraciones específicas de filtrado y recomienda revisar la cadena `DOCKER-USER`. citeturn8search0

En este material:

- todas las contraseñas son de laboratorio;
- no deben reutilizarse;
- no se almacenan secretos en Git;
- los servicios se publican en puertos alternativos cuando es necesario;
- los stacks se ejecutan únicamente durante las prácticas.
