
> 🔬 **VERSIÓN V2 · REVISIÓN TÉCNICA 2026-09-18**
>
> Se ha realizado una segunda pasada sobre los bloques de código y las configuraciones prácticas. Añadida la instalación explícita del plugin `python3-certbot-apache` antes de utilizar Certbot.
>
> ⚠️ La validación automática cubre sintaxis y configuraciones aisladas; la validación extremo a extremo > de Cisco Packet Tracer, WSL2 y una VM real de Ubuntu 26.04 Server requiere ejecutar el laboratorio en esos entornos.

::: {align="center"}
# 🌐⚡ UT5 · SERVIDORES WEB (HTTP) ⚡🌐

### 🕸️ Del navegador al servidor · HTTP · HTTPS · Apache · Virtual Hosts · Proxy

``` text
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║             🌐 SERVICIOS WEB · CLIENTE ↔ SERVIDOR               ║
║                                                                  ║
║       HTTP 📡   HTTPS 🔐   Apache 🪶   Nginx 🚀   Proxy 🔀      ║
║                                                                  ║
║    🧪 Packet Tracer · WSL2 · VirtualBox + Ubuntu 26.04 Server   ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**SERVICIOS DE RED E INTERNET · CFGS ASIR**

**Material docente actualizado · 2026.09**
:::

------------------------------------------------------------------------

> 🎯 **MISIÓN DE LA UT**
>
> Comprender cómo funciona la Web desde la petición del navegador hasta
> la respuesta del servidor, y ser capaz de **instalar, configurar,
> publicar, asegurar, monitorizar y diagnosticar** un servicio web.
>
> El objetivo profesional es poder responder:
>
> **«Tengo que publicar una aplicación web. ¿Qué servidor utilizo, cómo
> lo configuro, cómo separo varios sitios, cómo lo protejo y cómo
> demuestro que funciona?»**

> ⚠️ **Actualización tecnológica**
>
> El capítulo original trabaja con Apache 2.2, IIS 7.5, Zentyal y
> ejemplos de sistemas operativos de la época. Se conserva su estructura
> conceptual, pero las prácticas se trasladan al entorno actual:
>
> -   🧪 **Cisco Packet Tracer** para la parte de red y servicios
>     básicos.
> -   🐧 **WSL2 + Ubuntu 26.04** como cliente y entorno de pruebas.
> -   🖥️ **VirtualBox + Ubuntu 26.04 Server** como plataforma principal
>     de servidor.
>
> La documentación actual de Ubuntu instala Apache mediante
> `apt install apache2` y organiza la configuración en `apache2.conf`,
> `ports.conf`, `mods-*`, `conf-*` y `sites-*`.
> citeturn3search2turn3search1

------------------------------------------------------------------------

# 🧭 Mapa de la unidad

``` text
                         🌐 WEB
                           │
             ┌─────────────┼─────────────┐
             │             │             │
           HTTP          HTTPS         PROXY
             │             │             │
          TCP/80        TLS/443       🔀 caché
             │             │             │
             └──────┬──────┴──────┬──────┘
                    │             │
                 Apache          Nginx
                    │             │
              ┌─────┴─────┐      │
              │           │      │
          VirtualHost   módulos   │
              │           │       │
              └──────┬────┴───────┘
                     ▼
                 🗂️ SITIOS
                     │
             ┌───────┴────────┐
             │                │
          estático          aplicación
             │                │
             └───────┬────────┘
                     ▼
                🔐 SEGURIDAD
                     │
          TLS · permisos · logs
```

------------------------------------------------------------------------

# 🎯 0. Objetivos

Al finalizar esta unidad deberás ser capaz de:

-   Explicar qué es la Web y cómo se relaciona con Internet.
-   Identificar los principales componentes de una arquitectura web.
-   Diferenciar página web, sitio web y aplicación web.
-   Comprender el papel del navegador.
-   Diferenciar URI, URL y otros identificadores de recursos.
-   Explicar el funcionamiento básico de HTTP.
-   Interpretar una petición HTTP.
-   Interpretar una respuesta HTTP.
-   Conocer los principales métodos HTTP.
-   Interpretar códigos de estado.
-   Comprender cabeceras HTTP.
-   Explicar cookies, caché, compresión y redirecciones.
-   Comprender MIME y `Content-Type`.
-   Diferenciar HTTP y HTTPS.
-   Comprender TLS y certificados digitales.
-   Instalar y configurar Apache.
-   Comprender la arquitectura de configuración de Apache en Ubuntu.
-   Activar y desactivar módulos.
-   Crear sitios virtuales.
-   Configurar autenticación y control de acceso.
-   Configurar HTTPS en un laboratorio.
-   Analizar logs de acceso y errores.
-   Utilizar herramientas de diagnóstico HTTP.
-   Comprender el funcionamiento básico de un proxy web.
-   Comparar Apache y Nginx.
-   Diagnosticar problemas de conectividad, configuración, permisos y
    TLS.

------------------------------------------------------------------------

# 🚀 1. Introducción

La Web es uno de los servicios de red más utilizados.

Conceptualmente:

``` text
        🌐 INTERNET
             │
             │ HTTP / HTTPS
             ▼
       ┌─────────────┐
       │   SERVIDOR  │
       │     WEB     │
       └──────┬──────┘
              │
              ▼
         recurso web
```

Pero una página web aparentemente sencilla puede implicar:

``` text
DNS
 ↓
TCP
 ↓
TLS
 ↓
HTTP
 ↓
Servidor web
 ↓
Aplicación
 ↓
Base de datos
```

Por eso un administrador de sistemas debe entender tanto el protocolo
como la infraestructura que lo soporta.

------------------------------------------------------------------------

# 🌍 2. WWW

**WWW --- World Wide Web** es un sistema distribuido de información
construido sobre Internet.

Sus elementos fundamentales incluyen:

``` text
🌐 recursos
🔗 enlaces
🧭 identificadores
📡 HTTP/HTTPS
🖥️ servidores
🌎 clientes
```

No debe confundirse:

``` text
Internet ≠ Web
```

Internet es la infraestructura y conjunto de redes interconectadas.

La Web es uno de los servicios que funciona sobre Internet.

------------------------------------------------------------------------

# 🏛️ 3. W3C y estándares Web

La Web se apoya en estándares.

El **W3C --- World Wide Web Consortium** ha desempeñado históricamente
un papel central en la estandarización de tecnologías Web.

Entre las tecnologías relacionadas encontramos:

``` text
HTML
CSS
DOM
HTTP
URI
```

Actualmente muchas especificaciones Web se desarrollan también en
colaboración con otros organismos y comunidades, por lo que no debe
interpretarse que «todo estándar Web» procede exclusivamente del W3C.

> 🧠 **Idea clave**
>
> Un administrador no necesita memorizar la organización que mantiene
> cada especificación, pero sí debe comprender que la interoperabilidad
> de la Web depende de estándares abiertos y protocolos bien definidos.

------------------------------------------------------------------------

# 🧩 4. Componentes y funcionamiento

Una arquitectura web básica:

``` text
┌──────────────┐
│   NAVEGADOR  │
└──────┬───────┘
       │
       │ HTTP/HTTPS
       ▼
┌──────────────┐
│ SERVIDOR WEB │
└──────┬───────┘
       │
       ├── HTML
       ├── CSS
       ├── JS
       ├── imágenes
       └── aplicación
```

En una aplicación dinámica:

``` text
NAVEGADOR
    │
    ▼
WEB SERVER
    │
    ▼
APLICACIÓN
    │
    ▼
