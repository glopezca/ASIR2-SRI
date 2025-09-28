# JSON y YAML: Conceptos, Sintaxis y Usos

## 1. Introducción

JSON y YAML son dos formatos de serialización de datos muy utilizados en
sistemas modernos. Ambos permiten representar información de manera
estructurada y legible, aunque con diferencias en sintaxis y casos de
uso.

-   **JSON (JavaScript Object Notation)**: formato ligero basado en
    texto, muy extendido en aplicaciones web y APIs.\
-   **YAML (YAML Ain't Markup Language)**: formato más legible para
    humanos, muy usado en configuración de aplicaciones, sistemas y
    contenedores.

------------------------------------------------------------------------

## 2. Estructura de JSON

### Características principales

-   Basado en objetos (`{}`) y listas (`[]`).
-   Las claves siempre deben ir entre **comillas dobles**.
-   Admite tipos: `string`, `number`, `boolean`, `null`, `array` y
    `object`.

### Ejemplo de JSON

``` json
{
  "usuario": "admin",
  "activo": true,
  "roles": ["editor", "admin"],
  "configuracion": {
    "tema": "oscuro",
    "lenguaje": "es"
  }
}
```

------------------------------------------------------------------------

## 3. Estructura de YAML

### Características principales

-   Usa indentación (espacios) en lugar de llaves `{}` o corchetes `[]`.
-   Más legible para humanos.
-   No requiere comillas en las claves (aunque se permiten).
-   Admite comentarios con `#`.

### Ejemplo de YAML

``` yaml
usuario: admin
activo: true
roles:
  - editor
  - admin
configuracion:
  tema: oscuro
  lenguaje: es
```

------------------------------------------------------------------------

## 4. Comparación rápida JSON vs YAML

  ------------------------------------------------------------------------
  Aspecto          JSON                      YAML
  ---------------- ------------------------- -----------------------------
  Legibilidad      Media (muchos símbolos)   Alta (indentación clara)
  humana                                     

  Uso principal    APIs, intercambio de      Configuración, DevOps
                   datos                     

  Comentarios      No soporta                Soporta con `#`

  Estructura       Llaves `{}`, corchetes    Indentación por espacios
                   `[]`                      

  Extensión típica `.json`                   `.yaml` o `.yml`
  ------------------------------------------------------------------------

------------------------------------------------------------------------

# Ejemplos agrupados (GNU/Linux, Docker y Kubernetes) y explicación completa de **Netplan**

## 1) Ejemplos agrupados

### Sistema GNU/Linux

**Archivo JSON del daemon de Docker (sistema):**
`/etc/docker/daemon.json`

``` json
{
  "log-driver": "json-file",
  "storage-driver": "overlay2"
}
```

**Ejemplo de `package.json` (archivo de proyecto Node.js --- aplicación
en el sistema):**

``` json
{
  "name": "mi-aplicacion",
  "version": "1.0.0",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
```

**(Referencia) Ubicación típica para Netplan:** `/etc/netplan/*.yaml`

------------------------------------------------------------------------

### Docker

**`docker-compose.yml` (YAML --- define servicios, redes y volúmenes):**

``` yaml
version: "3.9"
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: ejemplo
```

------------------------------------------------------------------------

### Kubernetes

**`deployment.yaml` (manifiesto de Kubernetes --- ejemplo básico):**

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-aplicacion
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mi-aplicacion
  template:
    metadata:
      labels:
        app: mi-aplicacion
    spec:
      containers:
        - name: web
          image: nginx:latest
          ports:
            - containerPort: 80
```

**Ejemplo de `service.yaml` (exponer el Deployment):**

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: mi-aplicacion-svc
spec:
  selector:
    app: mi-aplicacion
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

------------------------------------------------------------------------

## 2) Netplan --- explicación completa

### ¿Qué es Netplan?

Netplan es una utilidad en varias distribuciones (p. ej. Ubuntu moderno)
que **define la configuración de red** mediante archivos YAML en
`/etc/netplan/`. Netplan traduce esos archivos a la configuración del
*backend* (normalmente `systemd-networkd` o `NetworkManager`) y aplica
la configuración al sistema.

------------------------------------------------------------------------

### Estructura mínima (esqueleto)

``` yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
      dhcp4: true
```

------------------------------------------------------------------------

### Campos comunes por interfaz (descripción)

-   `dhcp4`, `dhcp6`\
-   `addresses`\
-   `gateway4`, `gateway6`\
-   `nameservers`\
-   `routes`\
-   `routing-policy`\
-   `dhcp4-overrides`, `dhcp6-overrides`\
-   `mtu`\
-   `optional`\
-   `renderer`

------------------------------------------------------------------------

### Elementos de red avanzados (ejemplos cortos)

**VLAN, Bridge, Bond, Wi-Fi** → ejemplos incluidos.

------------------------------------------------------------------------

### Ejemplo completo --- configuración estática con IPv4/IPv6, DNS, rutas y overrides

``` yaml
# /etc/netplan/01-network-static.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.10.50/24
        - 2001:db8::50/64
      gateway4: 192.168.10.1
      gateway6: 2001:db8::1
      nameservers:
        search: [example.com, local]
        addresses: [8.8.8.8, 1.1.1.1]
      routes:
        - to: 10.0.0.0/8
          via: 192.168.10.254
          metric: 100
      routing-policy:
        - from: 192.168.10.50/32
          table: 100
          priority: 100
      dhcp4-overrides:
        use-dns: false
      mtu: 1500
      optional: false
```

------------------------------------------------------------------------

### Comandos útiles (verificar/generar/aplicar)

-   `sudo netplan try`
-   `sudo netplan generate`
-   `sudo netplan apply`
-   `sudo netplan --debug apply`
-   Ver estado de interfaces y rutas: `ip addr`, `ip route`,
    `ip -6 route`

------------------------------------------------------------------------

### Resumen rápido

-   Archivos Netplan: `/etc/netplan/*.yaml`\
-   Sintaxis: YAML\
-   Elementos principales: `network`, `version`, `renderer`,
    `ethernets`, `bridges`, `vlans`, `bonds`, `wifis`\
-   Comandos: `netplan generate`, `netplan try`, `netplan apply`
