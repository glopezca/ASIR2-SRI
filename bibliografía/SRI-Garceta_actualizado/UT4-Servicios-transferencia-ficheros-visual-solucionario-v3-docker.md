
> 🔬 **VERSIÓN V2 · REVISIÓN TÉCNICA 2026-09-18**
>
> Se ha realizado una segunda pasada sobre los bloques de código y las configuraciones prácticas. Revisado el `chroot_local_user=YES`: la práctica ahora evita una raíz FTP escribible por el usuario y utiliza `/upload` para las subidas.
>
> ⚠️ La validación automática cubre sintaxis y configuraciones aisladas; la validación extremo a extremo > de Cisco Packet Tracer, WSL2 y una VM real de Ubuntu 26.04 Server requiere ejecutar el laboratorio en esos entornos.

::: {align="center"}
# 📂⚡ UT4 · SERVICIOS DE TRANSFERENCIA DE FICHEROS ⚡📂

### 🔄 Mover información entre sistemas · FTP · FTPS · TFTP · SFTP · SCP

``` text
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║     📂 TRANSFERENCIA DE FICHEROS · CLIENTE ↔ SERVIDOR           ║
║                                                                  ║
║       FTP 🔓   FTPS 🔐   TFTP ⚡   SFTP 🛡️   SCP 📦             ║
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
> Comprender cómo funcionan los servicios de transferencia de ficheros,
> diferenciar **FTP, FTPS, TFTP, SFTP y SCP**, analizar sus conexiones y
> mecanismos de autenticación, e instalar y configurar servicios de
> transferencia en un entorno de laboratorio.
>
> El objetivo no es memorizar comandos: es poder responder a una
> pregunta profesional:
>
> **«¿Qué protocolo utilizarías para transferir estos datos y por
> qué?»**

> ⚠️ **Actualización tecnológica**
>
> El manual original fue escrito cuando FTP, navegadores con soporte
> FTP, Windows Server 2008, FileZilla Server y `vsftpd` eran
> herramientas habituales. La arquitectura conceptual se conserva, pero
> las prácticas se trasladan a:
>
> -   🧪 **Cisco Packet Tracer**
> -   🐧 **WSL2 + Ubuntu 26.04**
> -   🖥️ **VirtualBox + Ubuntu 26.04 Server**
>
> Para transferencias seguras se da especial importancia a **SFTP/SCP
> sobre OpenSSH**. Ubuntu recomienda utilizar SFTP para transferencias
> seguras y advierte que FTP transmite credenciales y datos sin cifrar.
> citeturn1search1turn1search0

------------------------------------------------------------------------

# 🧭 Mapa de la unidad

``` text
                         📂 TRANSFERENCIA
                                │
             ┌──────────────────┼──────────────────┐
             │                  │                  │
           FTP                TFTP             SSH/SFTP
             │                  │                  │
       ┌─────┴─────┐            │             ┌────┴────┐
       │           │            │             │         │
    ACTIVO       PASIVO       UDP            SFTP      SCP
       │           │
       └─────┬─────┘
             │
         NAT / FW
             │
       ┌─────┴─────┐
       │           │
      FTPS        FTP
     TLS/SSL     texto claro
       │
       └───────────────┐
                       ▼
                  🛡️ SEGURIDAD
```

------------------------------------------------------------------------

# 🎯 0. Objetivos

Al finalizar esta unidad deberás ser capaz de:

-   Explicar para qué sirve un servicio de transferencia de ficheros.
-   Comprender el modelo cliente/servidor aplicado a FTP.
-   Identificar los componentes de FTP.
-   Diferenciar conexión de control y conexión de datos.
-   Explicar los modos **activo y pasivo**.
-   Comprender el impacto de NAT y los cortafuegos sobre FTP.
-   Diferenciar acceso anónimo y autenticado.
-   Utilizar clientes FTP en línea de comandos.
-   Identificar los principales comandos FTP.
-   Diferenciar transferencia ASCII y binaria.
-   Explicar por qué FTP tradicional no proporciona confidencialidad.
-   Diferenciar FTP, FTPS y SFTP.
-   Explicar qué es FXP.
-   Explicar las características de TFTP.
-   Comprender SFTP y SCP como mecanismos basados en SSH.
-   Instalar y configurar `vsftpd`.
-   Instalar y utilizar OpenSSH para SFTP/SCP.
-   Analizar transferencias con Wireshark.
-   Configurar y probar FTP/TFTP en Packet Tracer.
-   Diagnosticar problemas de conectividad, autenticación, permisos y
    firewall.
-   Documentar una instalación de transferencia de ficheros.

------------------------------------------------------------------------

# 🚀 1. Introducción

Las redes permiten transferir información entre sistemas.

Pero no todos los mecanismos de transferencia tienen los mismos
objetivos:

``` text
Necesidad
   │
   ├── 📂 Transferir ficheros en una LAN
   │
   ├── 🌐 Publicar ficheros para descarga
   │
   ├── 🔐 Transferir información confidencial
   │
   ├── ⚙️ Cargar configuración en dispositivos
   │
   └── 🖥️ Copiar ficheros entre servidores
```

Existen diferentes soluciones.

  Tecnología   Transporte   Cifrado   Uso típico
  ------------ ------------ --------- -------------------------------
  FTP          TCP          ❌        Transferencia clásica
  FTPS         TCP + TLS    ✅        FTP protegido mediante TLS
  TFTP         UDP          ❌        Configuraciones/firmware
  SFTP         SSH/TCP      ✅        Transferencia segura
  SCP          SSH/TCP      ✅        Copias rápidas entre sistemas

> 🧠 **Idea clave**
>
> **SFTP no es «FTP con una S».**
>
> SFTP es un protocolo de transferencia que funciona sobre SSH. FTPS es
> FTP protegido mediante TLS. Son tecnologías diferentes. Ubuntu
> documenta explícitamente esta diferencia. citeturn1search1

------------------------------------------------------------------------

# 🧩 2. Modelo cliente/servidor

En el modelo clásico:

``` text
             CLIENTE
                │
                │ solicitud
                ▼
          ┌───────────┐
          │  SERVIDOR │
          └───────────┘
                │
                │ respuesta
                ▼
             CLIENTE
```

### Cliente

Inicia las conexiones y solicita operaciones.

Ejemplos:

``` text
ftp
sftp
scp
FileZilla
WinSCP
```

### Servidor

Acepta conexiones, autentica usuarios y aplica permisos.

Ejemplos:

``` text
vsftpd
OpenSSH / sshd
```

------------------------------------------------------------------------

# 📡 3. FTP

**FTP --- File Transfer Protocol** es un protocolo de aplicación
diseñado para transferir ficheros entre sistemas conectados mediante
TCP/IP.

El capítulo original lo presenta como un servicio cliente/servidor con
operaciones de listado, descarga, subida y administración de ficheros.

``` text
CLIENTE FTP                         SERVIDOR FTP
     │                                    │
     │──── conexión de control ──────────►│
     │                                    │
     │──── comandos ─────────────────────►│
     │                                    │
     │◄─── respuestas ────────────────────│
     │                                    │
     │──── conexión de datos ─────────────►│
     │◄─── datos/ficheros ────────────────│
```

------------------------------------------------------------------------

# 🔌 4. Puertos y conexiones FTP

FTP utiliza una arquitectura peculiar porque emplea:

-   una **conexión de control**;
-   una o varias **conexiones de datos**.

Tradicionalmente:

``` text
TCP/21 → conexión de control
TCP/20 → puerto tradicional asociado a datos en modo activo
```

⚠️ En FTP pasivo, las conexiones de datos utilizan puertos negociados
por el servidor y no necesariamente TCP/20.

------------------------------------------------------------------------

# 🧠 5. Conexión de control

La conexión de control permanece activa durante la sesión FTP.

Por ella viajan comandos como:

``` text
USER
PASS
PWD
CWD
LIST
RETR
STOR
QUIT
```

Ejemplo conceptual:

``` text
CLIENTE                           SERVIDOR