BASE DE DATOS
```

------------------------------------------------------------------------

# 🧭 5. URIs y URLs

Una **URI --- Uniform Resource Identifier** identifica un recurso.

Una **URL --- Uniform Resource Locator** proporciona además información
para localizarlo mediante un mecanismo de acceso.

Ejemplo:

``` text
https://www.ejemplo.test:443/alumnos/ut5/index.html?grupo=asir#inicio
│      │                    │            │             │        │
│      │                    │            │             │        └─ fragmento
│      │                    │            │             └─ consulta
│      │                    │            └─ recurso
│      │                    └─ puerto
│      └─ autoridad/host
└─ esquema
```

La estructura conceptual ayuda a interpretar cualquier URL.

------------------------------------------------------------------------

# 🏠 6. Páginas, sitios y aplicaciones

## Página web

Un recurso concreto:

``` text
/index.html
```

## Sitio web

Conjunto organizado de recursos:

``` text
www.ejemplo.test
├── index.html
├── css/
├── js/
├── img/
└── documentos/
```

## Aplicación web

Incluye lógica de aplicación:

``` text
Navegador
    │
    ▼
HTTP
    │
    ▼
Web server
    │
    ▼
Aplicación
    │
    ▼
BD
```

Ejemplos de tecnologías de aplicación:

``` text
PHP
Python
Node.js
Java
.NET
```

> ⚠️ **Servidor web ≠ aplicación web**
>
> Apache puede servir directamente contenido estático y actuar como
> parte de una arquitectura que entrega peticiones a una aplicación.

------------------------------------------------------------------------

# 🖥️ 7. Servidores web

Un servidor web:

-   escucha peticiones;
-   recibe solicitudes HTTP;
-   localiza o genera recursos;
-   devuelve respuestas;
-   registra actividad;
-   aplica políticas de acceso;
-   puede terminar TLS;
-   puede actuar como proxy o reverse proxy.

Ejemplos:

``` text
Apache HTTP Server
Nginx
Caddy
Microsoft IIS
```

En esta UT utilizaremos principalmente:

``` text
🪶 Apache 2.4
```

y compararemos conceptos con:

``` text
🚀 Nginx
```

------------------------------------------------------------------------

# 🌐 8. Clientes web

El cliente habitual es el navegador:

``` text
Firefox
Chrome
Edge
Safari
```

Pero también podemos utilizar:

``` bash
curl
wget
```

Esto es especialmente útil para administración.

Ejemplo:

``` bash
curl http://192.168.10.10/
```

Cabeceras:

``` bash
curl -I http://192.168.10.10/
```

Modo detallado:

``` bash
curl -v http://192.168.10.10/
```

HTTPS:

``` bash
curl -vk https://192.168.10.10/
```

> 🧠 Para administración de sistemas, `curl` es tan importante como el
> navegador.

------------------------------------------------------------------------

# 🔀 9. Proxies web

Un proxy se sitúa entre cliente y servidor.

``` text
CLIENTE
   │
   ▼
┌────────┐
│ PROXY  │
└───┬────┘
    │
    ▼
SERVIDOR
```

Puede utilizarse para:

-   caché;
-   control de acceso;
-   filtrado;
-   registro;
-   salida común a Internet;
-   inspección, según configuración;
-   proxy inverso.

------------------------------------------------------------------------

# 🔄 10. Proxy directo y reverse proxy

## Proxy directo

El cliente conoce el proxy:

``` text
CLIENTE
   │
   ▼
PROXY ───────► INTERNET
```

## Reverse proxy

El cliente cree comunicarse con el servicio final:

``` text
CLIENTE
   │
   ▼
REVERSE PROXY
   │
   ├────► APP 1
   ├────► APP 2
   └────► APP 3
```

Nginx y Apache pueden utilizarse en arquitecturas de reverse proxy.

------------------------------------------------------------------------

# 📡 11. HTTP

**HTTP --- Hypertext Transfer Protocol** es un protocolo de aplicación
basado en un modelo petición/respuesta.

``` text
CLIENTE                         SERVIDOR

     ──────── HTTP REQUEST ─────────►
     ◄─────── HTTP RESPONSE ─────────
```

Ejemplo:

``` http
GET /index.html HTTP/1.1
Host: www.asir.test
Accept: text/html
```

Respuesta:

``` http
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1234
```

------------------------------------------------------------------------

# 🔬 12. Funcionamiento básico de HTTP

Proceso simplificado:

``` text
1. Resolver nombre
       ↓
2. Conectar TCP
       ↓
3. [TLS si HTTPS]
       ↓
4. Enviar petición HTTP
       ↓
5. Procesar petición
       ↓
6. Generar respuesta
       ↓
7. Transferir contenido
```

Con HTTP/1.1 y versiones posteriores pueden existir conexiones
persistentes y otras optimizaciones.

------------------------------------------------------------------------

# 📨 13. Mensaje HTTP

Una petición HTTP contiene conceptualmente:

``` text
Línea inicial
Cabeceras
Línea vacía
Cuerpo opcional
```

Ejemplo:

``` http
GET /index.html HTTP/1.1
Host: www.asir.test
User-Agent: Mozilla/5.0
Accept: text/html
```

Respuesta:

``` http
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 512

<html>
...
</html>
```

------------------------------------------------------------------------

# 🔧 14. Métodos HTTP

  Método      Uso habitual
  ----------- --------------------------------------
  `GET`       Obtener recurso
  `HEAD`      Obtener cabeceras sin cuerpo
  `POST`      Enviar/procesar datos
  `PUT`       Crear/reemplazar recurso
  `PATCH`     Modificar parcialmente
  `DELETE`    Eliminar recurso
  `OPTIONS`   Consultar opciones
  `TRACE`     Diagnóstico; normalmente restringido

### GET

``` http
GET /index.html HTTP/1.1
```

### POST

``` http
POST /login HTTP/1.1
```

con datos en el cuerpo.

> ⚠️ No debe explicarse `POST` simplemente como «más seguro que GET».
>
> La seguridad depende del protocolo, transporte, aplicación, validación
> y control de acceso. HTTPS protege el transporte, no convierte
> automáticamente una aplicación en segura.

------------------------------------------------------------------------

# 📋 15. Cabeceras HTTP

Las cabeceras aportan metadatos.

Ejemplos:

``` text
Host
User-Agent
Accept
Accept-Encoding
Content-Type
Content-Length
Authorization
Cookie
Cache-Control
Location
Server
Set-Cookie
```

Ejemplo:

``` http
Host: www.asir.test
Accept: text/html
Accept-Encoding: gzip
```

------------------------------------------------------------------------

# 📦 16. Códigos de estado

Los códigos HTTP se agrupan:

``` text
1xx → información
2xx → éxito
3xx → redirección
4xx → error del cliente
5xx → error del servidor
```

Los más importantes:

    Código Significado
  -------- -----------------------
       200 OK
       201 Created
       204 No Content
       301 Moved Permanently
       302 Found
       304 Not Modified
       400 Bad Request
       401 Unauthorized
       403 Forbidden
       404 Not Found
       405 Method Not Allowed
       429 Too Many Requests
       500 Internal Server Error
       502 Bad Gateway
       503 Service Unavailable
       504 Gateway Timeout

> 🧠 Diferencia fundamental:
>
> **401** indica que falta autenticación válida.
>
> **403** indica que el servidor entiende la petición pero rechaza el
> acceso.

------------------------------------------------------------------------

# 🔁 17. Redirecciones

Una redirección puede indicar:

``` http
HTTP/1.1 301 Moved Permanently
Location: https://www.asir.test/
```

Es habitual utilizarla para:

``` text
HTTP → HTTPS
www → dominio canónico
URL antigua → URL nueva
```

Ejemplo Apache:

``` apache
Redirect permanent / https://www.asir.test/
```

------------------------------------------------------------------------

# 🗂️ 18. MIME y Content-Type

HTTP necesita indicar qué tipo de contenido se está entregando.

Ejemplos:

``` text
text/html
text/css
text/javascript
application/json
image/png
image/jpeg
application/pdf
application/zip
```

Ejemplo:

``` http
Content-Type: text/html; charset=UTF-8
```

El servidor utiliza su configuración MIME para relacionar extensiones y
tipos de contenido.

------------------------------------------------------------------------

# 🍪 19. Cookies

HTTP es fundamentalmente stateless: cada petición no tiene por qué
mantener estado de aplicación por sí misma.

Las cookies permiten asociar peticiones con información persistente del
lado del cliente.

Servidor:

``` http
Set-Cookie: sesion=abc123; Secure; HttpOnly
```

Cliente:

``` http
Cookie: sesion=abc123
```

### Atributos importantes

``` text
Secure
HttpOnly
SameSite
Domain
Path
Max-Age / Expires
```

> 🛡️ Una cookie con `HttpOnly` dificulta el acceso desde JavaScript,
> pero no sustituye otras medidas de seguridad frente a XSS, CSRF o
> secuestro de sesión.

------------------------------------------------------------------------

# 🧠 20. Caché

La caché reduce transferencias y latencia.

``` text
CLIENTE
   │
   │ petición
   ▼
