# 🐳 ANEXO IV · UT1–UT8 ejecutables con Docker Compose

## 🎯 Propósito

Este anexo proporciona una **segunda vía práctica** para ejecutar el código de las ocho primeras UT sin tener que instalar cada servicio directamente en Ubuntu Server.

La idea es mantener el contenido conceptual de las UT y trasladar sus servicios ejecutables a contenedores:

```text
                    UT1–UT8
                       │
                       ▼
              ┌─────────────────┐
              │ Docker Compose  │
              └────────┬────────┘
                       │
       ┌───────────────┼────────────────┐
       │               │                │
       ▼               ▼                ▼
     WSL2          Codespaces        CI GitHub
       │               │                │
       └───────────────┼────────────────┘
                       ▼
              mismos compose.yaml
```

Docker Compose utiliza la **Compose Specification**, que define servicios, redes, volúmenes, configuraciones y otras partes de la aplicación. citeturn0search15

---

# ⚠️ Alcance de la adaptación

No todo lo que aparece en las UT puede sustituirse literalmente por un contenedor.

Especialmente:

- **Cisco Packet Tracer** sigue siendo necesario para las simulaciones específicas de routers, switches y determinadas operaciones L2/L3.
- **DHCP real** utiliza broadcast de capa 2 y requiere un escenario de red adecuado; el stack Docker portable de UT2 valida la configuración Kea, mientras que el DHCP real debe practicarse en Packet Tracer/VirtualBox.
- VirtualBox sigue siendo útil para estudiar una VM completa y servicios de sistema.

Por tanto:

> **Docker Compose complementa, no elimina, Packet Tracer ni VirtualBox.**

---

# 🗂️ Estructura

```text
docker/
├── ut1/
│   ├── compose.yaml
│   └── README.md
├── ut2/
│   ├── compose.yaml
│   ├── Dockerfile
│   ├── kea-dhcp4.conf
│   └── README.md
├── ut3/
│   ├── compose.yaml
│   ├── Dockerfile
│   ├── named.conf
│   ├── db.asir.test
│   └── README.md
├── ut4/
│   ├── compose.yaml
│   ├── Dockerfile
│   ├── vsftpd.conf
│   ├── start.sh
│   └── README.md
├── ut5/
│   ├── compose.yaml
│   ├── apache/
│   ├── nginx/
│   └── README.md
├── ut6/
│   ├── compose.yaml
│   ├── mailserver.env
│   └── README.md
├── ut7/
│   ├── compose.yaml
│   ├── prosody/
│   ├── inspircd/
│   ├── inn/
│   └── README.md
└── ut8/
    ├── compose.yaml
    ├── icecast/
    ├── nginx-rtmp/
    └── README.md
```

---

# 🌐 UT1 · TCP/IP

## Equivalencia

La UT1 estudia:

- IP;
- TCP/UDP;
- puertos;
- cliente/servidor;
- rutas;
- diagnóstico.

Compose proporciona dos hosts virtuales en una red privada:

```text
client ──────────── server
        Docker network
```

El servidor publica HTTP sobre TCP/8080 y el cliente lo comprueba con `ping`, `nc`, `curl`, `ip addr` e `ip route`.

### Ejecutar

```bash
cd docker/ut1
docker compose up -d
docker compose exec client ping -c 3 server
docker compose exec client nc -vz server 8080
docker compose exec client curl http://server:8080/
```

---

# 📡 UT2 · DHCP / Kea

## Equivalencia

Se traslada la configuración de Kea a una imagen Ubuntu 26.04 y se ejecuta:

```bash
kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
```

La configuración procede de la estructura de la UT2: `Dhcp4`, `interfaces-config`, `lease-database`, `valid-lifetime`, `subnet4`, `pools` y `option-data`.

### Ejecutar

```bash
cd docker/ut2
docker compose build
docker compose run --rm kea-config
```

### Por qué no se fuerza un DHCP broadcast dentro de Compose

Una red bridge de Docker no debe presentarse al alumnado como una LAN Ethernet equivalente a la de Packet Tracer. La práctica de DHCP real se conserva en el laboratorio de red.

---

# 🌐 UT3 · DNS / BIND9

## Equivalencia

Se utiliza una imagen Ubuntu 26.04 que instala BIND9 y valida durante la construcción:

```bash
named-checkconf /etc/bind/named.conf
named-checkzone asir.test /etc/bind/db.asir.test
```

El servidor se ejecuta en foreground:

