# 🌐 Servicios de Red e Internet · ASIR

Material docente y de laboratorio para el módulo **Servicios de Red e Internet (SRI)** del **CFGS Administración de Sistemas Informáticos en Red (ASIR)**.

Este repositorio reúne las **8 primeras unidades de trabajo (UT1–UT8)** desarrolladas a partir del libro:

> **_Servicios de Red e Internet_**  
> Álvaro García Sánchez · Luis Enamorado Sarmiento · Javier Sanz Rodríguez  
> Garceta Grupo Editorial  
> **ISBN: 978-84-9281-285-1**

El libro está orientado al segundo curso del ciclo de **Técnico Superior en Administración de Sistemas Informáticos en Red** y parte de los conocimientos adquiridos previamente en **Planificación y Administración de Redes**.

---

## 📚 ¿Para qué sirve este repositorio?

El propósito es disponer de un material de estudio que combine:

```text
                 📚 CONCEPTOS
                     │
                     ▼
              🌐 PROTOCOLOS
                     │
                     ▼
              🖥️ SERVICIOS
                     │
                     ▼
              🧪 LABORATORIO
             ┌───────┼────────┐
             ▼       ▼        ▼
          Packet    WSL2    VirtualBox
          Tracer   Ubuntu     Ubuntu
                    26.04     26.04
             │       │        │
             └───────┼────────┘
                     ▼
               🔎 DIAGNÓSTICO
                     │
                     ▼
                📝 DOCUMENTACIÓN
```

No se pretende que el alumnado memorice únicamente comandos. El objetivo es comprender **qué servicio se está desplegando, cómo funciona sobre TCP/IP, qué componentes intervienen, cómo se configura y cómo se diagnostica una incidencia**.

---

# 🧭 Material del libro que sirve de base

El libro comienza estableciendo una base común antes de entrar en los servicios concretos.

## 1. Arquitectura TCP/IP y modelo cliente/servidor

El capítulo inicial presenta la arquitectura TCP/IP, el modelo cliente/servidor y el concepto de servicio de red.

El esquema conceptual que se desprende del libro es:

```text
                    SERVICIO DE RED
                         │
              ┌──────────┴──────────┐
              │                     │
           CLIENTE                SERVIDOR
              │                     │
              └──────── RED ────────┘
                         │
                    TCP/IP
```

La idea de **cliente/servidor** es transversal a prácticamente todas las unidades posteriores.

El cliente solicita un servicio y el servidor lo proporciona. El servicio se materializa mediante procesos que se comunican utilizando protocolos de red.

---

## 2. 🧩 Capas y protocolos

El libro utiliza la arquitectura TCP/IP como marco para entender los servicios.

Una forma útil de visualizarla es:

```text
┌───────────────────────────────┐
│       APLICACIÓN              │
│ DNS · DHCP · HTTP · FTP ·     │
│ SMTP · IMAP · XMPP · etc.     │
├───────────────────────────────┤
│       TRANSPORTE              │
│          TCP / UDP            │
├───────────────────────────────┤
│         INTERNET              │
│              IP               │
├───────────────────────────────┤
│     ACCESO A LA RED           │
└───────────────────────────────┘
```

Por tanto, para estudiar cualquier servicio conviene preguntar:

1. ¿Qué problema resuelve?
2. ¿Qué protocolo utiliza?
3. ¿Sobre qué transporte funciona?
4. ¿Qué puerto utiliza?
5. ¿Quién actúa como cliente?
6. ¿Quién actúa como servidor?
7. ¿Cómo se autentican los usuarios?
8. ¿Qué mecanismos de seguridad existen?
9. ¿Cómo podemos comprobar que funciona?

---

# 🖥️ El modelo de laboratorio del libro

Una de las ideas metodológicas importantes del libro es utilizar **máquinas virtuales** para realizar las prácticas.

El capítulo inicial introduce la virtualización y la configuración de máquinas virtuales como base para el trabajo práctico posterior.

En este repositorio se actualiza ese planteamiento a:

### 🧪 Cisco Packet Tracer

Para representar y probar:

- topologías;
- switches;
- routers;
- direccionamiento IP;
- gateways;
- conectividad;
- segmentación de redes.