CACHE
   │
   ├── HIT  → devuelve copia
   │
   └── MISS → consulta servidor
```

Cabeceras relacionadas:

``` text
Cache-Control
ETag
Last-Modified
Expires
If-None-Match
If-Modified-Since
```

Una respuesta:

``` http
304 Not Modified
```

permite al cliente reutilizar una representación almacenada cuando
corresponde.

------------------------------------------------------------------------

# 🗜️ 21. Compresión

Las respuestas pueden comprimirse para reducir el tráfico.

Cabecera típica:

``` http
Accept-Encoding: gzip, br
```

y respuesta:

``` http
Content-Encoding: gzip
```

La compresión puede reducir el tamaño de recursos textuales:

``` text
HTML
CSS
JavaScript
JSON
```

Pero hay que considerar:

-   consumo de CPU;
-   tamaño del recurso;
-   caché;
-   contenido ya comprimido.

------------------------------------------------------------------------

# 🔗 22. Conexiones persistentes

Abrir una conexión TCP tiene un coste.

Las conexiones persistentes permiten reutilizar una conexión para varias
peticiones.

``` text
TCP
 │
 ├── GET /
 ├── GET /style.css
 ├── GET /app.js
 └── GET /logo.png
```

HTTP/1.1 estableció las conexiones persistentes como comportamiento
normal, mientras que HTTP/2 y HTTP/3 introducen mecanismos más avanzados
de multiplexación y transporte.

------------------------------------------------------------------------

# ⚡ 23. HTTP/2 y HTTP/3

El capítulo original se centra en HTTP/1.x. En una infraestructura
actual conviene conocer la evolución.

``` text
HTTP/1.1
   │
   ▼
HTTP/2
   │
   ▼
HTTP/3
```

### HTTP/2

Introduce, entre otras características:

-   multiplexación;
-   compresión de cabeceras;
-   streams;
-   priorización.

### HTTP/3

Utiliza:

``` text
QUIC
 ↓
UDP
 ↓
HTTP/3
```

> 🧠 Esto no elimina la importancia de HTTP/1.1 para el aprendizaje:
> comprender petición/respuesta, cabeceras, códigos y métodos sigue
> siendo fundamental.

------------------------------------------------------------------------

# 🔐 24. Seguridad Web

Un servidor web debe proteger:

``` text
🔐 comunicación
👤 identidad
📂 recursos
🧩 aplicación
📜 logs
🖥️ sistema operativo
```

Amenazas habituales:

-   exposición accidental de ficheros;
-   permisos incorrectos;
-   credenciales transmitidas sin TLS;
-   vulnerabilidades de aplicación;
-   inyección;
-   XSS;
-   CSRF;
-   configuración insegura;
-   directorios publicados accidentalmente;
-   versiones vulnerables;
-   certificados incorrectos.

------------------------------------------------------------------------

# 🔒 25. HTTPS

HTTPS es HTTP transportado sobre TLS.

``` text
HTTP
  │
  ▼
 TLS 🔐
  │
  ▼
TCP
```

Tradicionalmente:

``` text
HTTP  → TCP/80
HTTPS → TCP/443
```

Con HTTP/3:

``` text
HTTP/3 → QUIC/UDP/443
```

------------------------------------------------------------------------

# 🧬 26. TLS

Durante el establecimiento de TLS se negocian parámetros criptográficos
y el servidor presenta un certificado.

Conceptualmente:

``` text
CLIENTE
   │
   │ ClientHello
   ▼
SERVIDOR
   │
   │ ServerHello + certificado
   ▼
CLIENTE
   │
   │ verifica certificado
   ▼
🔐 canal cifrado
```

El certificado permite vincular una identidad de servidor con una clave
pública mediante una infraestructura de confianza.

------------------------------------------------------------------------

# 📜 27. Certificados

Un certificado X.509 puede contener:

-   identidad del sujeto;
-   clave pública;
-   entidad emisora;
-   periodo de validez;
-   extensiones;
-   firma de la CA.

Un certificado de laboratorio puede ser autofirmado:

``` text
Servidor
   │
   └── firma su propio certificado
```

Pero los navegadores no lo consideran automáticamente confiable.

Para producción se utiliza una CA reconocida o una CA corporativa que
los clientes confíen explícitamente.

------------------------------------------------------------------------

# 🧪 28. HTTPS de laboratorio

Para el laboratorio podemos utilizar certificados autofirmados.

``` text
/etc/ssl/
├── certs/
└── private/
```

Ejemplo:

``` bash
sudo openssl req -x509 -newkey rsa:2048 \
  -keyout /etc/ssl/private/asir.test.key \
  -out /etc/ssl/certs/asir.test.crt \
  -days 365 \
  -nodes
```

> ⚠️ Este certificado sirve para **laboratorio**.
>
> No debe utilizarse como modelo de emisión de certificados públicos.

------------------------------------------------------------------------

# 🪶 29. Apache en Ubuntu 26.04 Server

Instalación:

``` bash
sudo apt update
sudo apt install apache2
```

Comprobar:

``` bash
systemctl status apache2
```

Puerto:

``` bash
sudo ss -ltnp | grep -E ':80|:443'
```

Prueba:

``` bash
curl http://localhost/
```

Ubuntu documenta `apache2` como el servidor HTTP actual disponible
mediante APT. citeturn3search2

------------------------------------------------------------------------

# 🗂️ 30. Arquitectura de Apache en Ubuntu

La estructura principal:

``` text
/etc/apache2/
├── apache2.conf
├── ports.conf
├── mods-available/
├── mods-enabled/
├── conf-available/
├── conf-enabled/
├── sites-available/
└── sites-enabled/
```

La configuración está modularizada mediante enlaces simbólicos.

``` text
mods-available
      │
      │ a2enmod
      ▼
mods-enabled
```

y:

``` text
sites-available
      │
      │ a2ensite
      ▼
sites-enabled
```

Ubuntu documenta esta organización explícitamente. citeturn3search2

------------------------------------------------------------------------

# 🔧 31. Directivas fundamentales

En un VirtualHost:

``` apache
<VirtualHost *:80>
    ServerName www.asir.test
    ServerAlias asir.test

    DocumentRoot /srv/www/asir