USER alumno ─────────────────────►
              ◄────────────────── 331 Password required

PASS ******** ───────────────────►
              ◄────────────────── 230 Login successful

PWD ─────────────────────────────►
              ◄────────────────── 257 "/home/alumno"
```

> ⚠️ Con FTP tradicional, usuario y contraseña pueden viajar sin cifrar.

------------------------------------------------------------------------

# 📦 6. Conexión de datos

La conexión de datos transporta:

-   ficheros,
-   listados de directorios,
-   información transferida.

Ejemplo:

``` text
             CONTROL
CLIENTE ───────────────────────► SERVIDOR
       TCP/21

             DATOS
CLIENTE ◄──────────────────────► SERVIDOR
       conexión negociada
```

Esta separación entre control y datos es una de las características que
hacen que FTP sea más complejo de atravesar mediante NAT y firewalls.

------------------------------------------------------------------------

# 👤 7. Tipos de acceso

El manual distingue dos grandes modelos.

## 7.1. Acceso anónimo

El usuario utiliza normalmente:

``` text
anonymous
```

o:

``` text
ftp
```

Es apropiado para servidores de distribución pública.

``` text
anonymous
    │
    ▼
┌───────────────┐
│ FTP PUBLIC    │
│ 📥 descarga   │
└───────────────┘
```

### Principio de seguridad

El acceso anónimo debe tener **privilegios mínimos**.

------------------------------------------------------------------------

## 7.2. Acceso autenticado

El cliente utiliza una cuenta reconocida por el servidor.

Puede tratarse de:

-   usuarios locales;
-   usuarios virtuales;
-   mecanismos externos de autenticación, según el servidor.

Los permisos deben limitar:

``` text
📥 descarga
📤 subida
🗑️ borrado
✏️ modificación
📁 creación de directorios
```

------------------------------------------------------------------------

# 🧱 8. Chroot / aislamiento

Un servidor FTP puede restringir el espacio de ficheros visible para un
usuario.

Conceptualmente:

``` text
Sistema completo
│
├── /etc
├── /var
├── /home
│
└── /srv/ftp
      │
      ├── fichero1
      └── directorio/
```

Para un usuario confinado:

``` text
            🚪
            │
        /srv/ftp
            │
       ┌────┴────┐
       │ usuario │
       └─────────┘
```

El usuario no debería poder escapar de su árbol autorizado.

En `vsftpd`, el aislamiento de usuarios locales puede configurarse
mediante directivas como `chroot_local_user`. La configuración se
realiza en `/etc/vsftpd.conf`. citeturn0search1

------------------------------------------------------------------------

# 🖥️ 9. Clientes FTP

Podemos clasificar los clientes en:

### 💻 Línea de comandos

``` bash
ftp servidor
```

### 🖱️ Gráficos

Ejemplos históricos y actuales:

``` text
FileZilla
WinSCP
gFTP
```

### 🌐 Navegadores

El manual original utilizaba navegadores como clientes FTP.

> ⚠️ **Actualización importante**
>
> Los navegadores web modernos han eliminado el soporte FTP integrado.
> Por tanto, **no debe plantearse actualmente una práctica basada en
> `ftp://...` desde Chrome, Firefox o Edge**.
>
> Para una práctica moderna se utilizará un cliente FTP específico.

------------------------------------------------------------------------

# 🧰 10. Cliente FTP en línea de comandos

Conectar:

``` bash
ftp 192.168.10.10
```

Una vez conectado:

``` text
ftp>
```

Ayuda:

``` text
help
```

o:

``` text
?
```

------------------------------------------------------------------------

# 📋 11. Comandos FTP esenciales

  Comando     Función
  ----------- ---------------------------
  `open`      Abrir conexión
  `user`      Autenticarse
  `pwd`       Directorio remoto actual
  `lpwd`      Directorio local
  `cd`        Cambiar directorio remoto
  `lcd`       Cambiar directorio local
  `ls`        Listar remoto
  `dir`       Listado detallado
  `get`       Descargar
  `put`       Subir
  `mget`      Descargar varios
  `mput`      Subir varios
  `mkdir`     Crear directorio remoto
  `delete`    Borrar fichero remoto
  `binary`    Modo binario
  `ascii`     Modo ASCII
  `passive`   Activar/desactivar pasivo
  `bye`       Cerrar sesión

------------------------------------------------------------------------

# 📥 12. Descargar un fichero

``` text
ftp> get informe.pdf
```

Conceptualmente:

``` text
SERVIDOR
   │
   │ informe.pdf
   ▼
CLIENTE
```

------------------------------------------------------------------------

# 📤 13. Subir un fichero

``` text
ftp> put informe.pdf
```

``` text
CLIENTE
   │
   │ informe.pdf
   ▼
SERVIDOR
```

⚠️ Que el usuario esté autenticado **no significa que tenga permiso de
escritura**.

Los permisos del sistema de ficheros y la configuración del servidor
deben permitir la operación.

------------------------------------------------------------------------

# 🔢 14. FTP y códigos de respuesta

El servidor responde mediante códigos numéricos.

Ejemplos habituales:

``` text
220 → servicio preparado
331 → usuario correcto, solicita contraseña
230 → autenticación correcta
150 → apertura de conexión de datos
226 → transferencia completada
425 → no se puede abrir conexión de datos
530 → no autenticado
550 → acción no realizada / fichero no disponible
```

Ejemplo:

``` text
CLIENTE                     SERVIDOR

USER alumno ───────────────►
          ◄──────────────── 331

PASS ******** ─────────────►
          ◄──────────────── 230

RETR fichero.txt ──────────►
          ◄──────────────── 150

          ◄──────────────── 226
```

------------------------------------------------------------------------

# 🧪 15. PRÁCTICA 4.1 --- Explorar FTP desde WSL2

## Objetivo

Familiarizarse con el cliente FTP y observar sus comandos.

Instala el cliente si es necesario:

``` bash
sudo apt update
sudo apt install ftp
```

Conecta al servidor de laboratorio:

``` bash
ftp 192.168.10.10
```

Prueba:

``` text
help
pwd
ls
lcd /tmp
get fichero.txt
bye
```

### Entrega

Una tabla:

  Comando   Dirección            Resultado
  --------- -------------------- -----------
  `pwd`     servidor             
  `ls`      servidor             
  `lcd`     cliente              
  `get`     servidor → cliente   
  `put`     cliente → servidor   

------------------------------------------------------------------------

# 🔄 16. Modo activo

En modo activo:

``` text
                 CONTROL
CLIENTE:puerto alto ─────────► SERVIDOR:21

                 DATOS
CLIENTE:puerto alto ◄───────── SERVIDOR:20
```

La particularidad es que **el servidor inicia la conexión de datos hacia
el cliente**.

Esto puede causar problemas cuando el cliente está detrás de:

-   NAT;
-   firewall;
-   router con filtrado.

------------------------------------------------------------------------

# 🔁 17. Modo pasivo

En modo pasivo:

``` text
                 CONTROL
CLIENTE ──────────────────────► SERVIDOR:21

                 DATOS
CLIENTE ──────────────────────► SERVIDOR:puerto_alto
```

El cliente solicita:

``` text
PASV
```

o mecanismos equivalentes de FTP extendido.

El servidor comunica un puerto de datos y el cliente inicia la conexión.

``` text
CLIENTE
   │
   │ PASV
   ▼
SERVIDOR
   │
   │ puerto 40000
   ▼
CLIENTE ─────────► SERVIDOR:40000
```

------------------------------------------------------------------------

# 🧱 18. FTP + NAT + firewall

Este es uno de los conceptos más importantes de la unidad.

