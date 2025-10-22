# 🧩 CoreDNS — Despliegue mediante Docker Compose

Este documento explica **paso a paso** cómo lanzar, comprobar y analizar el funcionamiento de un **servidor CoreDNS** desplegado mediante contenedores empleando Docker Compose. Incluye ejemplos de comandos, pruebas, y una explicación línea a línea de los ficheros de configuración.

---

## 📚 Índice

1. 🧠 Resumen de la arquitectura
2. 📂 Ficheros incluidos
3. ⚙️ Comandos básicos: lanzar, comprobar, acceder a la shell
4. 🔍 Pruebas DNS
5. 🧾 Explicación detallada de `docker-compose.yaml`
6. 🧩 Explicación de `Corefile`
7. 📜 Explicación de `db.tierramedia.jc`
8. 💡 Notas y recomendaciones

---

## 🧠 1. Resumen de la arquitectura

- Se levantan **dos contenedores**:
  - 🧭 **coredns**: servidor DNS basado en `coredns/coredns:latest`.
  - 💻 **client**: contenedor Ubuntu que actúa como cliente para realizar pruebas DNS.
- Ambos usan la red `tierramedia`, con IPs fijas.
- `coredns` expone los puertos **53 (TCP/UDP)** y **8080** (salud/metrics).

---

## 📂 2. Ficheros incluidos

```bash
├── conf/                     # Carpeta de configuración de CoreDNS
│   ├── Corefile/             # Configuración del servicio
│   └── db.tierramedia.jc/    # Zona maestra
├── docker-compose.yaml       # Despliegue en Docker Compose
└── README.md                 # Este fichero
```

### 🐋 `docker-compose.yaml`

```yaml
services:
  coredns-comarca:
    image: coredns/coredns:latest
    container_name: coredns
    command: -conf /etc/coredns/Corefile -dns.port 53
    stdin_open: true
    tty: true
    restart: unless-stopped
    ports:
      - "5353:53"
      - "5353:53/udp"
      - "8080:8080"
    volumes:
      - ./conf/Corefile:/etc/coredns/Corefile
      - ./conf/db.tierramedia.jc:/etc/coredns/db.tierramedia.jc
    networks:
      tierramedia:
        ipv4_address: 192.168.103.253
    domainname: tierramedia.jc
    hostname: comarca

  client-lothlorien:
    image: ubuntu:latest
    container_name: lothlorien
    command: bash -c "
      echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections &&
      echo 'tzdata tzdata/Zones/Europe select Madrid' | debconf-set-selections &&
      apt update &&
      DEBIAN_FRONTEND=noninteractive apt install -y tzdata &&
      dpkg-reconfigure --frontend noninteractive tzdata &&
      apt upgrade -y &&
      apt install -y
        iputils-ping
        dnsutils
        net-tools &&
      sleep infinity"
    stdin_open: true
    tty: true
    #entrypoint: /bin/bash
    depends_on:
      - coredns-comarca
    volumes:
      - /etc/passwd:/etc/passwd:ro
      - /etc/group:/etc/group:ro
    networks:
      tierramedia:
        ipv4_address: 192.168.103.16 
    dns:
      - 192.168.103.253
    domainname: tierramedia.jc
    hostname: lothlorien
      
networks:
  default:
    driver: bridge 
  tierramedia:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.103.0/24  
```

### ⚙️ `conf/Corefile`

```text
.:53 {
    forward . 8.8.8.8 8.8.4.4
    log
    errors
    health :8080
}

tierramedia.jc:53 {
    file /etc/coredns/db.tierramedia.jc
    log
    errors
}
```

### 🌍 `conf/db.tierramedia.jc`

```dns
$ORIGIN     tierramedia.jc.
@               IN  SOA     ns.tierramedia.jc. admin.tierramedia.jc. (
    2017042745 ; serial
	7200       ; refresh (2 hours)
	3600       ; retry (1 hour)
	1209600    ; expire (2 weeks)
	3600       ; minimum (1 hour)
)
tierramedia.jc.	IN  NS      ns.tierramedia.jc.
@               IN  A       192.168.103.253
ns              IN  CNAME   comarca
comarca         IN  A       192.168.103.253
lothlorien      IN  A       192.168.103.16
```

---