### 🐧 WSL2 + Ubuntu 26.04

Como estación de trabajo para:

- administración;
- clientes de servicios;
- pruebas TCP/IP;
- resolución DNS;
- conexiones TCP;
- captura y análisis;
- scripting.

### 🖥️ VirtualBox + Ubuntu 26.04 Server

Como plataforma principal para desplegar los servidores de las prácticas.

```text
             🧪 LABORATORIO SRI
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
   PacketTracer    WSL2     VirtualBox
                  Ubuntu       │
                   26.04       ▼
                           Ubuntu 26.04
                              Server
```

> **Importante:** las UT actualizadas utilizan Ubuntu 26.04 como referencia de laboratorio. Cuando el libro emplea software que ha quedado obsoleto, se mantiene el concepto didáctico y se propone una alternativa actual cuando es posible.

---

# 📖 Cómo está organizado el libro

Cada capítulo del libro sigue una estructura didáctica bastante regular:

```text
INTRODUCCIÓN
     │
     ▼
CONCEPTOS Y FUNDAMENTOS
     │
     ▼
CONFIGURACIÓN / SERVICIOS
     │
     ├──────────────┐
     ▼              ▼
PRÁCTICAS       ACTIVIDADES
     │              │
     └──────┬───────┘
            ▼
         RESUMEN
            │
            ▼
      TEST DE REPASO
            │
            ▼
   COMPRUEBA TU APRENDIZAJE
```

Las unidades de este repositorio conservan esa filosofía y la amplían con prácticas reproducibles para el laboratorio actual.

---

# 🗂️ Índice general del libro

El índice del libro organiza los contenidos en los siguientes grandes bloques:

| Capítulo | Contenido |
|---:|---|
| **1** | Conceptos básicos de TCP/IP |
| **2** | Servicios de configuración automática de red (DHCP) |
| **3** | Servicio de nombres de dominio (DNS) |
| **4** | Servicios de transferencia de ficheros |
| **5** | Servidores Web (HTTP) |
| **6** | Los servicios de correo electrónico |
| **7** | Servicios de mensajería instantánea, noticias y listas de distribución |
| **8** | Servicios de audio y vídeo |

> El PDF utilizado como fuente tiene **389 páginas** y el capítulo 7 comienza en la página 315. El capítulo 8 es el último capítulo del documento utilizado como fuente.

---

# 🧱 Secuencia de aprendizaje

La secuencia de las ocho UT no es arbitraria:

```text
UT1
TCP/IP
 │
 ▼
UT2
DHCP
 │
 ▼
UT3
DNS
 │
 ▼
UT4
Transferencia
de ficheros
 │
 ▼
UT5
Web / HTTP
 │
 ▼
UT6
Correo
 │
 ▼
UT7
Mensajería · IRC · NNTP
 │
 ▼
UT8
Audio · Vídeo · Streaming
```

Primero se estudia la infraestructura de red sobre la que posteriormente se apoyan los servicios.

Después se incorporan progresivamente servicios de aplicación con diferentes modelos de funcionamiento.

---

# 📂 Unidades de trabajo

## 🌐 UT1 · Conceptos básicos de TCP/IP

Fundamentos necesarios para comprender los servicios posteriores:

- arquitectura TCP/IP;
- direccionamiento IPv4;
- IPv6;
- subredes;
- TCP y UDP;
- puertos;
- NAT/PAT;
- encaminamiento;
- virtualización;
- modelo cliente/servidor.

➡️ [**Abrir UT1 — Conceptos básicos de TCP/IP**](UT1-Conceptos-basicos-TCP-IP-final-v2.md)

---

## 📡 UT2 · Servicio DHCP

Configuración automática de parámetros de red:

- DHCP;
- proceso DORA;
- ámbitos;
- concesiones;
- reservas;
- opciones;
- relay;
- DHCPv6;
- Kea DHCP.

➡️ [**Abrir UT2 — Servicio DHCP**](UT2-Servicio-DHCP-visual-solucionario-v2.md)

---

## 🌐 UT3 · Servicio de nombres de dominio (DNS)

Resolución de nombres y administración DNS:

- DNS;
- FQDN;
- zonas;
- registros;
- resolución directa e inversa;
- BIND9;
- delegaciones;
- transferencias de zona;
- DNS dinámico;
- seguridad DNS.