```bash
named -g -4 -c /etc/bind/named.conf
```

BIND documenta `-g` como ejecución en foreground con logs en stderr. citeturn4search48

### Ejecutar

```bash
cd docker/ut3
docker compose up -d
docker compose exec client dig @dns www.asir.test +short
```

Resultado esperado:

```text
10.30.0.20
```

---

# 📂 UT4 · Transferencia de ficheros

## Equivalencia

Un único contenedor proporciona:

```text
FTP   → vsftpd → TCP/21
SFTP  → OpenSSH → TCP/22
```

Se conserva además el modo pasivo FTP:

```text
40000–40009
```

### Ejecutar

```bash
cd docker/ut4
docker compose up -d
docker compose exec client nc -vz fileserver 21
docker compose exec client nc -vz fileserver 22
```

Para SFTP:

```bash
docker compose exec client sftp -P 22 alumno@fileserver
```

La contraseña es exclusivamente de laboratorio.

---

# 🌍 UT5 · Web / HTTP

## Equivalencia

Se implementa directamente la arquitectura de la práctica de reverse proxy:

```text
                 TCP/8080
CLIENTE ───────────► NGINX
                       │
                       │ proxy_pass
                       ▼
                    APACHE
                    TCP/80
```

El Apache contiene la web de la UT5 y Nginx actúa como reverse proxy.

### Ejecutar

```bash
cd docker/ut5
docker compose up -d
curl http://localhost:8080/
```

Comprobar logs:

```bash
docker compose logs -f nginx
docker compose logs -f apache
```

---

# ✉️ UT6 · Correo electrónico

## Equivalencia

La UT6 explica Postfix + Dovecot y los protocolos SMTP, submission, IMAP y POP3.

Para Docker se utiliza `docker-mailserver`, que integra Postfix y Dovecot en una imagen preparada para este modelo de laboratorio. La versión está fijada a `15.1.0`.

El proyecto publica actualmente esa versión como release estable. citeturn5search0turn5search2

### Puertos del host

| Servicio | Contenedor | Host |
|---|---:|---:|
| SMTP | 25 | 2525 |
| Submission | 587 | 2587 |
| IMAPS | 993 | 2993 |
| POP3S | 995 | 2995 |

### Ejecutar

```bash
cd docker/ut6
docker compose up -d
```

Crear usuario:

```bash
docker compose exec mailserver setup email add alumno@asir.test 'ASIR-Lab-2026!'
```

Pruebas TLS:

```bash
openssl s_client -connect localhost:2993
openssl s_client -connect localhost:2995
openssl s_client -connect localhost:2587 -starttls smtp
```

> El objetivo de esta conversión es proporcionar un laboratorio reproducible. No pretende sustituir el estudio separado de Postfix y Dovecot que exige la UT.

---

# 💬 UT7 · Mensajería, IRC y NNTP

## Equivalencia

```text
XMPP  → Prosody  → 5222
IRC   → InspIRCd → 6667
NNTP  → INN      → 8119*
```

`*` Se utiliza 8119 en el laboratorio portable para no depender de un puerto privilegiado. El puerto tradicional NNTP continúa siendo 119 y se estudia conceptualmente en la UT.

Prosody puede ejecutarse en foreground mediante `-F`. citeturn4search0

InspIRCd dispone de `--nofork`, adecuado para contenedores. citeturn7search1turn7search2

INN permite mantener `innd` en foreground con `-f`. citeturn6search1

### Ejecutar

```bash
cd docker/ut7
docker compose up -d
```

Comprobar:

```bash
docker compose exec client nc -z xmpp 5222
docker compose exec client nc -z irc 6667
docker compose exec client nc -z nntp 8119
```

---

# 🎧 UT8 · Audio y vídeo

La conversión Docker reproduce los dos pipelines principales:

```text
                  AUDIO
FFmpeg ───────► Icecast ───────► cliente

                  VÍDEO
FFmpeg ──RTMP──► Nginx ──HLS──► cliente
```

## Icecast

El servidor se ejecuta mediante:

```bash
icecast -c /etc/icecast2/icecast.xml
```

La documentación oficial de Icecast utiliza esta forma para arrancar el servidor. citeturn4search13

FFmpeg genera una señal sinusoidal y la publica mediante `icecast://`, evitando depender de un archivo multimedia externo.

## RTMP/HLS

Nginx incorpora `libnginx-mod-rtmp` y genera HLS.

FFmpeg genera vídeo mediante `testsrc` y audio mediante `sine`.