## ⚙️ 3. Comandos básicos

> Ejecutar desde el directorio donde se encuentra `docker-compose.yaml`.

### ▶️ Ejecutar despliegue y lanzar contenedores

> Opción 1: Debugging: muestra mensajes por pantalla y debemos abrir otra terminal para interactuar
```bash
docker compose up
```
> Opción 2: Segundo plano: conservamos la terminal y comprobamos el estado con `docker compose logs`
```bash
docker compose up -d
```


### 🧾 Ver estado

```bash
docker compose ps
```

### 📜 Ver logs

```bash
docker compose logs -f coredns
docker compose logs -f client
```

### 💻 Entrar en una shell

```bash
docker exec -it client bash
# o
 docker exec -it coredns /bin/sh
```

### 🌐 Comprobar red y puertos

```bash
docker network ls
docker network inspect docker_tierramedia
sudo ss -ltnp | grep :5353
```

### ⛔ Parar el despliegue, eliminando los contenedores

> Opción 1: Parada de despliegue y eliminado de contenedores de memoria
```bash
docker compose down
```
> Opción 2: Eliminando además los volúmenes asociados a los contenedores
```bash
docker compose down -v
```

---

## 🔍 4. Pruebas DNS

### Desde el cliente

```bash
docker exec -it client bash
dig @192.168.103.253 tierramedia.jc A
dig @192.168.103.253 comarca.tierramedia.jc A
nslookup comarca.tierramedia.jc 192.168.103.253
```

### Desde el host docker (local o en la nube)

```bash
dig @127.0.0.1 -p 5353 tierramedia.jc A
```

> ✅ Debería resolver `tierramedia.jc` y `comarca.tierramedia.jc` hacia `192.168.103.253`.

---

## 🧾 5. Explicación detallada de `docker-compose.yaml`

---

💡 **Propósito:**

Este archivo configura un entorno de pruebas DNS en Docker, compuesto por dos servicios: 
- **CoreDNS** actúa como servidor DNS de la red “tierramedia”.
- **Lothlorien** es un cliente Ubuntu conectado a esa red, utilizando el DNS configurado.

---

💡 **Bloques:**

- **services:** define los contenedores gestionados por Compose.
- **coredns:** usa la imagen oficial, monta los archivos de configuración y expone los puertos 53/8080.
- **client:** Ubuntu que instala herramientas de red y mantiene un proceso activo (`sleep infinity`).
- **networks:** crea una red tipo *bridge* con IPs estáticas.

---

💡 **Explicación detallada:**

A continuación se documenta línea por línea.

## services:

Define los servicios (contenedores) que se lanzarán.

---

### coredns-comarca

```yaml
  coredns-comarca:
    image: coredns/coredns:latest
```
Usa la imagen oficial más reciente de **CoreDNS** desde Docker Hub.

```yaml
    container_name: coredns
```
Asigna el nombre del contenedor como `coredns`.

```yaml
    command: -conf /etc/coredns/Corefile -dns.port 53
```
Ejecuta CoreDNS indicando el archivo de configuración (`Corefile`) y el puerto DNS estándar (53).

```yaml
    stdin_open: true
    tty: true
```
Permite mantener la consola interactiva abierta para depuración o acceso manual.

```yaml
    restart: unless-stopped
```
Configura el contenedor para reiniciarse automáticamente salvo que sea detenido manualmente.

```yaml
    ports:
      - "5353:53"
      - "5353:53/udp"
      - "8080:8080"
```
Expone los puertos:
- `5353:53` (TCP) → redirige el puerto DNS al host.
- `5353:53/udp` (UDP) → necesario para consultas DNS.
- `8080:8080` → puerto del panel web de CoreDNS (si se usa).

```yaml
    volumes:
      - ./conf/Corefile:/etc/coredns/Corefile
      - ./conf/db.tierramedia.jc:/etc/coredns/db.tierramedia.jc
```
Monta archivos locales de configuración en el contenedor:
- `Corefile`: archivo principal de configuración DNS.
- `db.tierramedia.jc`: zona DNS personalizada.

```yaml
    networks:
      tierramedia:
        ipv4_address: 192.168.103.253
```
Asigna una IP fija dentro de la red `tierramedia` al servidor DNS.