``` text
CLIENTE
192.168.1.50
    │
    │
    ▼
┌──────────────┐
│ NAT/FIREWALL │
└──────────────┘
    │
    ▼
INTERNET
    │
    ▼
SERVIDOR FTP
```

### Modo activo

El servidor intenta iniciar una conexión hacia el cliente.

``` text
SERVIDOR ───────► NAT ───────► CLIENTE
```

El firewall puede bloquearla.

### Modo pasivo

``` text
CLIENTE ───────► NAT ───────► SERVIDOR
```

El patrón suele ser más sencillo para el cliente, pero el servidor debe
publicar y permitir un rango de puertos pasivos.

------------------------------------------------------------------------

# 🧠 19. FTP ALG

Algunos dispositivos de red implementan **FTP ALG --- Application Layer
Gateway**.

El dispositivo inspecciona la comunicación FTP y puede modificar
información relativa a las conexiones de datos para hacer compatible FTP
con NAT.

``` text
FTP
 │
 ▼
ALG
 │
 ├── interpreta comandos
 ├── detecta puertos
 └── adapta conexiones
```

> ⚠️ No conviene depender de FTP ALG como solución universal.
>
> Para laboratorios es muy útil estudiar su funcionamiento; para nuevos
> servicios, SFTP suele evitar esta complejidad porque utiliza una única
> conexión SSH para la transferencia.

------------------------------------------------------------------------

# 📦 20. Transferencia ASCII y binaria

FTP tradicional contempla diferentes tipos de transferencia.

## ASCII

Pensado para datos textuales.

Ejemplos:

``` text
.txt
.csv
```

## Binario

Para datos que deben conservar exactamente sus bytes.

Ejemplos:

``` text
.png
.jpg
.iso
.zip
.exe
.pdf
.mp4
```

En la práctica moderna es habitual utilizar modo binario cuando se
quiere evitar conversiones de contenido.

``` text
ftp> binary
```

------------------------------------------------------------------------

# 🛡️ 21. Seguridad de FTP

FTP tradicional **no proporciona confidencialidad**.

``` text
USER alumno
     ↓
     texto claro
     ↓
PASS ********
     ↓
     texto claro
```

También los datos pueden viajar sin cifrar.

Por tanto:

``` text
FTP tradicional
      │
      ├── ❌ confidencialidad
      ├── ❌ protección de credenciales
      └── ❌ protección del contenido
```

Ubuntu advierte expresamente que FTP es inseguro para transferencias que
requieran protección de credenciales o datos. citeturn1search1

------------------------------------------------------------------------

# 🔐 22. FTPS

**FTPS** es FTP protegido mediante TLS.

``` text
FTP
 │
 └── TLS
      │
      ▼
   FTPS 🔐
```

El objetivo es proporcionar:

-   confidencialidad;
-   integridad;
-   autenticación mediante certificados, según configuración.

No debe confundirse con SFTP.

------------------------------------------------------------------------

# 🔓 23. FTPS explícito

En FTPS explícito el cliente establece inicialmente una conexión FTP y
solicita explícitamente protección TLS.

Conceptualmente:

``` text
CLIENTE
   │
   │ conexión FTP
   ▼
SERVIDOR:21
   │
   │ START TLS / AUTH TLS
   ▼
   🔐 TLS
```

Una ventaja es que permite una negociación explícita de la protección.

------------------------------------------------------------------------

# 🔒 24. FTPS implícito

En el modelo implícito, TLS se establece desde el comienzo de la
conexión.

``` text
CLIENTE
   │
   │ TLS desde el inicio
   ▼
SERVIDOR FTPS
```

La distinción es importante porque afecta a:

-   puertos;
-   negociación;
-   configuración;
-   compatibilidad del cliente.

------------------------------------------------------------------------

# ⚠️ 25. FTPS ≠ SFTP

  Característica                       FTP      FTPS               SFTP
  ------------------------------------ -------- ------------------ -------------
  Base                                 FTP      FTP                SSH
  Cifrado                              ❌       TLS                SSH
  Control/datos separados              Sí       Sí                 No como FTP
  Puerto habitual                      21/TCP   21/TCP explícito   22/TCP
  Requiere SSH                         ❌       ❌                 ✅
  Certificados TLS                     ❌       Sí                 ❌
  Adecuado para transferencia segura   ❌       ✅                 ✅

> 🧠 **Pregunta clásica de examen**
>
> **SFTP no significa Secure FTP.**
>
> SFTP significa **SSH File Transfer Protocol** y forma parte del
> ecosistema SSH.

Ubuntu documenta SFTP como transferencia de ficheros sobre un transporte
SSH cifrado. citeturn1search3

------------------------------------------------------------------------

# ⚡ 26. FXP

El capítulo original incluye **FXP --- File eXchange Protocol**.

La idea es:

``` text
             CLIENTE
                │
       ┌────────┴────────┐
       │                 │
       ▼                 ▼
   SERVIDOR A ═══════► SERVIDOR B
          transferencia
             directa
```

El cliente coordina la operación, pero los datos pueden circular
directamente entre servidores FTP.

### Problema

FXP aumenta la complejidad y puede generar riesgos de seguridad.

Por ello debe permitirse únicamente cuando existe una necesidad clara y
se controla adecuadamente.

------------------------------------------------------------------------

# ⚡ 27. TFTP

**TFTP --- Trivial File Transfer Protocol** es un protocolo mucho más
sencillo.

Utiliza:

``` text
UDP/69
```

Características:

-   muy sencillo;
-   bajo consumo;
-   sin autenticación FTP convencional;
-   sin cifrado;
-   orientado a operaciones simples.

``` text
CLIENTE
   │
   │ UDP
   ▼
TFTP SERVER
```

------------------------------------------------------------------------

# 🖧 28. ¿Para qué se utiliza TFTP?

Un caso clásico es la infraestructura de red:

``` text
             ROUTER
                │
                │ TFTP
                ▼
          ┌───────────┐
          │ TFTP SRV  │
          └───────────┘
                │
          config / image
```

Puede utilizarse en determinados escenarios para:

-   copias de configuración;
-   imágenes;
-   arranque de determinados dispositivos.

> ⚠️ **TFTP no debe utilizarse para transferir información sensible.**
>
> No proporciona autenticación fuerte ni cifrado.

------------------------------------------------------------------------

# 🧪 29. PRÁCTICA 4.2 --- TFTP en Cisco Packet Tracer

## Topología

``` text
PC ───── SWITCH ───── ROUTER
                         │
                         │
                    TFTP SERVER
```

Configura un servidor TFTP en Packet Tracer.

Desde un dispositivo Cisco:

``` text
Router# copy running-config tftp:
```

Indica:

``` text
Address or name of remote host []? 192.168.10.20
Destination filename [router-confg]?
```

Después comprueba que el fichero aparece en el servidor.

### Reto

Realiza el proceso inverso:

``` text
TFTP SERVER
     │
     ▼
startup-config
```

y documenta qué comando utilizaste.

------------------------------------------------------------------------

# 🧪 30. PRÁCTICA 4.3 --- FTP en Cisco Packet Tracer

Packet Tracer permite simular un servidor FTP.

## Topología

``` text
PC1 ───── SWITCH ───── SERVER-PT
                           │
                          FTP
```

En el servidor:

1.  Asigna una IP.
2.  Activa el servicio FTP.
3.  Crea un usuario.
4.  Define una contraseña.
5.  Prepara un fichero de prueba.

Desde el PC:

``` text
PC > Command Prompt

ftp 192.168.10.20
```

Prueba:

``` text
dir
get fichero.txt
put prueba.txt
```

### Analiza

-   autenticación;
-   conexión;
-   permisos;
-   transferencia;
-   comportamiento del servicio.

------------------------------------------------------------------------

# 🧪 31. PRÁCTICA 4.4 --- Capturar FTP con Wireshark

Utiliza un servidor FTP de laboratorio.

Captura:

``` text
ftp
```

o:

``` text
tcp.port == 21
```

Observa:

``` text
USER
PASS
PWD
LIST
RETR
QUIT
```

### Pregunta clave

Si puedes leer:

``` text
USER alumno
PASS secreto
```

directamente en una captura...

``` text
        🚨 ¿QUÉ CONCLUSIÓN OBTIENES?
```

Debes relacionarlo con la ausencia de cifrado de FTP.

------------------------------------------------------------------------

# 🖥️ 32. Servidor FTP con Ubuntu 26.04 Server

Para el laboratorio utilizaremos:

``` text
VirtualBox
   │
   └── Ubuntu 26.04 Server
             │
             └── vsftpd
```

Ubuntu proporciona `vsftpd` como servidor FTP. La documentación oficial
indica su instalación mediante:

``` bash
sudo apt install vsftpd
```

y utiliza `/etc/vsftpd.conf` como fichero principal de configuración.
citeturn1search1turn0search0

------------------------------------------------------------------------

# 🧪 33. PRÁCTICA 4.5 --- Instalar vsftpd

Actualiza:

``` bash
sudo apt update
```

Instala:

``` bash
sudo apt install vsftpd
```

Comprueba:

``` bash
systemctl status vsftpd
```

Comprueba el puerto:

``` bash
sudo ss -ltnp | grep ':21'
```

Comprueba la versión:

``` bash
vsftpd -v
```

------------------------------------------------------------------------

# 🗂️ 34. Configuración inicial

Haz una copia de seguridad:

``` bash
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
```

Edita:

``` bash
sudo nano /etc/vsftpd.conf
```

Configuración de laboratorio:

``` ini
listen=YES
listen_ipv6=NO

anonymous_enable=NO
local_enable=YES

write_enable=YES

local_umask=022

dirmessage_enable=YES
use_localtime=YES

xferlog_enable=YES

connect_from_port_20=YES
```

> ⚠️ No copies ciegamente configuraciones antiguas del libro.
>
> Las directivas disponibles y sus valores predeterminados dependen de
> la versión de `vsftpd`. Consulta siempre:
>
> ``` bash
> man vsftpd.conf
> ```
>
> La documentación de Ubuntu mantiene la referencia de configuración de
> `vsftpd`. citeturn0search1

------------------------------------------------------------------------

# 🔍 35. Validar y reiniciar

Antes de probar:

``` bash
sudo systemctl restart vsftpd
```

Comprobar:

``` bash
systemctl status vsftpd
```

Logs:

``` bash
sudo journalctl -u vsftpd
```

Y:

``` bash
sudo ss -ltnp | grep ':21'
```

------------------------------------------------------------------------

# 👤 36. Crear un usuario de laboratorio

``` bash
sudo adduser alumnoftp
```

Crear fichero:

``` bash
sudo -u alumnoftp bash -c 'echo "Prueba FTP" > ~/prueba.txt'
```

Desde otro equipo:

``` bash
ftp 192.168.10.10
```

Autenticación:

``` text
Name: alumnoftp
Password: ********
```

Después:

``` text
pwd
ls
get prueba.txt
```

------------------------------------------------------------------------

# 📤 37. Habilitar subida

La directiva:

``` ini
write_enable=YES
```

permite comandos que modifican el sistema de ficheros, siempre que los
permisos restantes lo permitan.

La documentación de `vsftpd` identifica, entre otros, `STOR`, `DELE`,
`RNFR`, `RNTO`, `MKD` y `RMD` como operaciones afectadas por
`write_enable`. citeturn0search1

Prueba:

``` text
put prueba-subida.txt
```

Comprueba en el servidor:

``` bash
ls -l /home/alumnoftp/upload
```

------------------------------------------------------------------------

# 🔐 38. Restringir usuarios al directorio de inicio

Para un laboratorio de usuarios locales puede estudiarse:

``` ini
chroot_local_user=YES
```

Para evitar el problema de seguridad que aparece cuando la raíz del `chroot`
escribible por el propio usuario, mantenemos el directorio raíz del usuario
como propiedad de `root` y dejamos un subdirectorio específico para escritura:

``` bash
sudo chown root:root /home/alumnoftp
sudo chmod 755 /home/alumnoftp
sudo mkdir -p /home/alumnoftp/upload
sudo chown alumnoftp:alumnoftp /home/alumnoftp/upload
```

Así, el usuario queda confinado a su árbol FTP y puede escribir únicamente en
`/upload`.

Después de modificar:

``` bash
sudo systemctl restart vsftpd
```

Prueba:

``` text
pwd
cd /
ls
cd upload
put prueba-subida.txt
```

y observa el árbol que el servidor presenta al usuario.

------------------------------------------------------------------------

# 👤 39. Acceso anónimo controlado

Si se necesita una zona pública:

``` ini
anonymous_enable=YES
```

El directorio predeterminado de `ftp` en Ubuntu es:

``` text
/srv/ftp
```

Ubuntu documenta este directorio como raíz FTP predeterminada para el
usuario anónimo. citeturn1search1

Crea:

``` bash
sudo mkdir -p /srv/ftp/public
sudo chmod 755 /srv/ftp/public
```

Coloca un fichero:

``` bash
echo "Fichero público" | sudo tee /srv/ftp/public/README.txt
```

### Reto

Configura acceso anónimo **solo de lectura**.

------------------------------------------------------------------------

# 🛡️ 40. Seguridad del acceso anónimo

Nunca debe asumirse:

``` text
anonymous = peligroso siempre
```

ni:

``` text
anonymous = seguro
```

La seguridad depende de:

-   permisos;
-   directorio raíz;
-   posibilidad de escritura;
-   aislamiento;
-   firewall;
-   exposición del servicio;
-   finalidad del servidor.

Para un laboratorio:

``` text
ANÓNIMO
  │
  ├── 📥 descargar
  │
  └── ❌ subir
```

es un escenario sencillo y controlable.

------------------------------------------------------------------------

# 🌐 41. Modo pasivo en vsftpd

Para limitar el rango de puertos:

``` ini
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40100
```

En la documentación de `vsftpd`, `pasv_min_port` y `pasv_max_port`
permiten restringir el rango utilizado para conexiones PASV, lo que
facilita el diseño del firewall. citeturn0search1

Comprueba:

``` bash
sudo ss -lntp
```

y captura la negociación con Wireshark.

------------------------------------------------------------------------

# 🔥 42. Firewall y FTP pasivo

Si utilizas:

``` text
TCP/21
TCP/40000-40100
```

el firewall debe permitir el tráfico necesario.

Conceptualmente:

``` text
Internet/LAN
     │
     ├── TCP/21 ───────────► FTP
     │
     └── TCP/40000-40100 ──► datos PASV
```

> 🧠 **No abras un rango enorme sin motivo.**
>
> Limitar el rango de puertos simplifica la política de firewall y hace
> más predecible el diagnóstico.

------------------------------------------------------------------------

# 🧪 43. PRÁCTICA 4.6 --- FTP + firewall

Configura:

``` text
TCP/21
TCP/40000-40100
```

Bloquea temporalmente:

``` text
TCP/40000-40100
```

Prueba:

``` text
login → funciona
LIST   → falla
GET    → falla
```

Después vuelve a permitir el rango.

### Objetivo

Demostrar experimentalmente que:

``` text
CONTROL ≠ DATOS
```

------------------------------------------------------------------------

# 📜 44. Logs de vsftpd

Los logs permiten comprobar:

-   conexiones;
-   autenticaciones;
-   transferencias;
-   errores.

Consulta:

``` bash
sudo journalctl -u vsftpd
```

Si está habilitado el registro de transferencias:

``` bash
sudo tail -f /var/log/vsftpd.log
```

La documentación de `vsftpd` contempla `xferlog_enable` y el registro de
transferencias en `/var/log/vsftpd.log`. citeturn0search1