### Ejecutar

```bash
cd docker/ut8
docker compose up -d
```

Comprobar Icecast:

```bash
curl http://localhost:8000/
```

Comprobar HLS:

```bash
curl http://localhost:8088/hls/ut8.m3u8
```

---

# 🧪 Prueba global

Desde la raíz del repositorio:

```bash
./scripts/verify-compose.sh --config-only
```

Esta prueba valida las ocho definiciones Compose con el propio CLI de Docker.

Para ejecutar los *smoke tests*:

```bash
./scripts/verify-compose.sh
```

El script arranca cada stack, realiza comprobaciones funcionales mínimas y ejecuta `docker compose down -v` al finalizar.

---

# ☁️ Pruebas en GitHub

El repositorio incluye:

```text
.github/workflows/compose-tests.yml
```

Cada `push` y `pull_request` ejecuta en `ubuntu-latest`:

1. checkout;
2. `docker compose config`;
3. build de cada stack.

Esto constituye una segunda capa de validación automática independiente del entorno local.

> **Importante:** GitHub Actions no es idéntico a GitHub Codespaces. Las Actions validan el material en un runner Linux con Docker; el Codespace utiliza además la configuración `.devcontainer`.

---

# ☁️ Prueba específica de Codespaces

Al abrir el repositorio en Codespaces:

```bash
docker version
docker compose version
./scripts/verify-compose.sh --config-only
```

Después puede ejecutarse individualmente:

```bash
cd docker/ut5
docker compose up -d
curl http://localhost:8080/
docker compose down
```

Los puertos publicados por un Codespace pueden reenviarse mediante la configuración del dev container. GitHub documenta `forwardPorts` y la posibilidad de reconstruir el dev container tras modificar su configuración. citeturn11search0turn11search11

---

# 🧭 Tabla de equivalencias

| UT | Servicio principal | Compose | Prueba principal |
|---:|---|---|---|
| 1 | TCP/IP | `docker/ut1` | `ping`, `nc`, `curl` |
| 2 | Kea DHCP | `docker/ut2` | `kea-dhcp4 -t` |
| 3 | BIND9 | `docker/ut3` | `dig` |
| 4 | FTP/SFTP | `docker/ut4` | `nc`, `sftp` |
| 5 | Apache/Nginx | `docker/ut5` | `curl` |
| 6 | Postfix/Dovecot | `docker/ut6` | TLS + puertos |
| 7 | XMPP/IRC/NNTP | `docker/ut7` | `nc` + logs |
| 8 | Icecast/RTMP/HLS | `docker/ut8` | `curl`, playlist HLS |

---

# 🔬 Qué se ha cambiado respecto al código Ubuntu tradicional

## `systemctl`

En Docker no se ejecuta normalmente `systemctl` dentro de un contenedor. El proceso principal del servicio pasa a ser **PID 1**.

```text
Ubuntu Server
systemd
  └── servicio

Docker
servicio
  └── PID 1
```

Por ello se sustituyen:

```bash
systemctl status servicio
systemctl restart servicio
journalctl -u servicio
```

por:

```bash
docker compose ps
docker compose restart servicio
docker compose logs servicio
```

---

# 📜 Configuración como código

Una de las ventajas didácticas del Anexo IV es que la configuración deja de depender de modificaciones manuales dentro de una VM.

```text
ANTES
VM → apt → nano → systemctl → pruebas

DESPUÉS
Git → Dockerfile → Compose → contenedor → pruebas
```

Esto permite:

- reproducibilidad;
- versionado;
- comparación de cambios;
- rollback;
- ejecución en diferentes equipos;
- automatización mediante CI.

---

# 🔐 Secretos

No guardar contraseñas reales en los ficheros Compose.

Para producción debería utilizarse:

- Docker secrets;
- gestores de secretos;
- variables de entorno gestionadas externamente;
- GitHub Secrets en CI/CD.

Las credenciales incluidas en estas prácticas son deliberadamente de laboratorio.

---

# ✅ Criterio de aceptación

Una UT convertida a Compose se considera funcional cuando:

```text
✓ docker compose config
        ↓
✓ build
        ↓
✓ servicio arranca
        ↓
✓ healthcheck / puerto
        ↓
✓ cliente obtiene respuesta
        ↓
✓ logs sin error crítico
        ↓
✓ docker compose down
```

El objetivo no es simplemente «hacer que Docker arranque», sino mantener el mismo modelo pedagógico de administración de servicios que se trabaja en las UT.