```yaml
    domainname: tierramedia.jc
    hostname: comarca
```
Define el dominio (`tierramedia.jc`) y el nombre de host (`comarca`) del contenedor.

---

### client-lothlorien

Contenedor que simula un cliente dentro de la red.

```yaml
  client-lothlorien:
    image: ubuntu:latest
```
Usa la imagen base más reciente de **Ubuntu**.

```yaml
    container_name: lothlorien
```
Asigna el nombre del contenedor como `lothlorien`.

```yaml
    command: bash -c "
      echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections &&
      echo 'tzdata tzdata/Zones/Europe select Madrid' | debconf-set-selections &&
      apt update &&
      DEBIAN_FRONTEND=noninteractive apt install -y tzdata &&
      dpkg-reconfigure --frontend noninteractive tzdata &&
      apt upgrade -y &&
      apt install -y
        iputils-ping
        dnsutils
        net-tools &&
      sleep infinity"
```
Ejecuta una serie de comandos al iniciar el contenedor:
1. Configura la zona horaria (Europa/Madrid) sin interacción.
2. Actualiza el sistema e instala utilidades de red:
   - `iputils-ping`: para hacer ping.
   - `dnsutils`: incluye `dig` y `nslookup`.
   - `net-tools`: incluye `ifconfig`, `netstat`, etc.
3. Ejecuta `sleep infinity` para mantener el contenedor activo.

```yaml
    stdin_open: true
    tty: true
```
Permite mantener la consola activa y usar terminal interactiva.

```yaml
    #entrypoint: /bin/bash
```
Línea comentada: si se descomenta, el contenedor iniciaría directamente en bash.

```yaml
    depends_on:
      - coredns-comarca
```
Indica que este contenedor debe iniciarse **después** del servidor `coredns-comarca`.

```yaml
    volumes:
      - /etc/passwd:/etc/passwd:ro
      - /etc/group:/etc/group:ro
```
Monta archivos del sistema host en modo solo lectura (`ro`), permitiendo coincidencia de usuarios y grupos.

```yaml
    networks:
      tierramedia:
        ipv4_address: 192.168.103.16
```
Asigna IP fija al cliente dentro de la red `tierramedia`.

```yaml
    dns:
      - 192.168.103.253
```
Configura el servidor DNS del cliente apuntando al contenedor `coredns-comarca`.

```yaml
    domainname: tierramedia.jc
    hostname: lothlorien
```
Define el dominio (`tierramedia.jc`) y el nombre del host (`lothlorien`).

---

## networks:

Define las redes que usarán los contenedores.

```yaml
  default:
    driver: bridge 
```
Crea una red por defecto con el controlador `bridge` (estándar de Docker).

```yaml
  tierramedia:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.103.0/24
```
Define una red personalizada llamada `tierramedia` con:
- Controlador `bridge`.
- Subred `192.168.103.0/24`, dentro de la cual se asignan las IPs estáticas.

---

## 🧩 6. Explicación de `Corefile`

Bloque raíz `.:53` → redirige consultas desconocidas a Google DNS (8.8.8.8, 8.8.4.4) y publica endpoint de salud `:8080`.

Bloque `tierramedia.jc:53` → sirve registros locales desde `db.tierramedia.jc`.

> 🔁 Si no hay coincidencia con la zona local, se reenvía la consulta a Google DNS.

---

## 📜 7. Explicación de `db.tierramedia.jc`

- `$ORIGIN tierramedia.jc.` → dominio raíz de la zona.
- `SOA` → define autoridad de la zona y parámetros de refresco.
- `A` → registros principales (`comarca` y `@`) apuntan a `192.168.103.253`.
- `CNAME` → alias `ns` que apunta a `comarca`.

---

## 💡 8. Notas y recomendaciones

- 🔁 **Reiniciar CoreDNS:** `docker compose restart coredns`
- 🧮 **Incrementar el serial SOA** tras cada cambio.
- ⚠️ **Evitar conflictos en el puerto 53** con otros resolvers locales.
- 📈 **Logs detallados:** útiles para depuración, pero generan ruido.
- 🧰 **Pruebas avanzadas:** usar `tcpdump -i any port 5353` o `dig +tcp` para analizar tráfico.

---

**Autor:** 🧑‍💻 *Germán López Castro*