------------------------------------------------------------------------

# 🧪 45. PRÁCTICA 4.7 --- Diagnóstico de FTP

Introduce deliberadamente estos errores:

### Error A

``` text
TCP/21 bloqueado
```

### Error B

``` text
rango PASV bloqueado
```

### Error C

``` text
usuario sin permisos
```

### Error D

``` text
write_enable=NO
```

### Error E

``` text
directorio incorrecto
```

Para cada caso:

``` text
Síntoma
   ↓
Hipótesis
   ↓
Comando de diagnóstico
   ↓
Corrección
   ↓
Prueba
```

------------------------------------------------------------------------

# 🔐 46. OpenSSH: la alternativa segura

Para nuevas prácticas de transferencia segura utilizaremos **OpenSSH**.

Ubuntu documenta OpenSSH como la implementación habitual de SSH en
Ubuntu y proporciona herramientas para control remoto y transferencia
segura de datos. citeturn1search0

Instalación:

``` bash
sudo apt update
sudo apt install openssh-server
```

Comprobar:

``` bash
systemctl status ssh
```

Puerto:

``` bash
sudo ss -ltnp | grep ':22'
```

------------------------------------------------------------------------

# 📂 47. SFTP

**SFTP --- SSH File Transfer Protocol** permite transferir ficheros
mediante un canal SSH cifrado.

``` text
CLIENTE
   │
   │ TCP/22
   ▼
┌─────────────┐
│ SSH SERVER  │
│     │       │
│    SFTP     │
└─────────────┘
```

A diferencia de FTP:

``` text
FTP
 ├── control
 └── datos

SFTP
 └── canal SSH
       └── operaciones de fichero
```

OpenSSH proporciona el subsistema `sftp-server`. citeturn0search3

------------------------------------------------------------------------

# 🧰 48. Cliente SFTP

Conectar:

``` bash
sftp alumno@192.168.10.10
```

Comandos habituales:

``` text
pwd
lpwd
ls
lls
cd
lcd
get
put
mkdir
rm
rename
bye
```

Ejemplo:

``` text
sftp> get documento.pdf
sftp> put informe.txt
sftp> ls
sftp> bye
```

El cliente `sftp` realiza las operaciones sobre un transporte SSH
cifrado. citeturn1search3

------------------------------------------------------------------------

# 📦 49. SCP

`scp` permite copiar ficheros entre sistemas.

Ejemplo:

``` bash
scp informe.pdf alumno@192.168.10.10:/home/alumno/
```

Descargar:

``` bash
scp alumno@192.168.10.10:/home/alumno/informe.pdf .
```

Copiar un directorio:

``` bash
scp -r proyecto/ alumno@192.168.10.10:/home/alumno/
```

La implementación moderna de OpenSSH utiliza SFTP como protocolo de
transferencia para `scp`, manteniendo la autenticación y seguridad de
SSH. citeturn0search7

> ⚠️ Esto es importante para explicar la evolución de `scp`: no conviene
> enseñar únicamente la idea histórica de «protocolo SCP independiente»
> sin mencionar el comportamiento moderno de OpenSSH.

------------------------------------------------------------------------

# 🔑 50. Autenticación mediante clave SSH

Generar una clave:

``` bash
ssh-keygen -t ed25519
```

Copiarla:

``` bash
ssh-copy-id alumno@192.168.10.10
```

Probar:

``` bash
ssh alumno@192.168.10.10
```

Después:

``` bash
sftp alumno@192.168.10.10
```

Ubuntu recomienda Ed25519 como algoritmo de generación de claves SSH en
su documentación actual. citeturn1search0

------------------------------------------------------------------------

# 🧪 51. PRÁCTICA 4.8 --- SFTP frente a FTP

Realiza la misma operación mediante:

``` text
FTP
SFTP
```

Transfiere:

``` text
informe.txt
imagen.png
archivo.zip
```

Captura ambos tráficos con Wireshark.

### FTP

Filtro:

``` text
tcp.port == 21
```

### SSH/SFTP

Filtro:

``` text
tcp.port == 22
```

Compara:

  Aspecto                 FTP   SFTP
  ----------------------- ----- ------
  Puerto                        
  Credenciales visibles         
  Contenido visible             
  Conexiones de datos           
  Cifrado                       
  Complejidad con NAT           

------------------------------------------------------------------------

# 🧪 52. PRÁCTICA 4.9 --- SFTP restringido

Configura un usuario destinado exclusivamente a transferencia.

Investiga cómo restringirlo para que:

``` text
❌ no tenga shell interactiva
✅ pueda utilizar SFTP
❌ no pueda acceder al resto del sistema
```

Utiliza:

``` text
Match User
```

y el subsistema SFTP de OpenSSH.

Consulta:

``` bash
man sshd_config
```

y la documentación oficial de OpenSSH antes de aplicar la configuración.

> ⚠️ Haz esta práctica sobre una VM de laboratorio.
>
> Un error en `sshd_config` puede impedir el acceso remoto al servidor.
> Ubuntu recomienda comprobar la configuración antes de reiniciar:
>
> ``` bash
> sudo sshd -t
> ```
>
> citeturn1search0

------------------------------------------------------------------------

# 🧪 53. PRÁCTICA 4.10 --- SFTP desde WSL2

Desde WSL2:

``` bash
sftp alumno@192.168.10.10
```

Realiza:

``` text
put fichero1.txt
get fichero2.txt
mkdir pruebas
cd pruebas
put fichero3.txt
```

Comprueba en Ubuntu Server:

``` bash
find /home/alumno -maxdepth 2 -type f
```

------------------------------------------------------------------------

# 🧪 54. PRÁCTICA 4.11 --- SCP automatizado

Crea:

``` bash
echo "Backup $(date)" > backup.txt
```

Transfiere:

``` bash
scp backup.txt alumno@192.168.10.10:/home/alumno/
```

Después crea un pequeño script:

``` bash
#!/bin/bash

FECHA=$(date +%Y%m%d-%H%M%S)
scp /tmp/backup.tar.gz alumno@192.168.10.10:/srv/backups/backup-$FECHA.tar.gz
```

### Reto

Configura autenticación mediante clave y elimina la necesidad de
introducir la contraseña manualmente.

------------------------------------------------------------------------

# 🧪 55. PRÁCTICA 4.12 --- Cliente gráfico

Instala FileZilla en el sistema cliente:

``` bash
sudo apt install filezilla
```

Configura dos conexiones:

``` text
FTP
SFTP
```

Compara:

``` text
FTP  → puerto 21
SFTP → puerto 22
```

Observa:

-   autenticación;
-   directorios;
-   transferencia;
-   logs del cliente;
-   errores;
-   protocolo negociado.

> 💡 La herramienta gráfica debe utilizarse como complemento. El alumno
> debe ser capaz de realizar las mismas operaciones desde terminal.

------------------------------------------------------------------------

# 🧪 56. PRÁCTICA 4.13 --- FTP frente a SFTP con Wireshark

Construye:

``` text
                 ┌──────────────┐
                 │ Ubuntu Server│
                 │              │
                 │ FTP  :21     │
                 │ SSH  :22     │
                 └──────┬───────┘
                        │
                        │
                 ┌──────┴───────┐
                 │    WSL2      │
                 └──────────────┘
```

Realiza:

``` text
1️⃣ login FTP
2️⃣ transferir fichero
3️⃣ login SFTP
4️⃣ transferir el mismo fichero
5️⃣ capturar ambos
```

### Pregunta

¿Qué información puede observar un atacante pasivo en cada caso?

------------------------------------------------------------------------

# 🌐 57. FTP detrás de NAT

Construye en VirtualBox:

``` text
                  NAT
                   │
                   ▼
             ┌───────────┐
             │  ROUTER   │
             │ Ubuntu    │
             └─────┬─────┘
                   │
             SRI-LAN-SERV
                   │
                   ▼
             ┌───────────┐
             │ FTP SERVER│
             └───────────┘
```