➡️ [**Abrir UT3 — Servicio DNS**](UT3-Servicio-DNS-visual-solucionario-v2.md)

---

## 📂 UT4 · Servicios de transferencia de ficheros

Servicios y protocolos para transferencia de archivos:

- FTP;
- FTPS;
- SFTP;
- SCP;
- TFTP;
- servidores y clientes;
- autenticación;
- permisos;
- modos activo/pasivo;
- seguridad.

➡️ [**Abrir UT4 — Servicios de transferencia de ficheros**](UT4-Servicios-transferencia-ficheros-visual-solucionario-v2.md)

---

## 🌍 UT5 · Servidores Web (HTTP)

Publicación y administración de contenidos web:

- HTTP/HTTPS;
- URL y URI;
- Apache;
- Nginx;
- virtual hosts;
- autenticación;
- proxy inverso;
- TLS;
- certificados;
- diagnóstico;
- seguridad web.

➡️ [**Abrir UT5 — Servidores Web (HTTP)**](UT5-Servidores-Web-HTTP-visual-solucionario-v2.md)

---

## ✉️ UT6 · Servicios de correo electrónico

Infraestructura de correo:

- arquitectura del correo;
- MTA;
- MUA;
- SMTP/ESMTP;
- IMAP;
- POP3;
- Postfix;
- Dovecot;
- autenticación;
- TLS;
- SPF;
- DKIM;
- DMARC;
- diagnóstico.

➡️ [**Abrir UT6 — Servicios de correo electrónico**](UT6-Servicios-correo-electronico-visual-solucionario-v2.md)

---

## 💬 UT7 · Mensajería instantánea, noticias y listas de distribución

Comunicación síncrona y asíncrona:

- mensajería instantánea;
- XMPP;
- Jabber;
- presencia;
- IRC;
- canales;
- listas de distribución;
- Mailman;
- NNTP;
- grupos de noticias;
- Prosody;
- InspIRCd;
- INN/Leafnode;
- diagnóstico.

➡️ [**Abrir UT7 — Mensajería, noticias y listas de distribución**](UT7-Servicios-mensajeria-noticias-listas-distribucion-v2.md)

---

## 🎧 UT8 · Servicios de audio y vídeo

Servicios multimedia sobre red:

- audio digital;
- vídeo digital;
- códecs;
- contenedores;
- bitrate;
- streaming;
- VOD;
- streaming en directo;
- FFmpeg;
- Icecast;
- RTMP;
- Nginx;
- HLS;
- podcast;
- VoIP;
- WebRTC;
- diagnóstico y dimensionamiento.

➡️ [**Abrir UT8 — Servicios de audio y vídeo**](UT8-Servicios-audio-video-visual-solucionario-v2.md)

---

# 🧪 Cómo utilizar las UT

Cada UT está pensada para poder utilizarse en cuatro niveles.

## ① 📚 Estudio

Leer los conceptos y comprender:

```text
PROBLEMA
   ↓
PROTOCOLO
   ↓
ARQUITECTURA
   ↓
SERVICIO
```

---

## ② 🧪 Práctica

Reproducir la instalación y configuración en el laboratorio.

La mayoría de las prácticas siguen esta secuencia:

```bash
# 1. Instalar
sudo apt update
sudo apt install <paquete>

# 2. Configurar
sudo nano /etc/<servicio>/

# 3. Validar
<comando-de-validación>

# 4. Iniciar/reiniciar
sudo systemctl restart <servicio>

# 5. Comprobar
systemctl status <servicio>
ss -lntup

# 6. Probar desde el cliente
<cliente o herramienta>

# 7. Diagnosticar
journalctl -u <servicio>
tcpdump ...
```

---

## ③ 🔎 Diagnóstico

No basta con que un servicio funcione.

Las UT incorporan herramientas para localizar problemas:

| Herramienta | Uso |
|---|---|
| `ip` | configuración y rutas |
| `ping` | conectividad IP |
| `ss` | sockets y puertos |
| `nc` | pruebas TCP/UDP |
| `dig` | DNS |
| `curl` | HTTP y otros servicios |
| `openssl s_client` | TLS |
| `tcpdump` | captura de tráfico |
| `journalctl` | registros de systemd |
| `systemctl` | gestión de servicios |