</VirtualHost>
```

Las directivas principales:

``` text
Listen
ServerName
ServerAlias
DocumentRoot
DirectoryIndex
ErrorLog
CustomLog
<Directory>
```

------------------------------------------------------------------------

# 📁 32. DocumentRoot

El `DocumentRoot` indica dónde se encuentran los recursos publicados.

Ejemplo:

``` text
/srv/www/asir/
├── index.html
├── css/
├── js/
└── img/
```

Configuración:

``` apache
DocumentRoot /srv/www/asir
```

Ubuntu utiliza `/var/www/html` como DocumentRoot del sitio
predeterminado, aunque podemos crear estructuras propias como
`/srv/www/...`. citeturn3search1

------------------------------------------------------------------------

# 🧪 33. PRÁCTICA 5.1 --- Explorar HTTP con curl

Desde WSL2:

``` bash
curl -I https://example.com
```

Después:

``` bash
curl -v https://example.com
```

Identifica:

``` text
versión HTTP
código de estado
Server
Content-Type
Content-Length
Location
Cache-Control
```

### Entrega

Captura una respuesta y explica cada cabecera relevante.

------------------------------------------------------------------------

# 🧪 34. PRÁCTICA 5.2 --- Analizar HTTP con Wireshark

En un laboratorio sin TLS:

``` bash
curl http://192.168.10.10/
```

Captura:

``` text
tcp.port == 80
```

Identifica:

``` text
GET
Host
User-Agent
HTTP/1.1 200 OK
Content-Type
```

### Pregunta

¿Por qué no podemos aplicar exactamente el mismo análisis al contenido
de HTTPS?

------------------------------------------------------------------------

# 🧪 35. PRÁCTICA 5.3 --- Instalación y configuración básica de Apache

Instala:

``` bash
sudo apt update
sudo apt install apache2
```

Comprueba:

``` bash
systemctl status apache2
```

Abre:

``` text
http://IP_DEL_SERVIDOR/
```

Comprueba:

``` bash
curl -I http://localhost/
```

Consulta:

``` bash
ls -la /var/www/html/
```

### Evidencias

``` text
✔ servicio activo
✔ puerto 80
✔ página inicial
✔ respuesta HTTP
```

------------------------------------------------------------------------

# 🧪 36. PRÁCTICA 5.4 --- Primera web

Crea:

``` bash
sudo mkdir -p /srv/www/asir
```

Página:

``` bash
sudo nano /srv/www/asir/index.html
```

Contenido:

``` html
<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>ASIR · UT5</title>
</head>
<body>
    <h1>🌐 Servidor Web ASIR</h1>
    <p>Esta página procede de Apache.</p>
</body>
</html>
```

Configura un VirtualHost:

``` bash
sudo nano /etc/apache2/sites-available/asir.test.conf
```

``` apache
<VirtualHost *:80>
    ServerName asir.test
    DocumentRoot /srv/www/asir

    <Directory /srv/www/asir>
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/asir_error.log
    CustomLog ${APACHE_LOG_DIR}/asir_access.log combined
</VirtualHost>
```

Activa:

``` bash
sudo a2ensite asir.test.conf
```

Desactiva, si procede:

``` bash
sudo a2dissite 000-default.conf
```

Comprueba:

``` bash
sudo apache2ctl configtest
```

Recarga:

``` bash
sudo systemctl reload apache2
```

------------------------------------------------------------------------

# 🧪 37. PRÁCTICA 5.5 --- DNS + VirtualHost

Utiliza la UT3.

Crea:

``` text
www.asir.test
```

y:

``` text
www.daw.test
```

Ambos deben resolver a:

``` text
192.168.10.10
```

Apache:

``` text
www.asir.test → /srv/www/asir
www.daw.test  → /srv/www/daw
```

Prueba:

``` bash
curl http://www.asir.test/
curl http://www.daw.test/
```

### Objetivo

Demostrar que:

``` text
DNS
 +
Host:
 +
VirtualHost
```

permiten servir sitios diferentes desde una misma IP.

Apache documenta los Virtual Hosts basados en nombre como una forma de
alojar varios sitios sobre una misma dirección IP.
citeturn3search3turn3search11

------------------------------------------------------------------------

# 🧪 38. PRÁCTICA 5.6 --- Virtual Hosts y `Host`

Utiliza:

``` bash
curl -H 'Host: www.asir.test' http://192.168.10.10/
```

Después:

``` bash
curl -H 'Host: www.daw.test' http://192.168.10.10/
```

Observa cómo el mismo:

``` text
IP = 192.168.10.10
```

produce dos respuestas diferentes.

### Diagnóstico Apache

``` bash
sudo apachectl -S
```

Este comando permite inspeccionar cómo Apache interpreta los Virtual
Hosts. citeturn3search3

------------------------------------------------------------------------

# 🧪 39. PRÁCTICA 5.7 --- Módulos Apache

Lista módulos:

``` bash
apache2ctl -M
```

Lista módulos disponibles:

``` bash
ls /etc/apache2/mods-available/
```

Activa:

``` bash
sudo a2enmod rewrite
```

Comprueba:

``` bash
apache2ctl -M | grep rewrite
```

Desactiva:

``` bash
sudo a2dismod rewrite
```

Comprueba la configuración:

``` bash
sudo apache2ctl configtest
```

Ubuntu proporciona `a2enmod` y `a2dismod` para administrar módulos
dinámicos. citeturn3search0

------------------------------------------------------------------------

# 🧪 40. PRÁCTICA 5.8 --- Redirección HTTP → HTTPS

Configura:

``` text
http://www.asir.test
       │
       │ 301
       ▼
https://www.asir.test
```

Apache:

``` apache
<VirtualHost *:80>
    ServerName www.asir.test
    Redirect permanent / https://www.asir.test/
</VirtualHost>
```

Comprueba:

``` bash
curl -I http://www.asir.test/
```

Debe aparecer un código de redirección y una cabecera:

``` text
Location:
```

------------------------------------------------------------------------

# 🧪 41. PRÁCTICA 5.9 --- HTTPS con certificado de laboratorio

Activa SSL:

``` bash
sudo a2enmod ssl
```

Activa el sitio SSL:

``` bash
sudo a2ensite default-ssl
```

Comprueba:

``` bash
sudo apache2ctl configtest
```

Reinicia/recarga:

``` bash
sudo systemctl reload apache2
```

Prueba:

``` bash
curl -k https://localhost/
```

El módulo `mod_ssl` proporciona HTTPS en Apache; Ubuntu documenta
también el VirtualHost SSL predeterminado. citeturn3search0

------------------------------------------------------------------------

# 🧪 42. PRÁCTICA 5.10 --- Certificado autofirmado personalizado

Genera:

``` bash
sudo openssl req -x509 -newkey rsa:2048 \
  -keyout /etc/ssl/private/asir.test.key \
  -out /etc/ssl/certs/asir.test.crt \
  -days 365 \
  -nodes
```

Configura:

``` apache
<VirtualHost *:443>
    ServerName asir.test
    DocumentRoot /srv/www/asir

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/asir.test.crt
    SSLCertificateKeyFile /etc/ssl/private/asir.test.key

    <Directory /srv/www/asir>
        Require all granted
    </Directory>
</VirtualHost>
```

Prueba:

``` bash
sudo apache2ctl configtest
sudo systemctl reload apache2
curl -k https://asir.test/
```

### Analiza el certificado

``` bash
openssl s_client -connect asir.test:443 -servername asir.test
```

------------------------------------------------------------------------

# 🧪 43. PRÁCTICA 5.11 --- Autenticación básica

Activa:

``` bash
sudo a2enmod auth_basic
```

Crea directorio:

``` bash
sudo mkdir -p /srv/www/privado
```

Crea fichero de contraseñas:

``` bash
sudo htpasswd -c /etc/apache2/.htpasswd alumno
```

Configura:

``` apache
<Directory /srv/www/privado>
    AuthType Basic
    AuthName "Zona ASIR"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>
```

Comprueba:

``` bash
curl -u alumno:CONTRASEÑA http://asir.test/privado/
```

> ⚠️ Basic Authentication sin HTTPS no protege adecuadamente las
> credenciales frente a un observador de red. Utilízala en el
> laboratorio para comprender el mecanismo y combínala con HTTPS.

------------------------------------------------------------------------

# 🧪 44. PRÁCTICA 5.12 --- Control de acceso

Estudia:

``` apache
Require all granted
```

frente a:

``` apache
Require all denied
```

y:

``` apache
Require ip 192.168.10.0/24
```

Construye:

``` text
PUBLICO
  │
  └── acceso general

PRIVADO
  │
  └── solo 192.168.10.0/24
```

Prueba desde:

-   servidor;
-   WSL2;
-   otra VM.

------------------------------------------------------------------------

# 🧪 45. PRÁCTICA 5.13 --- Logs

Apache registra por defecto:

``` text
/var/log/apache2/access.log
/var/log/apache2/error.log
```

Ubuntu documenta `CustomLog` y `ErrorLog` para controlar estos
registros. citeturn3search1

Observa:

``` bash
sudo tail -f /var/log/apache2/access.log
```

En otra terminal:

``` bash
curl http://localhost/
```

Comprueba:

``` bash
sudo tail -f /var/log/apache2/error.log
```

### Analiza

-   IP origen;
-   fecha;
-   método;
-   URL;
-   código;
-   tamaño;
-   User-Agent.

------------------------------------------------------------------------

# 🧪 46. PRÁCTICA 5.14 --- Diagnóstico de errores HTTP

Provoca:

``` text
404
403
401
500
```

Para cada uno documenta:

``` text
Petición
   ↓