Configura:

``` text
TCP/21
TCP/40000-40100
```

Comprueba:

``` text
FTP activo  → comportamiento
FTP pasivo  → comportamiento
SFTP        → comportamiento
```

### Objetivo

Relacionar:

``` text
FTP
 +
NAT
 +
Firewall
 +
puertos
 +
modo activo/pasivo
```

------------------------------------------------------------------------

# 🧪 58. PRÁCTICA 4.14 --- Servidor FTP publicado mediante NAT

Configura un router Linux de laboratorio.

Publica:

``` text
WAN:21
   ↓
SERVER:21
```

y:

``` text
WAN:40000-40100
   ↓
SERVER:40000-40100
```

Configura `pasv_address` con la dirección que deba anunciar el servidor
en el escenario de laboratorio.

Después prueba desde una red externa.

### Evidencias

-   tabla NAT;
-   configuración de `vsftpd`;
-   firewall;
-   captura FTP;
-   captura de errores;
-   prueba correcta.

------------------------------------------------------------------------

# 🧪 59. PRÁCTICA 4.15 --- Servidor SFTP

Instala:

``` bash
sudo apt install openssh-server
```

Comprueba:

``` bash
systemctl status ssh
```

Desde WSL2:

``` bash
sftp alumno@192.168.10.10
```

Desde otro Ubuntu:

``` bash
scp fichero.txt alumno@192.168.10.10:/home/alumno/
```

Desde un cliente gráfico:

``` text
Protocolo: SFTP
Host: 192.168.10.10
Puerto: 22
```

### Objetivo

Conseguir una transferencia segura sin abrir ningún puerto adicional
para datos.

------------------------------------------------------------------------

# 🔍 60. Diagnóstico sistemático

Cuando una transferencia falla:

``` text
                  ❌ NO TRANSFIERE
                         │
                         ▼
                 ¿Hay conectividad IP?
                    /            \
                  NO              SÍ
                  │                │
               routing             ▼
                            ¿Puerto abierto?
                              /         \
                            NO           SÍ
                            │             │
                         firewall         ▼
                                  ¿Servicio activo?
                                    /        \
                                  NO          SÍ
                                  │            │
                              systemd          ▼
                                       ¿Autenticación?
                                          /      \
                                        NO        SÍ
                                        │          │
                                      cred.        ▼
                                               ¿Permisos?
                                                /     \
                                              NO       SÍ
                                              │         │
                                           FS/ACL       ▼
                                                   ¿Datos?
                                                     │
                                               PASV/NAT
```

------------------------------------------------------------------------

# 🧰 61. Herramientas de diagnóstico

### Conectividad

``` bash
ping 192.168.10.10
```

### Puertos

``` bash
nc -vz 192.168.10.10 21
nc -vz 192.168.10.10 22
```

### Socket

``` bash
ss -ltnp
```

### Servicios

``` bash
systemctl status vsftpd
systemctl status ssh
```

### Logs

``` bash
journalctl -u vsftpd
journalctl -u ssh
```

### Captura

``` bash
sudo tcpdump -ni any port 21
```

o:

``` bash
sudo tcpdump -ni any port 22
```

------------------------------------------------------------------------

# 🛡️ 62. Comparativa tecnológica

  ------------------------------------------------------------------------------
  Característica   FTP         FTPS        TFTP          SFTP        SCP
  ---------------- ----------- ----------- ------------- ----------- -----------
  Transporte       TCP         TCP         UDP           SSH/TCP     SSH/TCP

  Puerto habitual  21          21/990      69            22          22
                               según                                 
                               modalidad                             

  Cifrado          ❌          TLS         ❌            SSH         SSH

  Autenticación    Sí          Sí          Muy limitada  SSH         SSH

  Conexión         Sí          Sí          No            No          No
  control/datos                                                      
  separada                                                           

  Complejidad con  Alta        Alta        Baja          Baja        Baja
  NAT                                                                

  Transferencia    Sí          Sí          Muy limitada  Sí          No
  interactiva                                                        

  Gestión de       Sí          Sí          Muy limitada  Sí          Limitada
  directorios                                                        

  Uso recomendado  ❌          Según       Casos         ✅          ✅
  para nuevos                  necesidad   específicos               
  servicios                                                          
  seguros                                                            
  ------------------------------------------------------------------------------

> 🧠 La tabla describe características técnicas, no una clasificación
> universal de tecnologías. La elección depende del entorno y de los
> requisitos.

------------------------------------------------------------------------

# 🧠 63. ¿Qué protocolo utilizar?

Utiliza este árbol:

``` text
                   ¿Necesitas transferir?
                           │
                           ▼
                  ¿Información sensible?
                    /               \
                  NO                 SÍ
                  │                   │
                  ▼                   ▼
            ¿Dispositivo?       ¿Tienes SSH?
             /       \             /      \
           SÍ         NO          SÍ       NO
           │           │          │         │
          TFTP        FTP        SFTP     FTPS
```

Pero añade siempre:

``` text
🔐 autenticación
🧱 permisos
🔥 firewall
📜 logs
🧪 pruebas
```

------------------------------------------------------------------------

# 🧪 64. Reto final --- «Diseña el servicio»

Una empresa necesita:

### Requisito A

Publicar documentos de libre acceso.

### Requisito B

Permitir a empleados subir y descargar documentos.

### Requisito C

Copiar automáticamente backups entre servidores.

### Requisito D

Transferir configuraciones a routers de laboratorio.

### Requisito E

Evitar que las credenciales viajen en claro.

El alumno debe seleccionar una tecnología para cada caso y justificar:

-   protocolo;
-   transporte;
-   puerto;
-   autenticación;
-   cifrado;
-   firewall;
-   herramienta cliente;
-   servidor.

------------------------------------------------------------------------

# 🏆 65. Reto integral

Construye en VirtualBox:

``` text
                       🌐
                       │
                    Router
                       │
                ┌──────┴──────┐
                │             │
             CLIENTE       SERVIDOR
             Ubuntu        Ubuntu 26.04
             / WSL2             │
                                │
                    ┌───────────┼───────────┐
                    │           │           │
                   FTP         SFTP        TFTP
                  :21          :22          :69
```

## Debe incluir

### FTP

-   usuario local;
-   acceso anónimo controlado;
-   descarga;
-   subida;
-   modo pasivo;
-   rango PASV;
-   logs.

### SFTP

-   usuario;
-   autenticación mediante clave;
-   transferencia;
-   aislamiento.

### TFTP

-   transferencia de un fichero de prueba.

### Seguridad

-   firewall;
-   permisos;
-   análisis Wireshark;
-   explicación de riesgos.

------------------------------------------------------------------------

# 🩺 66. Caso de diagnóstico

El alumno recibe:

``` text
Cliente:
192.168.10.50

Servidor:
192.168.10.10

FTP:
TCP/21

PASV:
40000-40100
```

El usuario consigue:

``` text
LOGIN → OK
PWD   → OK
LIST  → ERROR
```

Debe demostrar si el problema está en:

``` text
1. FTP
2. firewall
3. NAT
4. puertos PASV
5. permisos
6. configuración vsftpd
```

### Evidencias mínimas

``` bash
ss -ltnp
systemctl status vsftpd
journalctl -u vsftpd
sudo tcpdump -ni any port 21
```

y una captura Wireshark.

------------------------------------------------------------------------

# 🧠 67. Resumen

``` text
                     📂 FICHEROS
                         │
          ┌──────────────┼──────────────┐
          │              │              │
         FTP            TFTP          SSH
          │              │              │
      ┌───┴───┐          │          ┌───┴───┐
      │       │          │          │       │
    ACTIVO  PASIVO      UDP        SFTP    SCP
      │       │                     │       │
      └── NAT/FW ───────┐           └───┬───┘
                         │               │
                        FTPS          🔐 SSH
                         │
                        TLS
```