---

## ④ 📝 Documentación

En un entorno profesional, una práctica debe dejar evidencias:

```text
┌─────────────────────────────┐
│  ¿QUÉ SE HA CONFIGURADO?    │
├─────────────────────────────┤
│  ¿CÓMO FUNCIONA?            │
├─────────────────────────────┤
│  ¿QUÉ PUERTOS UTILIZA?      │
├─────────────────────────────┤
│  ¿CÓMO SE HA PROBADO?       │
├─────────────────────────────┤
│  ¿QUÉ EVIDENCIAS TENEMOS?   │
├─────────────────────────────┤
│  ¿QUÉ INCIDENCIAS HUBO?     │
├─────────────────────────────┤
│  ¿CÓMO SE RESOLVIERON?      │
└─────────────────────────────┘
```

---

# 🔬 Convenciones de las prácticas

En las UT se utilizan diferentes tipos de bloques.

### 💻 Comandos

```bash
sudo systemctl status bind9
```

### 📄 Ficheros de configuración

```text
/etc/bind/named.conf
/etc/ssh/sshd_config
/etc/nginx/nginx.conf
```

### 🧪 Comprobaciones

```bash
ss -lntup
```

### ⚠️ Advertencias

> Una configuración válida sintácticamente no implica necesariamente que el servicio funcione correctamente.

### 🛡️ Seguridad

> Las prácticas deben realizarse en el laboratorio. No se deben aplicar configuraciones experimentales sobre servidores de producción sin revisar previamente sus consecuencias.

---

# 🧠 Filosofía de aprendizaje

La idea central del material puede resumirse así:

```text
        NO SOLO...
        "¿QUÉ COMANDO EJECUTO?"
                 │
                 ▼
        SINO TAMBIÉN...
        "¿QUÉ ESTÁ OCURRIENDO?"
                 │
                 ▼
        "¿QUÉ PROTOCOLO INTERVIENE?"
                 │
                 ▼
        "¿QUÉ PROCESO ESCUCHA?"
                 │
                 ▼
        "¿QUÉ TRAFICO SE GENERA?"
                 │
                 ▼
        "¿CÓMO PUEDO DIAGNOSTICARLO?"
```

Esto conecta directamente los conocimientos de **TCP/IP** con la administración de servicios de red.

---

# 🛠️ Entorno recomendado

## Requisitos

### Host

- VirtualBox actualizado.
- WSL2.
- Cisco Packet Tracer.
- suficiente RAM para ejecutar simultáneamente el laboratorio necesario.

### Máquina virtual

```text
Nombre:       sri-server
SO:           Ubuntu 26.04 Server
CPU:          2 vCPU
RAM:          2–4 GB
Disco:        ≥ 20 GB
Red:          Adaptador adecuado al escenario
```

La configuración exacta puede modificarse según la práctica.

---

# 🌐 Esquema de red recomendado

Como referencia común:

```text
                    ROUTER
                 192.168.50.1
                       │
                  ┌────┴────┐
                  │ SWITCH  │
                  └────┬────┘
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
      SERVIDOR     CLIENTE 01   CLIENTE 02
    192.168.50.10 192.168.50.101 192.168.50.102
```

Los direccionamientos pueden cambiar en cada práctica si la unidad establece otro escenario.

---

# 🔐 Seguridad

El material debe utilizarse en **entornos de laboratorio controlados**.

Especialmente:

- no utilizar contraseñas reales;
- no reutilizar credenciales de producción;
- no exponer servicios de laboratorio directamente a Internet;
- utilizar redes privadas o NAT según el escenario;
- limitar los puertos mediante firewall;
- detener servicios que no sean necesarios;
- no publicar claves privadas;
- no incluir secretos en el repositorio Git.

### 🚨 Nunca subir al repositorio

```text
.env
*.key
*.pem
id_rsa
id_ed25519
contraseñas
tokens
API keys
certificados privados
backups con credenciales
```

Se recomienda utilizar `.gitignore`.

---

# 📁 Estructura recomendada del repositorio