Código HTTP
   ↓
Log
   ↓
Causa
   ↓
Corrección
```

### Herramientas

``` bash
curl -I
curl -v
apachectl -S
apache2ctl -M
journalctl -u apache2
tail /var/log/apache2/*
```

------------------------------------------------------------------------

# 🧪 47. PRÁCTICA 5.15 --- Monitorización con `ss`, `curl` y `tcpdump`

Comprueba:

``` bash
sudo ss -ltnp | grep apache
```

Captura:

``` bash
sudo tcpdump -ni any port 80
```

En otra terminal:

``` bash
curl http://localhost/
```

Observa:

``` text
TCP handshake
HTTP request
HTTP response
TCP close / reutilización
```

------------------------------------------------------------------------

# 🧪 48. PRÁCTICA 5.16 --- HTTP con Wireshark

Captura:

``` text
tcp.port == 80
```

Busca:

``` text
GET
HTTP/1.1
Host
User-Agent
200 OK
Content-Type
```

Utiliza:

``` text
Follow → TCP Stream
```

### Después repite con HTTPS

Filtro:

``` text
tcp.port == 443
```

Compara:

``` text
HTTP
   → contenido visible

HTTPS
   → contenido HTTP protegido por TLS
```

------------------------------------------------------------------------

# 🧪 49. PRÁCTICA 5.17 --- Proxy web conceptual

Construye:

``` text
WSL2
  │
  ▼
PROXY
  │
  ▼
WEB SERVER
```

Investiga y documenta:

-   proxy directo;
-   reverse proxy;
-   caché;
-   ACL;
-   logs.

Para la práctica principal puedes utilizar **Squid** como proxy
explícito:

``` bash
sudo apt install squid
```

> ⚠️ Squid es una tecnología complementaria al capítulo. El objetivo
> aquí es comprender el papel de un proxy, no convertir esta UT en una
> unidad de administración de Squid.

------------------------------------------------------------------------

# 🧪 50. PRÁCTICA 5.18 --- Reverse proxy con Nginx

Instala:

``` bash
sudo apt install nginx
```

Arquitectura:

``` text
CLIENTE
   │
   ▼
NGINX :80
   │
   ▼
APACHE :8080
```

Configura Apache para escuchar en:

``` text
8080
```

Y Nginx:

``` nginx
server {
    listen 80;
    server_name app.asir.test;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

Comprueba:

``` bash
curl -I http://app.asir.test/
```

### Objetivo

Distinguir:

``` text
servidor web
     ≠
reverse proxy
```

------------------------------------------------------------------------

# 🧪 51. PRÁCTICA 5.19 --- Apache + aplicación

Monta:

``` text
Navegador
    │
    ▼
Apache
    │
    ▼
Aplicación
    │
    ▼
Datos
```

Puedes utilizar una aplicación sencilla en Python:

``` bash
python3 -m http.server 9000
```

Apache/Nginx actuará como reverse proxy.

Comprueba:

``` text
Cliente → proxy → aplicación
```

### Reto

Añade una segunda aplicación:

``` text
/app1 → 127.0.0.1:9000
/app2 → 127.0.0.1:9001
```

------------------------------------------------------------------------

# 🧪 52. PRÁCTICA 5.20 --- Alojamiento virtual completo

Construye:

``` text
                 DNS
                  │
        ┌─────────┴─────────┐
        │                   │
   www.asir.test       www.daw.test
        │                   │
        └─────────┬─────────┘
                  │
             192.168.10.10
                  │
                Apache
             ┌────┴────┐
             │         │
          /asir       /daw
```

Cada sitio debe tener:

``` text
index.html
CSS
favicon
logs independientes
```

Utiliza:

``` apache
ServerName
ServerAlias
DocumentRoot
CustomLog
ErrorLog
```

------------------------------------------------------------------------

# 🧪 53. PRÁCTICA 5.21 --- HTTPS para varios sitios

Configura:

``` text
www.asir.test → HTTPS
www.daw.test  → HTTPS
```

Con:

``` text
SNI
```

Cada sitio tendrá un certificado apropiado.

``` text
CLIENTE
   │
   │ TLS ClientHello + SNI
   ▼
APACHE
   │
   ├── asir.test → certificado ASIR
   └── daw.test  → certificado DAW
```

Apache y OpenSSL actuales soportan Virtual Hosts basados en nombre con
SNI. La selección del VirtualHost SSL utiliza el nombre indicado durante
el handshake TLS cuando está disponible.
citeturn3search8turn3search10

------------------------------------------------------------------------

# 🌍 54. PRÁCTICA 5.22 --- Certificado de confianza

Compara:

``` text
certificado autofirmado
```

con:

``` text
certificado emitido por una CA
```

Para una infraestructura pública actual, estudia ACME y Let's Encrypt.

Ubuntu documenta Certbot como cliente ACME recomendado para obtener
certificados de Let's Encrypt. citeturn3search4

Ejemplo conceptual:

Instala Certbot y el plugin de Apache:

``` bash
sudo apt install certbot python3-certbot-apache
```

Después:

``` bash
sudo certbot --apache -d www.ejemplo.es
```

> ⚠️ No ejecutes esta práctica contra un dominio público sin
> autorización. En laboratorio utiliza una CA propia o certificados de
> prueba.

------------------------------------------------------------------------

# 🧪 55. PRÁCTICA 5.23 --- Apache frente a Nginx

Instala ambos, pero evita conflictos de puerto.

Escenario:

``` text
Apache → 8080
Nginx  → 80
```

Compara:

  Característica                  Apache                             Nginx
  ------------------------------- ---------------------------------- ----------------------
  Modelo                          multiproceso/multihilo según MPM   orientado a eventos
  Virtual Hosts / server blocks   Sí                                 Sí
  Módulos                         Muy amplio                         Arquitectura modular
  Reverse proxy                   Sí                                 Sí
  Servir estático                 Sí                                 Sí
  HTTPS                           Sí                                 Sí
  Configuración Ubuntu            `/etc/apache2`                     `/etc/nginx`

### Reto

Explica qué servidor utilizarías en:

``` text
A. sitio estático
B. reverse proxy
C. aplicación PHP
D. infraestructura heterogénea
```

No existe una respuesta universal: debe justificarse según los
requisitos.

------------------------------------------------------------------------

# 🧪 56. PRÁCTICA 5.24 --- Seguridad de configuración

Realiza una auditoría:

``` text
☐ ¿Está activo HTTP?
☐ ¿Está activo HTTPS?
☐ ¿Hay redirección?
☐ ¿El certificado es válido?
☐ ¿Se expone información innecesaria?
☐ ¿Los permisos son correctos?
☐ ¿Hay directorios listables?
☐ ¿Se protegen zonas privadas?
☐ ¿Se registran accesos?
☐ ¿Se revisan errores?
☐ ¿Los módulos innecesarios están desactivados?
☐ ¿El software está actualizado?
```

------------------------------------------------------------------------

# 🔍 57. Diagnóstico sistemático

Cuando una web no funciona:

``` text
                   ❌ WEB NO FUNCIONA
                           │
                           ▼
                     ¿DNS resuelve?
                       /       \
                     NO         SÍ
                     │           │
                    DNS          ▼
                           ¿Conectividad?
                            /          \
                          NO            SÍ
                          │              │
                       routing           ▼
                                 ¿Puerto abierto?
                                  /          \
                                NO            SÍ
                                │              │
                            firewall           ▼
                                      ¿Apache activo?
                                       /         \
                                     NO           SÍ
                                     │             │
                                  systemd           ▼
                                             ¿VirtualHost?
                                              /       \
                                            NO         SÍ
                                            │           │
                                        Apachectl -S    ▼
                                                   ¿TLS?
                                                    /  \
                                                  NO    SÍ
                                                  │      │
                                               cert     logs
```

------------------------------------------------------------------------

# 🧰 58. Herramientas de diagnóstico

### DNS

``` bash
dig www.asir.test
```

### Conectividad

``` bash
ping 192.168.10.10
```

### Puertos

``` bash
nc -vz 192.168.10.10 80
nc -vz 192.168.10.10 443
```

### HTTP

``` bash
curl -I http://www.asir.test/
curl -v http://www.asir.test/
```

### TLS

``` bash
openssl s_client \
  -connect www.asir.test:443 \
  -servername www.asir.test
```

### Apache

``` bash
apache2ctl configtest
apachectl -S
apache2ctl -M
```

### Servicio

``` bash
systemctl status apache2
journalctl -u apache2
```

### Logs

``` bash
tail -f /var/log/apache2/access.log
tail -f /var/log/apache2/error.log
```

------------------------------------------------------------------------

# 🧪 59. Caso de diagnóstico integral

Un usuario indica:

> «`www.asir.test` no funciona.»

La resolución DNS:

``` bash
dig www.asir.test
```

devuelve:

``` text
192.168.10.10
```

Pero:

``` bash
curl http://www.asir.test/
```

devuelve:

``` text
503 Service Unavailable
```

Debes investigar:

``` text
1. DNS
2. TCP
3. Apache
4. VirtualHost
5. reverse proxy
6. aplicación
7. logs
```

### Evidencias mínimas

``` bash
dig
ss
curl -v
apachectl -S
systemctl status apache2
journalctl -u apache2
tail /var/log/apache2/error.log
```

------------------------------------------------------------------------

# 🧠 60. Arquitectura completa

Relaciona las UT anteriores:

``` text
                    🌐 CLIENTE
                         │
                         ▼
                       DNS
                         │
                         ▼
                   IP del servidor
                         │
                         ▼
                       TCP
                         │
                 ┌───────┴───────┐
                 │               │
               HTTP            HTTPS
                80               443
                 │               │
                 │              TLS
                 │               │
                 └───────┬───────┘
                         ▼
                     APACHE
                         │
               ┌─────────┼─────────┐
               │         │         │
            sitio 1    sitio 2   proxy
               │         │         │
               └─────────┴────┬────┘
                              │
                         aplicación
                              │
                              ▼
                              BD
```

------------------------------------------------------------------------

# 🧪 61. PRÁCTICA FINAL --- «Publica dos sitios seguros»

Construye en:

``` text
VirtualBox + Ubuntu 26.04 Server
```

con un cliente:

``` text
WSL2 + Ubuntu 26.04
```

## Infraestructura

``` text
WSL2
 │
 │ DNS / HTTP / HTTPS
 ▼
Ubuntu Server
 │
 ├── Apache
 │
 ├── www.asir.test
 │
 └── www.sri.test
```

## Requisitos

### DNS

``` text
www.asir.test → 192.168.10.10
www.sri.test  → 192.168.10.10
```

### Web

``` text
www.asir.test → /srv/www/asir
www.sri.test  → /srv/www/sri
```

### HTTPS

Ambos sitios:

``` text
TCP/443
TLS
SNI
```

### Seguridad

-   HTTP redirige a HTTPS.
-   Zona `/privado` protegida.
-   Permisos mínimos.
-   Logs independientes.
-   Módulos innecesarios desactivados.

### Diagnóstico

Debes demostrar:

``` text
dig
curl
openssl s_client
apachectl -S
ss
journalctl
Wireshark
```

------------------------------------------------------------------------

# 🏆 62. Reto profesional

Una empresa solicita:

``` text
                 INTERNET
                     │
                  FIREWALL
                     │
                REVERSE PROXY
                     │
          ┌──────────┼──────────┐
          │          │          │
        WEB 1      WEB 2      APP
          │          │          │
        HTTPS      HTTPS      HTTPS
```

Requisitos:

1.  Dos sitios web.
2.  Un único servidor físico/virtual.
3.  DNS.
4.  HTTPS.
5.  Redirección HTTP → HTTPS.
6.  Autenticación para una zona privada.
7.  Logs.
8.  Monitorización.
9.  Reverse proxy.
10. Diagnóstico documentado.

### Entrega

``` text
01-arquitectura.md
02-dns.md
03-apache.md
04-https.md
05-proxy.md
06-seguridad.md
07-pruebas.md
08-diagnostico.md
```

------------------------------------------------------------------------

# 📊 63. Comparativa de protocolos Web

  Tecnología   Transporte habitual         Puerto Cifrado       Uso
  ------------ ------------------------- -------- ------------- ----------------
  HTTP/1.1     TCP                             80 ❌            Web sin TLS
  HTTPS        TCP + TLS                      443 ✅            Web segura
  HTTP/2       TCP + TLS habitualmente        443 ✅ habitual   Web moderna
  HTTP/3       QUIC/UDP                       443 ✅            Web sobre QUIC

> ⚠️ No debe enseñarse «HTTP/2 = TCP/443» como una equivalencia
> absoluta: HTTP/2 está definido sobre un transporte fiable y puede
> funcionar sobre HTTP sin TLS en ciertos escenarios, aunque en la Web
> pública se utiliza predominantemente con TLS.

------------------------------------------------------------------------

# 📚 64. Apache: estructura mental

``` text
/etc/apache2/
│
├── apache2.conf       ← configuración global
├── ports.conf         ← puertos
│
├── mods-available/    ← módulos disponibles
├── mods-enabled/      ← módulos activos
│
├── conf-available/    ← configuraciones disponibles
├── conf-enabled/      ← configuraciones activas
│
├── sites-available/   ← sitios disponibles
└── sites-enabled/     ← sitios activos
```

Herramientas:

``` text
a2enmod    → activar módulo
a2dismod   → desactivar módulo

a2ensite   → activar sitio
a2dissite  → desactivar sitio

apachectl -S       → VirtualHosts
apache2ctl -M      → módulos
apache2ctl configtest → sintaxis
```

Ubuntu documenta estas utilidades y la organización modular de Apache.
citeturn3search0turn3search1

------------------------------------------------------------------------

# 🔐 65. HTTPS y producción

Para un laboratorio:

``` text
certificado autofirmado
```

Para una infraestructura pública:

``` text
DNS
 ↓
dominio real
 ↓
CA / ACME
 ↓
certificado válido
 ↓
HTTPS
```

Ubuntu documenta Certbot y los plugins para Apache y Nginx como
mecanismos para obtener y configurar certificados ACME.
citeturn3search4

### No confundir

``` text
HTTPS
  ≠
aplicación segura
```

HTTPS protege el canal.

La aplicación sigue necesitando:

``` text
validación
autorización
gestión de sesiones
protección contra XSS
protección contra CSRF
consultas seguras
actualizaciones
```

------------------------------------------------------------------------

# 🧠 66. Resumen

``` text
                       🌐 WEB
                         │
             ┌───────────┼───────────┐
             │           │           │
            URL         HTTP        TLS
             │           │           │
             │      ┌────┴────┐      │
             │      │         │      │
             │    request   response │
             │      │         │      │
             └──────┼─────────┼──────┘
                    │
                 Apache
                    │
          ┌─────────┼─────────┐
          │         │         │
       sitio A    sitio B    proxy
          │         │         │
          └─────────┴─────────┘
```

Ideas fundamentales:

1.  La Web es un servicio construido sobre Internet.
2.  HTTP utiliza un modelo petición/respuesta.
3.  URI y URL permiten identificar/localizar recursos.
4.  Los métodos HTTP expresan diferentes operaciones.
5.  Las cabeceras transportan metadatos.
6.  Los códigos 2xx, 3xx, 4xx y 5xx representan categorías de respuesta.
7.  MIME informa sobre el tipo de contenido.
8.  Las cookies permiten mantener estado entre peticiones.
9.  La caché reduce latencia y tráfico.
10. HTTPS utiliza TLS para proteger HTTP.
11. Un certificado no hace segura por sí mismo una aplicación.
12. Apache es modular.
13. Ubuntu organiza Apache mediante `mods-*`, `conf-*` y `sites-*`.
14. Los Virtual Hosts permiten alojar varios sitios en un servidor.
15. El alojamiento basado en nombres permite compartir una IP.
16. SNI permite seleccionar el sitio/certificado durante TLS.
17. Los logs son fundamentales para diagnóstico y auditoría.
18. `curl`, `openssl`, `ss`, `tcpdump` y Wireshark permiten observar el
    funcionamiento real.
19. Un reverse proxy puede separar el acceso público de las
    aplicaciones.
20. Nginx y Apache pueden desempeñar funciones de servidor y proxy,
    según configuración.

------------------------------------------------------------------------

# ❓ 67. Autoevaluación

1.  ¿Qué diferencia existe entre Internet y la Web?
2.  ¿Qué papel desempeña HTTP?
3.  ¿Qué diferencia existe entre URI y URL?
4.  ¿Qué diferencia existe entre página, sitio y aplicación web?
5.  ¿Qué es un servidor web?
6.  ¿Qué diferencia existe entre proxy directo y reverse proxy?
7.  ¿Qué estructura básica tiene una petición HTTP?
8.  ¿Qué estructura básica tiene una respuesta HTTP?
9.  ¿Qué función tiene la cabecera `Host`?
10. ¿Qué diferencias fundamentales existen entre GET y POST?
11. ¿Qué significan las familias 2xx, 3xx, 4xx y 5xx?
12. ¿Qué diferencia existe entre 401 y 403?
13. ¿Qué función tiene `Content-Type`?
14. ¿Qué es una cookie?
15. ¿Qué mecanismos HTTP participan en la caché?
16. ¿Qué es una conexión persistente?
17. ¿Qué diferencia existe entre HTTP y HTTPS?
18. ¿Qué función desempeña TLS?
19. ¿Qué información aporta un certificado digital?
20. ¿Qué es un Virtual Host?
21. ¿Qué diferencia existe entre VirtualHost basado en IP y basado en
    nombre?
22. ¿Qué función tiene `ServerName`?
23. ¿Qué función tiene `DocumentRoot`?
24. ¿Qué hacen `a2enmod` y `a2dismod`?
25. ¿Qué hacen `a2ensite` y `a2dissite`?
26. ¿Qué utilidad tiene `apachectl -S`?
27. ¿Dónde se encuentran habitualmente los logs de Apache en Ubuntu?
28. ¿Qué herramientas utilizarías para diagnosticar un error HTTP?
29. ¿Qué ventaja aporta SNI?
30. ¿Por qué HTTPS no garantiza que una aplicación web sea segura?

------------------------------------------------------------------------

# ✅ 68. Solucionario de la autoevaluación

### 1. Internet y Web

Internet es la infraestructura mundial de redes interconectadas. La Web
es un servicio distribuido que funciona sobre esa infraestructura.

### 2. HTTP

HTTP permite que un cliente solicite recursos o realice operaciones y
que un servidor responda.

### 3. URI y URL

URI identifica un recurso. URL es un tipo de URI que proporciona
información para localizarlo mediante un mecanismo de acceso.

### 4. Página, sitio y aplicación

Una página es un recurso concreto. Un sitio agrupa recursos
relacionados. Una aplicación web incorpora lógica de aplicación y
normalmente procesamiento dinámico.

### 5. Servidor web

Es un software que acepta peticiones HTTP/HTTPS y devuelve recursos o
respuestas generadas dinámicamente.

### 6. Proxy y reverse proxy

Un proxy directo actúa en nombre del cliente. Un reverse proxy se sitúa
delante de los servidores de backend y recibe las peticiones de los
clientes.

### 7. Petición HTTP

Incluye línea inicial, cabeceras, línea vacía y un cuerpo opcional.

### 8. Respuesta HTTP

Incluye línea de estado, cabeceras, línea vacía y cuerpo opcional.

### 9. Host

Permite indicar el nombre del recurso/servidor solicitado y es
fundamental para el alojamiento virtual basado en nombres.

### 10. GET y POST

GET se utiliza habitualmente para recuperar recursos. POST permite
enviar datos al servidor para que sean procesados. La diferencia no debe
reducirse a «GET seguro y POST inseguro».

### 11. Familias de códigos

``` text
2xx → éxito
3xx → redirección
4xx → problema asociado a la petición/cliente
5xx → problema en el procesamiento del servidor
```

### 12. 401 y 403

401 indica que se requiere una autenticación válida. 403 indica que el
acceso está prohibido aunque la petición pueda estar correctamente
formada.

### 13. Content-Type

Indica el tipo de representación que contiene el mensaje.

### 14. Cookie

Es información que el servidor puede solicitar al cliente que almacene y
que este puede devolver posteriormente para mantener estado o
preferencias.

### 15. Caché

Participan mecanismos como:

``` text
Cache-Control
ETag
Last-Modified
Expires
If-None-Match
If-Modified-Since
```

### 16. Conexión persistente

Permite reutilizar una conexión para varias peticiones/respuestas,
reduciendo el coste de establecer conexiones repetidamente.

### 17. HTTP y HTTPS

HTTPS protege HTTP mediante TLS, proporcionando confidencialidad e
integridad del canal y autenticación del servidor mediante certificados
cuando la validación es correcta.

### 18. TLS

Proporciona un canal criptográficamente protegido y negocia mecanismos
de autenticación, cifrado e integridad.

### 19. Certificado

Asocia una identidad con una clave pública y contiene información
firmada por una autoridad certificadora o por el propio emisor si es
autofirmado.

### 20. Virtual Host

Permite que un mismo servidor atienda diferentes sitios mediante
configuraciones diferenciadas.

### 21. IP frente a nombre

El Virtual Host basado en IP distingue sitios mediante diferentes
direcciones IP. El basado en nombre puede compartir una misma IP y
utilizar el nombre solicitado para seleccionar el sitio.

### 22. ServerName

Define el nombre principal al que responde un Virtual Host.

### 23. DocumentRoot

Define el directorio desde el que Apache sirve los recursos del sitio.

### 24. a2enmod / a2dismod

Activan y desactivan módulos Apache.

### 25. a2ensite / a2dissite

Activan y desactivan sitios o Virtual Hosts.

### 26. apachectl -S

Muestra cómo Apache ha interpretado la configuración de Virtual Hosts.

### 27. Logs

Habitualmente:

``` text
/var/log/apache2/access.log
/var/log/apache2/error.log
```

aunque cada Virtual Host puede definir sus propios logs.

### 28. Diagnóstico

Una combinación razonable:

``` text
dig
ping
nc
ss
curl
openssl s_client
apachectl -S
apache2ctl -M
journalctl
logs
tcpdump
Wireshark
```

### 29. SNI

Permite que el cliente indique el nombre solicitado durante el handshake
TLS, facilitando la selección del Virtual Host y del certificado
correspondiente.

### 30. HTTPS no equivale a aplicación segura

HTTPS protege la comunicación entre extremos, pero no corrige
vulnerabilidades de la aplicación, autenticación, autorización,
sesiones, validación de datos o lógica de negocio.

------------------------------------------------------------------------

# 📝 69. Test de repaso

### 1. ¿Qué protocolo utiliza el navegador para solicitar recursos web?

a)  FTP\
b)  HTTP\
c)  DHCP\
d)  DNS

### 2. El puerto tradicional de HTTP es:

a)  21\
b)  22\
c)  80\
d)  443

### 3. HTTPS utiliza habitualmente:

a)  TCP/21\
b)  TCP/53\
c)  TCP/80\
d)  TCP/443

### 4. ¿Qué método se utiliza habitualmente para recuperar un recurso?

a)  GET\
b)  POST\
c)  DELETE\
d)  PATCH

### 5. ¿Qué código indica normalmente que un recurso no existe?

a)  200\
b)  301\
c)  404\
d)  500

### 6. ¿Qué cabecera identifica el host solicitado en HTTP/1.1?

a)  Content-Type\
b)  Host\
c)  Location\
d)  Server

### 7. ¿Qué directiva Apache define el directorio de los recursos del sitio?

a)  ServerAlias\
b)  Listen\
c)  DocumentRoot\
d)  ErrorDocument

### 8. ¿Qué comando activa un Virtual Host en Ubuntu?

a)  `a2ensite`\
b)  `a2enable`\
c)  `apache-enable-site`\
d)  `site2enable`

### 9. ¿Qué comando permite inspeccionar los Virtual Hosts interpretados por

Apache?

a)  `apachectl -S`\
b)  `apachectl -P`\
c)  `apachectl -VHOST`\
d)  `a2list`

### 10. ¿Qué mecanismo permite seleccionar un certificado según el nombre

solicitado durante TLS?

a)  MIME\
b)  SNI\
c)  FTP\
d)  DHCP

### 11. ¿Qué código indica normalmente una redirección permanente?

a)  200\
b)  301\
c)  401\
d)  503

### 12. ¿Qué cabecera indica el tipo MIME de una respuesta?

a)  Host\
b)  Server\
c)  Content-Type\
d)  Location

### 13. ¿Qué componente permite proteger HTTP mediante TLS?

a)  HTTPS\
b)  FTP\
c)  TFTP\
d)  DHCP

### 14. ¿Qué utilidad es especialmente apropiada para consultar una respuesta

HTTP desde terminal?

a)  `dig`\
b)  `curl`\
c)  `ip`\
d)  `ss`

### 15. ¿Qué diferencia principal existe entre proxy directo y reverse proxy?

a)  El protocolo utilizado.\
b)  La dirección IP utilizada.\
c)  El lado de la comunicación en cuyo nombre actúa el proxy.\
d)  El puerto de HTTP.

------------------------------------------------------------------------

# ✅ 70. Respuestas del test

    Nº  Respuesta
  ---- -----------
     1    **b**
     2    **c**
     3    **d**
     4    **a**
     5    **c**
     6    **b**
     7    **c**
     8    **a**
     9    **a**
    10    **b**
    11    **b**
    12    **c**
    13    **a**
    14    **b**
    15    **c**

------------------------------------------------------------------------

# 🔄 71. Correspondencia con el capítulo original

  -----------------------------------------------------------------------
  Capítulo original                   UT5 actualizada
  ----------------------------------- -----------------------------------
  5.1 Introducción                    Introducción a la Web

  5.2 WWW                             WWW e Internet

  5.3 W3C y estándares Web            Estándares y evolución

  5.4 Componentes y funcionamiento    Arquitectura cliente/servidor

  5.5 URIs y URLs                     Identificación de recursos

  5.6 Páginas, sitios y aplicaciones  Arquitecturas web

  5.7 Servidores web                  Apache + comparación Nginx

  5.8 Clientes web                    Navegadores + curl

  5.9 Proxies web                     Proxy y reverse proxy

  5.10 HTTP                           HTTP/1.x + evolución HTTP/2/3

  5.11 MIME                           Content-Type

  5.12 Seguridad                      Seguridad Web

  5.13 HTTPS                          TLS + certificados

  5.14 Virtual Hosting                IP/nombre/puerto + SNI

  Apache 2.2 Linux                    **Apache 2.4 en Ubuntu 26.04**

  IIS 7.5 Windows                     **Se estudia conceptualmente; no
                                      plataforma principal**

  Zentyal                             Se elimina como plataforma
                                      principal

  Prácticas Apache                    Se mantienen y actualizan

  Prácticas IIS                       Se sustituyen por Apache/Nginx

  Prácticas HTTPS                     Certificados de laboratorio + ACME

  PHP/MySQL                           Se sustituye por aplicación de
                                      laboratorio y reverse proxy

  Monitorización y logs               Se mantiene y amplía

  Alojamiento Internet                Se mantiene como arquitectura
                                      conceptual
  -----------------------------------------------------------------------

El índice original confirma la secuencia 5.1--5.14 y las secciones
posteriores de prácticas, resumen, test y comprobación del aprendizaje.
citeturn4search0

------------------------------------------------------------------------

# 🧱 72. Evolución tecnológica

``` text
                 CAPÍTULO ORIGINAL
                        │
       ┌────────────────┼─────────────────┐
       │                │                 │
   Apache 2.2         IIS 7.5          Zentyal
       │                │                 │
       └────────────────┼─────────────────┘
                        ▼
                 UT5 ACTUALIZADA
                        │
       ┌────────────────┼─────────────────┐
       │                │                 │
 Apache 2.4         Nginx             OpenSSL
 Ubuntu 26.04       reverse proxy     TLS
       │                │                 │
       └────────────────┼─────────────────┘
                        ▼
                🧪 LABORATORIO ASIR
                        │
        ┌───────────────┼────────────────┐
        │               │                │
      WSL2          VirtualBox       Packet Tracer
    cliente        Ubuntu Server      red/simulación
```

La configuración moderna de Apache en Ubuntu se apoya en módulos,
Virtual Hosts y ficheros separados para sitios y configuraciones.
citeturn3search0turn3search1

------------------------------------------------------------------------

# 🏁 73. Resultado esperado

Al finalizar la UT5, el alumno debería poder enfrentarse a:

> **«Tengo un Ubuntu Server con una IP y necesito publicar dos sitios,
> protegerlos con HTTPS, autenticar una zona privada, registrar accesos
> y diagnosticar cualquier fallo.»**

La solución no debe comenzar por:

``` text
sudo apt install apache2
```

sino por:

``` text
REQUISITOS
    ↓
DNS
    ↓
RED
    ↓
PROTOCOLO
    ↓
SERVIDOR
    ↓
VIRTUAL HOSTS
    ↓
PERMISOS
    ↓
HTTPS
    ↓
AUTENTICACIÓN
    ↓
LOGS
    ↓
MONITORIZACIÓN
    ↓
PRUEBAS
    ↓
DIAGNÓSTICO
```

------------------------------------------------------------------------

# 📖 74. Referencias

### Fuente principal

**Garceta --- Servicios de Red e Internet**, capítulo 5: **«Servidores
Web (HTTP)»**.

La estructura original incluye WWW, estándares W3C, componentes y
funcionamiento, URIs/URLs, páginas y aplicaciones web, servidores,
clientes, proxies, HTTP, MIME, seguridad, HTTPS, alojamiento virtual,
prácticas, resumen, test y comprobación del aprendizaje.
citeturn4search0

El programa asociado al libro fija para esta unidad objetivos como
instalar y configurar servidores web, activar módulos, crear sitios
virtuales, configurar autenticación y control de acceso, instalar
certificados, establecer comunicaciones seguras, monitorizar y analizar
registros. citeturn1view0

### Documentación técnica actual

-   Ubuntu Server --- instalación de Apache2. citeturn3search2
-   Ubuntu Server --- configuración de Apache2 y Virtual Hosts.
    citeturn3search1
-   Ubuntu Server --- módulos Apache2 y HTTPS. citeturn3search0
-   Apache HTTP Server --- Virtual Hosts.
    citeturn3search3turn3search9
-   Apache HTTP Server --- SSL/TLS. citeturn3search6
-   Ubuntu Server --- certificados TLS/ACME. citeturn3search4
-   Ubuntu Server --- configuración de Nginx. citeturn3search7

------------------------------------------------------------------------

::: {align="center"}
## 🌐 UT5 · SERVIDORES WEB

``` text
          DNS
           │
           ▼
       TCP / QUIC
           │
           ▼
      HTTP / HTTPS
           │
     ┌─────┴─────┐
     │           │
   Apache      Nginx
     │           │
     └─────┬─────┘
           ▼
      VIRTUAL HOSTS
           │
           ▼
       APLICACIÓN
           │
           ▼
        📜 LOGS
           │
           ▼
       🧠 DIAGNÓSTICO
```

**NO SOLO PUBLICAR UNA WEB.\
ADMINISTRAR EL SERVICIO WEB.**

**FIN DE LA UT5**
:::