Ideas fundamentales:

1.  FTP utiliza TCP y separa control y datos.
2.  La conexión de control utiliza tradicionalmente TCP/21.
3.  El modo activo implica conexiones de datos iniciadas por el
    servidor.
4.  El modo pasivo permite que el cliente inicie las conexiones de
    datos.
5.  NAT y firewalls hacen especialmente importante entender los modos
    FTP.
6.  FTP tradicional no cifra credenciales ni datos.
7.  FTPS protege FTP mediante TLS.
8.  FTPS y SFTP son tecnologías diferentes.
9.  TFTP utiliza UDP y proporciona una funcionalidad mínima.
10. SFTP funciona sobre SSH.
11. SCP permite copias mediante SSH; OpenSSH moderno utiliza SFTP como
    transporte para `scp`. citeturn0search7
12. `vsftpd` permite estudiar en profundidad FTP, usuarios, permisos,
    aislamiento y conexiones pasivas.
13. OpenSSH proporciona una solución segura para transferencia de
    ficheros.
14. Wireshark permite demostrar experimentalmente las diferencias entre
    protocolos.
15. La elección del protocolo debe basarse en requisitos técnicos y de
    seguridad.

------------------------------------------------------------------------

# ❓ 68. Autoevaluación

1.  ¿Qué es FTP y qué modelo de comunicación utiliza?
2.  ¿Qué diferencia existe entre conexión de control y conexión de
    datos?
3.  ¿Qué puerto utiliza tradicionalmente FTP para la conexión de
    control?
4.  Explica las diferencias entre modo activo y modo pasivo.
5.  ¿Por qué FTP puede presentar problemas cuando el cliente está detrás
    de NAT?
6.  ¿Qué función puede desempeñar un FTP ALG?
7.  ¿Qué diferencias existen entre acceso anónimo y acceso autenticado?
8.  ¿Qué finalidad tiene confinar a un usuario FTP mediante chroot?
9.  Diferencia transferencia ASCII y binaria.
10. ¿Por qué FTP tradicional no es seguro?
11. ¿Qué es FTPS?
12. Diferencia FTPS explícito e implícito.
13. ¿Qué diferencia fundamental existe entre FTPS y SFTP?
14. ¿Qué es TFTP y por qué resulta útil en dispositivos de red?
15. ¿Qué características de seguridad proporciona SSH?
16. ¿Qué diferencia existe entre SFTP y SCP?
17. ¿Qué puertos deben considerarse para un servidor FTP pasivo?
18. ¿Qué herramientas utilizarías para diagnosticar una transferencia
    FTP que falla después de autenticarse correctamente?

------------------------------------------------------------------------

# ✅ 69. Solucionario de la autoevaluación

### 1. ¿Qué es FTP?

FTP es un protocolo de aplicación para transferencia de ficheros basado
en TCP y en el modelo cliente/servidor.

------------------------------------------------------------------------

### 2. Control y datos

La conexión de **control** mantiene la sesión y transporta comandos y
respuestas.

La conexión de **datos** transporta los ficheros y listados.

------------------------------------------------------------------------

### 3. Puerto de control

Tradicionalmente:

``` text
TCP/21
```

------------------------------------------------------------------------

### 4. Activo y pasivo

**Activo:**

``` text
CLIENTE ──► SERVIDOR:21
SERVIDOR ──► CLIENTE:puerto_alto
```

El servidor inicia la conexión de datos.

**Pasivo:**

``` text
CLIENTE ──► SERVIDOR:21
CLIENTE ──► SERVIDOR:puerto_pasivo
```

El cliente inicia la conexión de datos.

------------------------------------------------------------------------

### 5. FTP detrás de NAT

En modo activo el servidor intenta iniciar una conexión hacia el
cliente. Un NAT/firewall puede impedir esa conexión entrante.

En modo pasivo el cliente inicia también la conexión de datos, aunque el
servidor debe tener correctamente configurado y publicado el rango de
puertos pasivos.

------------------------------------------------------------------------

### 6. FTP ALG

Un FTP ALG puede inspeccionar la comunicación FTP y adaptar la
información de las conexiones de datos para facilitar el funcionamiento
de FTP a través de NAT.

------------------------------------------------------------------------

### 7. Acceso anónimo/autenticado

**Anónimo:** utiliza una identidad especial como `anonymous` o `ftp`.

**Autenticado:** utiliza una cuenta reconocida por el servidor.

------------------------------------------------------------------------

### 8. Chroot

Restringe el espacio de ficheros visible para el usuario y evita que
pueda navegar libremente por el árbol del sistema.

------------------------------------------------------------------------

### 9. ASCII/binario

ASCII está pensado para determinados datos textuales y puede implicar
tratamiento de caracteres.

Binario conserva los bytes del fichero y debe utilizarse para datos como
imágenes, ejecutables, comprimidos, ISO, vídeo, etc.

------------------------------------------------------------------------

### 10. Seguridad FTP

FTP tradicional no cifra las credenciales ni los datos.

Un atacante que pueda observar el tráfico puede obtener información
sensible.

------------------------------------------------------------------------

### 11. FTPS

Es FTP protegido mediante TLS.

Proporciona mecanismos de cifrado y autenticación basados en TLS.

------------------------------------------------------------------------

### 12. FTPS explícito/implícito

**Explícito:** la conexión comienza como FTP y se solicita
explícitamente activar TLS.

**Implícito:** la conexión TLS se establece desde el comienzo.

------------------------------------------------------------------------

### 13. FTPS/SFTP

``` text
FTPS = FTP + TLS
SFTP = protocolo de transferencia sobre SSH
```

No son variantes del mismo protocolo.

------------------------------------------------------------------------

### 14. TFTP

TFTP es un protocolo de transferencia muy sencillo basado en UDP,
normalmente asociado al puerto:

``` text
UDP/69
```

Resulta útil en determinados escenarios de dispositivos de red, arranque
o transferencia de configuraciones.

No proporciona las garantías de seguridad de SSH.

------------------------------------------------------------------------

### 15. SSH

SSH proporciona un canal seguro para:

-   autenticación;
-   confidencialidad;
-   integridad;
-   administración remota;
-   transferencia de ficheros.

Ubuntu utiliza OpenSSH como implementación habitual. citeturn1search0

------------------------------------------------------------------------

### 16. SFTP/SCP

**SFTP** permite una sesión interactiva de transferencia de ficheros
sobre SSH.

**SCP** se utiliza tradicionalmente para copiar ficheros entre sistemas.
En OpenSSH moderno, `scp` utiliza SFTP como protocolo de transferencia.
citeturn0search7

------------------------------------------------------------------------

### 17. Puertos FTP pasivo

Se necesita:

``` text
TCP/21
```

para control y un rango de puertos TCP definido por el servidor para las
conexiones pasivas.

Ejemplo de laboratorio:

``` text
40000-40100/TCP
```

------------------------------------------------------------------------

### 18. Diagnóstico

Un procedimiento razonable sería:

``` text
1. ping
2. ss / nc
3. systemctl
4. logs
5. autenticación
6. permisos
7. configuración vsftpd
8. puertos PASV
9. firewall
10. Wireshark/tcpdump
```

------------------------------------------------------------------------

# 📝 70. Test de repaso

El capítulo original contiene un test de 10 preguntas. Algunas
cuestiones dependen de detalles concretos de la terminología y
configuración utilizada en el manual original.

Para esta versión actualizada se propone este test:

### 1. FTP utiliza como protocolo de transporte:

a)  UDP\
b)  TCP\
c)  ICMP\
d)  ARP

### 2. La conexión de control FTP utiliza tradicionalmente:

a)  20/TCP\
b)  21/TCP\
c)  22/TCP\
d)  69/UDP

### 3. En modo activo:

a)  El cliente inicia la conexión de datos.\
b)  El servidor inicia la conexión de datos.\
c)  No existe conexión de datos.\
d)  Se utiliza exclusivamente UDP.

### 4. En modo pasivo:

a)  El servidor siempre inicia la conexión de datos.\
b)  El cliente inicia la conexión de datos hacia un puerto anunciado por
    el servidor.\
c)  Se utiliza siempre TCP/20.\
d)  Se utiliza UDP/69.

### 5. ¿Cuál cifra FTP mediante TLS?

a)  SFTP\
b)  TFTP\
c)  FTPS\
d)  SCP

### 6. ¿Cuál funciona sobre SSH?

a)  FTP\
b)  FTPS\
c)  TFTP\
d)  SFTP

### 7. TFTP utiliza:

a)  TCP/21\
b)  TCP/22\
c)  UDP/69\
d)  UDP/53

### 8. ¿Qué directiva de `vsftpd` habilita operaciones que modifican el

sistema de ficheros?

a)  `local_enable`\
b)  `write_enable`\
c)  `pasv_enable`\
d)  `listen`

### 9. ¿Qué comando inicia una transferencia SFTP?

a)  `ftp`\
b)  `sftp`\
c)  `tftp`\
d)  `ftps`

### 10. ¿Qué mecanismo permite limitar el rango de puertos utilizados por

PASV en `vsftpd`?

a)  `pasv_min_port` / `pasv_max_port`\
b)  `ftp_data_port` / `listen_port`\
c)  `ssh_port` / `sftp_port`\
d)  `data_min` / `data_max`

------------------------------------------------------------------------

# ✅ 71. Respuestas del test

    Nº  Respuesta
  ---- -----------
     1    **b**
     2    **b**
     3    **b**
     4    **b**
     5    **c**
     6    **d**
     7    **c**
     8    **b**
     9    **b**
    10    **a**

------------------------------------------------------------------------

# 📚 72. Correspondencia con el capítulo original

  Capítulo original            UT4 actualizada
  ---------------------------- --------------------------------------
  Servicios de transferencia   Transferencia de ficheros
  FTP                          FTP + arquitectura actual
  Clientes FTP                 CLI + clientes gráficos
  Servidores FTP               `vsftpd`
  Tipos de acceso              Anónimo + autenticado
  Conexiones FTP               Control + datos
  Modo activo                  Activo + NAT/firewall
  Modo pasivo                  PASV + rango de puertos
  Tipos de transferencia       ASCII + binario
  Seguridad                    Análisis crítico de FTP
  FTPS                         TLS
  FXP                          Transferencia servidor-servidor
  TFTP                         UDP/69 + laboratorio Cisco
  SFTP/SCP                     OpenSSH
  FileZilla                    Cliente gráfico complementario
  FileZilla Server Windows     Sustituido por `vsftpd`
  `vsftpd`                     **Se mantiene y actualiza**
  Zentyal                      Se elimina como plataforma principal
  IIS FTP                      Se trata como tecnología histórica
  Windows 2008                 Sustituido por Ubuntu 26.04
  Navegador FTP                **Eliminado como práctica actual**
  Wireshark                    Se mantiene y amplía
  Prácticas                    Packet Tracer + WSL2 + VirtualBox

------------------------------------------------------------------------

# 🔄 73. Evolución tecnológica

``` text
                 MODELO ORIGINAL
                       │
       ┌───────────────┼────────────────┐
       │               │                │
 Windows 2008       Debian           Zentyal
 FileZilla Server   vsftpd            FTP
       │               │                │
       └───────────────┼────────────────┘
                       ▼
                 MODELO ACTUAL
                       │
       ┌───────────────┼────────────────┐
       │               │                │
 Packet Tracer       Ubuntu 26.04     OpenSSH
       │               │                │
     FTP/TFTP        vsftpd          SFTP/SCP
                       │                │
                       └──────┬─────────┘
                              ▼
                         🔐 SEGURIDAD
```

Ubuntu mantiene `vsftpd` como servidor FTP, pero su documentación actual
advierte que FTP no debe utilizarse para transferencias que necesiten
confidencialidad y remite a SFTP/OpenSSH para ese propósito.
citeturn1search1

------------------------------------------------------------------------

# 🧠 74. Ideas clave para examen

> 🔴 **FTP ≠ SFTP**
>
> 🔴 **FTPS ≠ SFTP**
>
> 🔴 **TFTP ≠ FTP**
>
> 🔴 **TCP/21 = control FTP**
>
> 🔴 **TCP/20 no significa «todos los datos FTP»**
>
> 🔴 **PASV requiere puertos adicionales**
>
> 🔴 **FTP tradicional no cifra**
>
> 🔴 **SFTP utiliza SSH**
>
> 🔴 **TFTP utiliza UDP**
>
> 🔴 **NAT puede romper FTP activo**
>
> 🔴 **Firewall debe permitir tanto control como datos cuando
> corresponda**

------------------------------------------------------------------------

# 🏁 75. Resultado esperado

Al terminar la UT4, el alumno debe poder enfrentarse a este escenario:

``` text
«Tengo un servidor Ubuntu.

Necesito:
  📥 publicar ficheros,
  📤 permitir subidas,
  🔐 transferir información confidencial,
  🌐 atravesar un firewall,
  🧪 comprobar el tráfico,
  📜 registrar las operaciones.

¿Qué servicio instalo?
¿Cómo lo configuro?
¿Qué puertos necesito?
¿Cómo lo autentico?
¿Cómo compruebo que funciona?
¿Cómo demostraría con Wireshark qué está ocurriendo?
»
```

La respuesta no consiste en instalar simplemente `vsftpd`.

Debe comenzar por:

``` text
REQUISITOS
    ↓
PROTOCOLO
    ↓
ARQUITECTURA
    ↓
AUTENTICACIÓN
    ↓
PERMISOS
    ↓
FIREWALL/NAT
    ↓
CONFIGURACIÓN
    ↓
PRUEBA
    ↓
CAPTURA
    ↓
DIAGNÓSTICO
```

------------------------------------------------------------------------

# 📖 76. Referencias

### Fuente principal

**Garceta --- Servicios de Red e Internet**, capítulo 4: **«Servicios de
transferencia de ficheros»**.

El índice del manual sitúa el capítulo en las páginas 155--194 e incluye
FTP, servidores y clientes, tipos de acceso, conexiones y modos,
transferencia, seguridad, FTPS, FXP, TFTP, SFTP/SCP, prácticas, resumen
y test de repaso. fileciteturn23file0L21-L23

El capítulo original establece como objetivos instalar y configurar
servidores de transferencia, configurar acceso anónimo, crear usuarios y
grupos, establecer límites y comprobar los modos activo y pasivo.
fileciteturn25file0L11-L13

### Documentación actual

-   Ubuntu Server --- configuración de FTP con `vsftpd`.
    citeturn1search1
-   Ubuntu Server --- OpenSSH Server. citeturn1search0
-   Ubuntu/Manpages --- `vsftpd` y `vsftpd.conf`.
    citeturn0search0turn0search1
-   OpenSSH --- `sftp-server`. citeturn0search3
-   OpenSSH --- `scp`. citeturn0search7

------------------------------------------------------------------------

::: {align="center"}
## 📂 UT4 · TRANSFERENCIA DE FICHEROS

``` text
FTP ────────► comprender
FTPS ───────► proteger con TLS
TFTP ───────► simplificar
SFTP ───────► proteger con SSH
SCP ────────► copiar con SSH

             🧠
      NO SOLO TRANSFERIR
       SINO COMPRENDER
```

**FIN DE LA UT4**
:::


---

# 🐳 Laboratorio Docker Compose · Anexo IV

La práctica de transferencia se puede reproducir con [`docker/ut4`](docker/ut4/), que proporciona FTP y SSH/SFTP.

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