```text
sri/
│
├── README.md
│
├── UT1-Conceptos-basicos-TCP-IP-final-v2.md
├── UT2-Servicio-DHCP-visual-solucionario-v2.md
├── UT3-Servicio-DNS-visual-solucionario-v2.md
├── UT4-Servicios-transferencia-ficheros-visual-solucionario-v2.md
├── UT5-Servidores-Web-HTTP-visual-solucionario-v2.md
├── UT6-Servicios-correo-electronico-visual-solucionario-v2.md
├── UT7-Servicios-mensajeria-noticias-listas-distribucion-v2.md
└── UT8-Servicios-audio-video-visual-solucionario-v2.md
```

Al estar todos los ficheros en la misma carpeta, los enlaces anteriores funcionan como **enlaces relativos de GitHub**.

---

# 📌 Sobre la versión v2

Las UT incluidas aquí constituyen una **segunda revisión técnica**.

En esta revisión se han:

- revisado comandos;
- corregido ejemplos de configuración;
- revisado bloques JSON/YAML;
- contrastado paquetes disponibles para Ubuntu 26.04;
- revisado configuraciones de servicios;
- probado sintaxis de comandos cuando ha sido posible;
- probado ejemplos representativos de Apache/Nginx;
- probado operaciones de FFmpeg;
- actualizado software que había quedado obsoleto;
- separado claramente el contenido conceptual del libro de las adaptaciones prácticas actuales.

### ⚠️ Alcance de las pruebas

La validación realizada **no equivale a ejecutar cada práctica completa sobre una infraestructura física real**.

Se han realizado pruebas ejecutables y comprobaciones de compatibilidad, pero determinadas prácticas requieren:

- una VM real de Ubuntu 26.04 Server;
- una topología de red;
- servicios funcionando simultáneamente;
- clientes;
- Packet Tracer;
- y, en algunos casos, varias máquinas.

Por ello, cualquier práctica utilizada en producción debe probarse previamente en el laboratorio.

---

# 📚 Relación con el libro original

Este repositorio **no pretende sustituir al libro**.

El libro proporciona:

- la estructura conceptual;
- la explicación de los protocolos;
- la arquitectura de los servicios;
- actividades;
- prácticas;
- resúmenes;
- tests;
- comprobaciones de aprendizaje.

Las UT de este repositorio reorganizan y actualizan ese material para facilitar su utilización como **material docente en Markdown y laboratorio ASIR**.

La fuente utilizada para la reconstrucción es:

> **_Servicios de Red e Internet_**  
> Álvaro García Sánchez  
> Luis Enamorado Sarmiento  
> Javier Sanz Rodríguez  
> Garceta Grupo Editorial  
> ISBN 978-84-9281-285-1

---

# ⚖️ Uso académico

Este repositorio se utiliza en el contexto docente del departamento y cuenta con la **autorización expresa disponible para el uso académico del material**.

La publicación, redistribución o reutilización del contenido debe respetar en todo momento las condiciones de la autorización y los derechos correspondientes a la obra original.

Las partes que constituyen una **adaptación, actualización o elaboración docente propia** se identifican conceptualmente como tales.

---

# 🎯 Objetivo final

Al finalizar el recorrido por las ocho UT, el alumnado debería ser capaz de pasar de:

```text
"Quiero instalar un servicio"
```

a:

```text
┌──────────────────────────────────────┐
│ 1. Analizar necesidades              │
│ 2. Diseñar la arquitectura           │
│ 3. Elegir el protocolo               │
│ 4. Instalar el software              │
│ 5. Configurar el servicio            │
│ 6. Protegerlo                        │
│ 7. Verificar su funcionamiento       │
│ 8. Analizar el tráfico               │
│ 9. Diagnosticar incidencias          │
│ 10. Documentar la solución           │
└──────────────────────────────────────┘
```

Ese es el enfoque que debe guiar el trabajo con **Servicios de Red e Internet**.

---

## 🚀 Comenzar

👉 **[UT1 · Conceptos básicos de TCP/IP](UT1-Conceptos-basicos-TCP-IP-final-v2.md)**

y continuar secuencialmente hasta:

👉 **[UT8 · Servicios de audio y vídeo](UT8-Servicios-audio-video-visual-solucionario-v2.md)**
