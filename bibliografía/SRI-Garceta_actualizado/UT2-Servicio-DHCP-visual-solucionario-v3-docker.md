
> 🔬 **VERSIÓN V2 · REVISIÓN TÉCNICA 2026-09-18**
>
> Se ha realizado una segunda pasada sobre los bloques de código y las configuraciones prácticas. Corregidos los fragmentos JSON para que sean JSON válido y añadida la comprobación nativa `kea-dhcp4 -t`.
>
> ⚠️ La validación automática cubre sintaxis y configuraciones aisladas; la validación extremo a extremo > de Cisco Packet Tracer, WSL2 y una VM real de Ubuntu 26.04 Server requiere ejecutar el laboratorio en esos entornos.

::: {align="center"}
# 🌐⚡ UT2 · SERVICIO DHCP ⚡🌐

### 🧩 De una red configurada a una red que se configura sola

``` text
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║          📡 DHCP  ·  IP  ·  DNS  ·  GATEWAY  ·  LEASES          ║
║                                                                  ║
║       🔄 DORA       🧷 RESERVAS       🌉 RELAY       🛡️ HA       ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**SERVICIOS DE RED E INTERNET · CFGS ASIR**

`Cisco Packet Tracer` · `WSL2 + Ubuntu 26.04` ·
`VirtualBox + Ubuntu 26.04 Server`

**Material docente actualizado · 2026.09**
:::

------------------------------------------------------------------------

> 🎯 **MISIÓN DE LA UT**
>
> Comprender cómo un cliente obtiene automáticamente su configuración de
> red, cómo se mantiene una concesión DHCP y cómo diseñar, configurar,
> verificar y diagnosticar un servicio DHCP en una red real o simulada.

> 💡 **Actualización importante**
>
> El material original utiliza principalmente **ISC DHCP** y ejemplos
> basados en Windows Server 2008 y Debian. En esta versión se conserva
> la arquitectura conceptual del capítulo, pero las prácticas Linux se
> trasladan a **Kea DHCP**. ISC declaró ISC DHCP *End of Life* en 2022 y
> recomienda migrar a Kea. Ubuntu 26.04 incluye `kea-dhcp4-server` 3.0.3
> en sus repositorios.\
> Véase la documentación oficial de ISC y el catálogo de paquetes de
> Ubuntu.

------------------------------------------------------------------------

# 🧭 Mapa de la unidad

``` text
                         📡 DHCP
                           │
             ┌─────────────┼─────────────┐
             │             │             │
          🏠 CLIENTE    🖥️ SERVIDOR    🌉 RELAY
             │             │             │
             └───────┬─────┴─────┬───────┘
                     │           │
                  🔄 DORA     🗂️ ÁMBITOS
                     │           │
                ⏱️ LEASE     🧷 RESERVAS
                     │           │
                     └─────┬─────┘
                           │
                    🧪 VERIFICACIÓN
                           │
              ┌────────────┼────────────┐
              │            │            │
         Packet Tracer   Ubuntu 26.04   Wireshark
                          + Kea
```

------------------------------------------------------------------------

# 🎯 0. Objetivos

Al finalizar esta unidad deberás ser capaz de:

-   Explicar qué problema resuelve DHCP.
-   Diferenciar configuración manual y automática.
-   Identificar los componentes de una arquitectura DHCP.
-   Comprender las fases de obtención y renovación de una concesión.
-   Diferenciar **asignación manual, automática y dinámica**.
-   Trabajar con ámbitos, rangos, exclusiones y reservas.
-   Configurar opciones como máscara, gateway y DNS.
-   Comprender el formato y finalidad de los mensajes DHCP.
-   Analizar **DHCPDISCOVER, DHCPOFFER, DHCPREQUEST y DHCPACK**.
-   Comprender qué ocurre cuando cliente y servidor están en redes
    diferentes.
-   Configurar un **DHCP relay**.
-   Analizar tráfico DHCP con Wireshark.
-   Configurar un servidor DHCP moderno en Ubuntu 26.04 Server mediante
    **Kea**.
-   Diagnosticar errores de direccionamiento automático.

------------------------------------------------------------------------

# 🚀 1. Introducción

DHCP (*Dynamic Host Configuration Protocol*) permite proporcionar
automáticamente a los clientes los parámetros necesarios para
comunicarse mediante IP.

Un cliente DHCP puede recibir, entre otros:

-   Dirección IPv4.
-   Máscara de red.
-   Puerta de enlace predeterminada.
-   Servidores DNS.
-   Nombre de dominio.
-   Tiempo de concesión.
-   Otros parámetros definidos mediante opciones DHCP.

Sin DHCP, cada equipo tendría que recibir manualmente esta información.

``` text
              CONFIGURACIÓN MANUAL
              ─────────────────────
                 👨‍💻 Administrador
                        │
                        ├── IP
                        ├── Máscara
                        ├── Gateway
                        └── DNS


              CONFIGURACIÓN DHCP
              ──────────────────
                 🖥️ Cliente
                     │
                     │ DHCP
                     ▼
                📡 Servidor
                     │
             ┌───────┴───────┐
             ▼               ▼
            IP              DNS
```

------------------------------------------------------------------------

# 🧠 2. ¿Qué problema resuelve DHCP?

En una red pequeña puede parecer sencillo configurar manualmente todos
los equipos.

En una red con cientos o miles de dispositivos aparecen rápidamente
problemas:

-   Duplicación de direcciones.
-   Errores de máscara.
-   Gateways incorrectos.
-   DNS mal configurado.
-   Dificultad para modificar parámetros.
-   Equipos que cambian de ubicación.
-   Direcciones que quedan ocupadas innecesariamente.
-   Mayor carga administrativa.

DHCP centraliza esta configuración.

> ⚠️ **DHCP no sustituye al direccionamiento bien diseñado.**
>
> El administrador sigue teniendo que definir correctamente las redes,
> los rangos disponibles, las reservas y las opciones que recibirán los
> clientes.

------------------------------------------------------------------------

# 🧱 3. Componentes del servicio DHCP

El funcionamiento puede entenderse mediante cuatro elementos
principales:

  Componente          Función
  ------------------- -------------------------------------
  📡 Servidor DHCP    Asigna direcciones y parámetros
  💻 Cliente DHCP     Solicita y utiliza la configuración
  📜 Protocolo DHCP   Define mensajes y reglas
  🌉 Relay DHCP       Transporta peticiones entre redes

``` text
       CLIENTE
          │
          │ DHCP
          ▼
    ┌─────────────┐
    │ DHCP SERVER │
    └─────────────┘

Si están en redes diferentes:

       CLIENTE
          │
          ▼
    🌉 DHCP RELAY
          │
          ▼
    DHCP SERVER
```

------------------------------------------------------------------------

# 🏷️ 4. Asignación de direcciones

El material original distingue tres mecanismos.

## 4.1. Asignación manual o reserva

El administrador establece una correspondencia entre un cliente y una
dirección determinada.

Ejemplo conceptual:

``` text
MAC  00:11:22:33:44:55
          │
          ▼
       192.168.10.50
```

La dirección se entrega mediante DHCP, pero queda asociada al cliente.

En Kea puede realizarse mediante **host reservations**.

------------------------------------------------------------------------

## 4.2. Asignación dinámica

El servidor selecciona una dirección disponible de un conjunto o *pool*
y la entrega durante un tiempo determinado.

``` text
POOL DHCP

192.168.10.100 ─────────────── 192.168.10.200
       │                              │
       └──────── direcciones ─────────┘
```

La dirección pertenece al cliente durante una **concesión** (*lease*).

------------------------------------------------------------------------

## 4.3. Asignación automática

El servidor puede asignar una dirección de forma persistente siguiendo
la política configurada.

La distinción exacta entre automática y dinámica depende de la
implementación y de la política de administración utilizada.

------------------------------------------------------------------------

# 📦 5. Ámbitos, subredes y pools

Un servidor DHCP debe saber **para qué red** está sirviendo direcciones.

En terminología tradicional se habla de:

-   Ámbito.
-   Rango.
-   Exclusiones.
-   Reservas.
-   Opciones.

En Kea la configuración DHCPv4 utiliza principalmente el concepto
`subnet4`, dentro del cual se pueden definir uno o varios `pools`.

Ejemplo:

``` text
SUBRED
192.168.10.0/24
       │
       ├── Gateway: 192.168.10.1
       ├── DNS:     192.168.10.10
       │
       └── POOL
           192.168.10.100 - 192.168.10.200
```

------------------------------------------------------------------------

# 🚫 6. Exclusiones

No todas las direcciones de una subred deben entregarse dinámicamente.

Por ejemplo:

``` text
192.168.10.0/24

.1       Router
.10      Servidor DNS
.20      Servidor web
.30      Impresora
.100-.200 DHCP
```

La zona dinámica debe evitar direcciones utilizadas por dispositivos con
configuración estática.

> 💡 En un diseño actual es frecuente separar claramente:
>
> -   infraestructura,
> -   servidores,
> -   dispositivos reservados,
> -   clientes dinámicos.

------------------------------------------------------------------------

# 🧷 7. Reservas DHCP

Una reserva permite que un cliente concreto reciba siempre una dirección
determinada.

En Kea una reserva puede asociarse, entre otros identificadores, a una
dirección MAC mediante `hw-address`.

Ejemplo:

``` json
{
  "reservations": [
    {
      "hw-address": "00:11:22:33:44:55",
      "ip-address": "192.168.10.50"
    }
  ]
}
```

> ⚠️ Una reserva **no es lo mismo que configurar manualmente la IP en el
> cliente**.
>
> En una reserva el cliente sigue utilizando DHCP.

------------------------------------------------------------------------

# ⏱️ 8. Tiempo de concesión --- Lease Time

Una dirección dinámica se entrega durante un periodo limitado.

``` text
     OBTENCIÓN
        │
        ▼
┌───────────────────┐
│   LEASE ACTIVA    │
└───────────────────┘
        │
        ├── renovación
        │
        └── expiración
```

El tiempo de concesión debe adaptarse al tipo de red.

### Red con pocos clientes

Puede utilizar concesiones largas.

### Red con muchos clientes temporales

Puede interesar reducir la duración.

Ejemplos:

-   Aula informática.
-   Red Wi-Fi de invitados.
-   Laboratorio.
-   Red de dispositivos temporales.

------------------------------------------------------------------------

# 🔄 9. Funcionamiento DHCP: DORA

La secuencia clásica para obtener una concesión IPv4 se resume mediante
**DORA**:

``` text
        CLIENTE                         SERVIDOR
           │                                │
           │──── DHCPDISCOVER ─────────────>│
           │                                │
           │<──── DHCPOFFER ────────────────│
           │                                │
           │──── DHCPREQUEST ──────────────>│
           │                                │
           │<──── DHCPACK ──────────────────│
           │                                │
           ▼                                ▼
       CONFIGURADO                       CONCESIÓN
```

------------------------------------------------------------------------

# 📡 10. DHCPDISCOVER

El cliente todavía no dispone de una configuración IPv4 válida para esa
red.

Emite un mensaje **DHCPDISCOVER** para localizar servidores DHCP.

En el escenario inicial puede utilizar difusión (*broadcast*).

------------------------------------------------------------------------

# 📤 11. DHCPOFFER

Un servidor DHCP que puede atender la petición responde con una oferta.

La oferta puede incluir:

-   Dirección IP propuesta.
-   Máscara.
-   Tiempo de concesión.
-   Gateway.
-   DNS.
-   Otras opciones.

------------------------------------------------------------------------

# 📬 12. DHCPREQUEST

El cliente selecciona una oferta y solicita formalmente la
configuración.

Cuando existen varios servidores, este mensaje también permite indicar
cuál ha sido seleccionado.

------------------------------------------------------------------------

# ✅ 13. DHCPACK

El servidor confirma la concesión mediante **DHCPACK**.

El cliente puede configurar entonces:

``` text
IP       → 192.168.10.101
Máscara  → 255.255.255.0
Gateway  → 192.168.10.1
DNS      → 192.168.10.10
Lease    → 8 horas
```

------------------------------------------------------------------------

# ❌ 14. DHCPNAK

El servidor puede responder con **DHCPNAK** cuando la solicitud no puede
aceptarse, por ejemplo porque la configuración solicitada no es válida
para la red atendida.

No debe confundirse con una simple ausencia de respuesta.

------------------------------------------------------------------------

# 🔁 15. Renovación de la concesión

Una concesión no permanece indefinidamente.

El cliente intenta renovarla antes de que expire.

``` text
          LEASE
            │
            │
       ┌────▼────┐
       │   T1    │ ──► intento de renovación
       └────┬────┘
            │
            │ si no responde
            ▼
       ┌─────────┐
       │   T2    │ ──► búsqueda más amplia
       └────┬────┘
            │
            ▼
        EXPIRACIÓN
```

La implementación concreta de T1 y T2 depende de la configuración y del
protocolo.

------------------------------------------------------------------------

# 🔌 16. Puertos utilizados por DHCP

DHCP para IPv4 utiliza **UDP**.

  Función           Puerto
  --------------- --------
  Servidor DHCP     UDP 67
  Cliente DHCP      UDP 68

``` text
CLIENTE                         SERVIDOR
UDP 68  ───── DHCP ──────────► UDP 67
UDP 68  ◄──── DHCP ─────────── UDP 67
```

> 🧠 **Para recordar:** DHCP no utiliza TCP para el intercambio normal
> de mensajes DHCPv4.

------------------------------------------------------------------------

# 🌉 17. DHCP Relay

Un broadcast DHCP no atraviesa routers de forma normal.

Por tanto:

``` text
❌ NO

LAN A ── DHCP Broadcast ──X── Router ──X── DHCP Server


✅ SÍ

LAN A
  │
  ▼
🌉 RELAY
  │
  │ DHCP reenviado
  ▼
DHCP SERVER
```

El relay recibe la petición en una red y genera/reenvía un mensaje hacia
el servidor DHCP.

En Cisco IOS se utiliza habitualmente:

``` text
interface GigabitEthernet0/0
 ip helper-address 192.168.20.10
```

El `ip helper-address` permite reenviar broadcasts UDP, incluyendo DHCP,
hacia el servidor configurado.

------------------------------------------------------------------------

# 🧭 18. ¿Cómo sabe el servidor qué red debe atender?

Cuando existe un relay, el mensaje reenviado incorpora información que
permite al servidor determinar la red desde la que procede la petición.

En Cisco aparece especialmente el campo **giaddr** (*gateway IP
address*).

``` text
CLIENTE
192.168.10.0/24
      │
      ▼
R1
192.168.10.1
      │
      │ relay
      ▼
DHCP SERVER
192.168.20.10
```

El servidor puede utilizar esa información para seleccionar el `subnet4`
correspondiente.

------------------------------------------------------------------------

# 🧩 19. DHCP en varias redes

Un único servidor DHCP puede proporcionar configuración a varias
subredes cuando existe conectividad y un mecanismo de relay.

``` text
                 DHCP SERVER
                 192.168.30.10
                       │
             ┌─────────┴─────────┐
             │                   │
          RELAY               RELAY
             │                   │
        192.168.10.0/24     192.168.20.0/24
```

Esto evita tener que desplegar un servidor DHCP independiente en cada
LAN.

------------------------------------------------------------------------

# 🧮 20. Opciones DHCP

Una dirección IP no es suficiente para configurar un cliente.

Entre las opciones habituales:

  Opción                  Función
  ----------------------- ------------------------
  `routers`               Gateway predeterminado
  `domain-name-servers`   Servidores DNS
  `domain-name`           Dominio
  `host-name`             Nombre del host
  `ntp-servers`           Servidores NTP
  `broadcast-address`     Broadcast de la red

En Kea se pueden establecer mediante `option-data`.

Ejemplo:

``` json
{
  "option-data": [
    {
      "name": "routers",
      "data": "192.168.10.1"
    },
    {
      "name": "domain-name-servers",
      "data": "192.168.10.10"
    }
  ]
}
```

------------------------------------------------------------------------

# 🗃️ 21. Base de datos de concesiones

El servidor necesita conservar información sobre las concesiones.

Kea puede utilizar distintos backends. Para un laboratorio sencillo es
especialmente útil `memfile`.

``` text
       KEA DHCP
          │
          ▼
    ┌──────────────┐
    │  LEASE DATA  │
    └──────────────┘
          │
          ├── cliente
          ├── dirección
          ├── estado
          └── tiempos
```

Para entornos más complejos puede utilizarse una base de datos como
MySQL/MariaDB o PostgreSQL, según la arquitectura desplegada.

------------------------------------------------------------------------

# 🛡️ 22. Varios servidores DHCP

El material original introduce el funcionamiento con varios servidores
DHCP.

Puede utilizarse para:

-   redundancia,
-   continuidad del servicio,
-   reparto de carga,
-   disponibilidad.

Pero **dos servidores independientes no deben configurarse sin
coordinación sobre el mismo pool**, porque podrían producir asignaciones
conflictivas.

------------------------------------------------------------------------

# 🔄 23. Alta disponibilidad y DHCP Failover

El capítulo original introduce **DHCP Failover Protocol**.

La tecnología ha evolucionado. En el laboratorio actual se distinguirán:

-   el concepto de redundancia DHCP,
-   la coordinación de concesiones,
-   las implementaciones concretas de alta disponibilidad.

Kea dispone de mecanismos de **High Availability**, mientras que el
antiguo ISC DHCP Failover pertenece a una tecnología asociada al
software ya retirado.

> ⚠️ No se debe trasladar literalmente una configuración de `dhcpd.conf`
> antigua a Kea. Son productos y modelos de configuración diferentes.

------------------------------------------------------------------------

# 🔐 24. Seguridad DHCP

DHCP es un servicio crítico porque controla parte de la configuración de
red.

Amenazas posibles:

### 🕵️ DHCP Rogue

Un equipo no autorizado actúa como servidor DHCP.

``` text
CLIENTE
   │
   ├──── DHCPDISCOVER ────► Servidor legítimo
   │
   └──── DHCPDISCOVER ────► 🚨 Rogue DHCP
```

El cliente podría recibir:

-   gateway malicioso,
-   DNS controlado por un atacante,
-   direcciones incorrectas,
-   información de red manipulada.

### 🛡️ Medidas

En switches gestionables pueden utilizarse mecanismos como **DHCP
Snooping** y políticas de puertos.

------------------------------------------------------------------------

# 🧪 25. PRÁCTICA 1 --- DHCP básico en Cisco Packet Tracer

## Objetivo

Construir una LAN donde los clientes obtengan automáticamente su
configuración.

### Topología

``` text
      🖥️ PC-A
          │
          │
      ┌───┴───┐
      │ SWITCH│
      └───┬───┘
          │
     📡 DHCP Server
```

### Direccionamiento

Servidor:

``` text
IP:       192.168.10.2/24
Gateway:  192.168.10.1
```

Pool:

``` text
Network:        192.168.10.0/24
Default Gateway:192.168.10.1
DNS:            192.168.10.2
Start IP:       192.168.10.100
Maximum users:  50
```

### Tareas

1.  Crear la topología.
2.  Configurar el servidor con IP estática.
3.  Activar el servicio DHCP.
4.  Crear el pool.
5.  Configurar el PC como DHCP.
6.  Comprobar la dirección obtenida.
7.  Comprobar gateway y DNS.
8.  Utilizar `ping`.
9.  Cambiar temporalmente una opción del pool.
10. Renovar la configuración y comprobar el cambio.

------------------------------------------------------------------------

# 🧪 26. PRÁCTICA 2 --- DHCP en varias redes con relay

## Objetivo

Comprobar que un servidor DHCP puede atender clientes de varias redes
mediante un router configurado como relay.

``` text
       LAN 10                         LAN 20
192.168.10.0/24                 192.168.20.0/24
      │                                │
      ▼                                ▼
     PCs                              PCs
      │                                │
      └──────────── Router ────────────┘
                       │
                       │
                 DHCP Server
                 192.168.30.10
```

En cada interfaz del router que reciba peticiones DHCP se configurará:

``` text
ip helper-address 192.168.30.10
```

Cisco documenta `ip helper-address` como mecanismo para reenviar
broadcasts UDP, incluidos BOOTP y DHCP. citeturn3search0turn3search8

### Evidencias

El alumno deberá demostrar:

-   IP obtenida en LAN 10.
-   IP obtenida en LAN 20.
-   Gateway correcto en cada LAN.
-   Que ambas concesiones proceden del mismo servidor.
-   Diferencias entre los pools.

------------------------------------------------------------------------

# 🧪 27. PRÁCTICA 3 --- DHCPv4 con Kea en VirtualBox + Ubuntu 26.04 Server

## Objetivo

Instalar y configurar un servidor DHCP moderno utilizando Kea.

Ubuntu 26.04 proporciona el paquete `kea-dhcp4-server`; el catálogo de
paquetes de Ubuntu muestra la rama 3.0.x para 26.04 LTS.
citeturn1search0

### Topología

``` text
              VirtualBox
                  │
        ┌─────────┴─────────┐
        │                   │
   🖥️ DHCP SERVER       💻 CLIENTE
        │                   │
        └──── SRI-DHCP ─────┘
          192.168.10.0/24
```

### Servidor

``` text
IP:       192.168.10.2/24
Gateway:  192.168.10.1
```

### Cliente

``` text
DHCP automático
```

### Instalar Kea

``` bash
sudo apt update
sudo apt install kea-dhcp4-server
```

El paquete `kea-dhcp4-server` está disponible para Ubuntu 26.04 LTS.
citeturn1search0

------------------------------------------------------------------------

# 🛠️ 28. Configuración básica de Kea

El fichero de configuración DHCPv4 contiene un objeto `Dhcp4`.

Una configuración mínima puede seguir esta estructura:

``` json
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": [ "enp0s8" ]
    },

    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/lib/kea/dhcp4.leases"
    },

    "valid-lifetime": 28800,

    "subnet4": [
      {
        "subnet": "192.168.10.0/24",

        "pools": [
          {
            "pool": "192.168.10.100 - 192.168.10.200"
          }
        ],

        "option-data": [
          {
            "name": "routers",
            "data": "192.168.10.1"
          },
          {
            "name": "domain-name-servers",
            "data": "192.168.10.1"
          }
        ]
      }
    ]
  }
}
```

La estructura `interfaces-config`, `lease-database`, `valid-lifetime` y
`subnet4/pools` corresponde a la configuración DHCPv4 documentada por
Kea. citeturn2search2

> 🔎 **Importante:** adapta el nombre de interfaz (`enp0s8`) a la
> interfaz real de la máquina.

Puedes comprobarla con:

``` bash
ip addr
```

------------------------------------------------------------------------

# 🧪 29. Validar la configuración de Kea

Antes de iniciar el servicio conviene comprobar que el JSON es válido y
que la configuración puede ser aceptada por Kea.

La comprobación recomendada para Kea es:

``` bash
sudo kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
```

`-t` comprueba la configuración e informa del primer error detectado.

Consulta la ayuda y la versión disponibles:

``` bash
kea-dhcp4 -V
kea-dhcp4 --help
```

Después verifica el estado del servicio:

``` bash
systemctl status kea-dhcp4-server
```

Y revisa los registros:

``` bash
journalctl -u kea-dhcp4-server
```

### Objetivo de diagnóstico

Si el cliente no obtiene IP, no debemos empezar modificando el pool al
azar.

Seguir:

``` text
1️⃣ ¿La interfaz del servidor existe?
        ↓
2️⃣ ¿Tiene IP en la LAN?
        ↓
3️⃣ ¿Kea escucha en esa interfaz?
        ↓
4️⃣ ¿El servicio está activo?
        ↓
5️⃣ ¿El pool pertenece a esa subred?
        ↓
6️⃣ ¿El cliente está realmente en DHCP?
        ↓
7️⃣ ¿Hay firewall?
        ↓
8️⃣ ¿Qué muestran los paquetes?
```

------------------------------------------------------------------------

# 🧷 30. PRÁCTICA 4 --- Reservas DHCP con Kea

Configura:

``` text
Cliente A
MAC: 00:11:22:33:44:55
IP reservada: 192.168.10.50
```

Ejemplo:

``` json
{
  "reservations": [
    {
      "hw-address": "00:11:22:33:44:55",
      "ip-address": "192.168.10.50"
    }
  ]
}
```

### Comprobaciones

1.  Arrancar cliente.
2.  Solicitar configuración DHCP.
3.  Verificar que recibe `.50`.
4.  Liberar la concesión.
5.  Volver a solicitar configuración.
6.  Comprobar que continúa recibiendo `.50`.

La documentación de Kea permite reservas mediante `hw-address`,
`client-id`, DUID y otros identificadores. citeturn2search11

------------------------------------------------------------------------

# 📡 31. PRÁCTICA 5 --- Analizar DHCP con Wireshark

## Objetivo

Dejar de considerar DHCP como una "caja negra".

Captura tráfico en la interfaz correspondiente.

Filtro Wireshark:

``` text
dhcp
```

o:

``` text
bootp
```

Busca:

``` text
DHCPDISCOVER
DHCPOFFER
DHCPREQUEST
DHCPACK
```

### Actividad

Construye una tabla:

  Mensaje    Origen     Destino              Función
  ---------- ---------- -------------------- -----------------------
  DISCOVER   Cliente    Broadcast/servidor   Buscar servidores
  OFFER      Servidor   Cliente              Ofrecer configuración
  REQUEST    Cliente    Servidor             Solicitar oferta
  ACK        Servidor   Cliente              Confirmar concesión

### Reto

Identifica en una captura:

-   dirección MAC del cliente,
-   dirección ofrecida,
-   servidor DHCP,
-   gateway,
-   DNS,
-   duración de la concesión.

------------------------------------------------------------------------

# 🌉 32. PRÁCTICA 6 --- DHCP Relay

Construye:

``` text
LAN A                         LAN B
192.168.10.0/24               192.168.20.0/24
     │                              │
    PC ──────── Router ─────────────┘
                   │
                   ▼
             DHCP SERVER
             192.168.20.10
```

En la interfaz del router conectada a la LAN A:

``` text
ip helper-address 192.168.20.10
```

### Comprobación

El cliente de LAN A debe recibir una dirección del pool correspondiente
a `192.168.10.0/24`.

> 🧠 **Pregunta clave**
>
> ¿Cómo puede el servidor saber que la solicitud procede de LAN A si el
> servidor está en LAN B?
>
> Analiza el campo `giaddr` en una captura.

------------------------------------------------------------------------

# 🧪 33. PRÁCTICA 7 --- DHCP en WSL2

WSL2 se utilizará principalmente como **cliente y entorno de análisis**,
no como sustituto de una LAN virtual completa.

Ejecuta:

``` bash
ip addr
ip route
resolvectl status
```

Comprueba:

-   dirección IP,
-   interfaz activa,
-   gateway,
-   DNS.

Después:

``` bash
ip route get 8.8.8.8
```

Y:

``` bash
ss -lunp
```

### Reto

Compara la configuración obtenida en WSL2 con la de una máquina virtual
Ubuntu Server.

> ⚠️ WSL2 tiene una arquitectura de red propia y no debe utilizarse como
> sustituto directo de una topología de varias LAN. Para las prácticas
> de servidor DHCP y relay se utilizará preferentemente VirtualBox o
> Packet Tracer.

------------------------------------------------------------------------

# 🧰 34. Herramientas fundamentales

## `ip addr`

``` bash
ip addr
```

Muestra interfaces y direcciones.

## `ip route`

``` bash
ip route
```

Muestra la tabla de routing.

## `ping`

``` bash
ping 192.168.10.1
```

Comprueba conectividad IP.

## `ss`

``` bash
ss -lunp
```

Permite observar sockets UDP.

## `journalctl`

``` bash
journalctl -u kea-dhcp4-server
```

Permite estudiar los registros del servicio.

## Wireshark

Permite analizar el intercambio DHCP paquete a paquete.

------------------------------------------------------------------------

# 🚨 35. Errores frecuentes

### ❌ El cliente obtiene `169.254.x.x`

Posibles causas:

-   no encuentra servidor DHCP,
-   servidor apagado,
-   relay incorrecto,
-   interfaz equivocada,
-   firewall,
-   VLAN incorrecta.

### ❌ El cliente recibe IP pero no navega

Comprobar:

``` text
IP       ✓
Máscara  ✓
Gateway  ?
DNS      ?
Routing  ?
```

### ❌ El servidor funciona pero no entrega IP

Comprobar:

``` bash
systemctl status kea-dhcp4-server
journalctl -u kea-dhcp4-server
```

### ❌ Kea no arranca

Revisar:

-   JSON mal formado,
-   nombre de interfaz incorrecto,
-   puerto ocupado,
-   permisos,
-   configuración incompatible.

### ❌ Dos servidores entregan direcciones

No asumir automáticamente que existe alta disponibilidad.

Comprobar qué servidores están respondiendo.

------------------------------------------------------------------------

# 🔎 36. Diagnóstico sistemático

Utiliza siempre este árbol:

``` text
                 CLIENTE SIN IP
                       │
                       ▼
             ¿Interfaz activa?
                 /          \
               NO            SÍ
               │              │
           solucionar         ▼
                         ¿DHCP activo?
                          /        \
                        NO          SÍ
                        │            │
                    revisar          ▼
                              ¿Servidor visible?
                               /           \
                             NO             SÍ
                             │               │
                         relay/VLAN       ▼
                                      ¿Pool válido?
                                       /       \
                                     NO         SÍ
                                     │           │
                                  corregir      ▼
                                           ¿Firewall?
```

------------------------------------------------------------------------

# 📚 37. DHCP y otros servicios

DHCP suele trabajar conjuntamente con:

``` text
        DHCP
         │
    ┌────┼────┐
    │    │    │
   IP   DNS  Gateway
    │    │    │
    └────┼────┘
         │
       RED IP
```

DHCP proporciona información de configuración.

DNS resuelve nombres.

El router proporciona conectividad entre redes.

No deben confundirse las funciones.

------------------------------------------------------------------------

# 🧠 38. Resumen

``` text
                    DHCP
                     │
       ┌─────────────┼─────────────┐
       │             │             │
    CLIENTE       SERVIDOR       RELAY
       │             │             │
       └─────── DORA ──────────────┘
                     │
               CONFIGURACIÓN
                     │
          ┌──────────┼──────────┐
          │          │          │
          IP       GATEWAY      DNS
          │          │          │
          └──────────┼──────────┘
                     │
                  LEASE
                     │
             🔄 RENOVACIÓN
```

Las ideas fundamentales son:

1.  DHCP automatiza la configuración IP.
2.  El servidor administra direcciones y opciones.
3.  Las concesiones tienen duración.
4.  DORA resume la obtención inicial.
5.  DHCP utiliza UDP 67/68 en IPv4.
6.  Los broadcasts no atraviesan routers normalmente.
7.  Un relay permite atender clientes de otras redes.
8.  Las reservas permiten asociar clientes con direcciones concretas.
9.  Un único servidor puede atender varias subredes mediante relay.
10. ISC DHCP es software histórico y está EOL; el laboratorio
    actualizado utiliza Kea.

------------------------------------------------------------------------

# ❓ 39. Autoevaluación

1.  ¿Qué problema principal resuelve DHCP?
2.  ¿Qué parámetros puede recibir un cliente DHCP?
3.  ¿Qué diferencia existe entre una asignación dinámica y una reserva?
4.  ¿Qué es una concesión (*lease*)?
5.  ¿Qué significa DORA?
6.  ¿Qué función cumple DHCPDISCOVER?
7.  ¿Qué función cumple DHCPREQUEST?
8.  ¿Qué puertos UDP utiliza DHCPv4?
9.  ¿Por qué es necesario un DHCP relay cuando cliente y servidor están
    en redes diferentes?
10. ¿Qué función cumple `ip helper-address` en Cisco?
11. ¿Qué información permite al servidor determinar la subred atendida
    por un relay?
12. ¿Qué es un pool DHCP?
13. ¿Para qué sirven las exclusiones?
14. ¿Qué diferencia existe entre una reserva DHCP y una IP estática
    configurada en el cliente?
15. ¿Qué es un DHCP rogue?
16. ¿Qué herramienta permite observar DHCP paquete a paquete?
17. ¿Qué utilidad tiene `journalctl -u kea-dhcp4-server`?
18. ¿Qué software sustituye actualmente a ISC DHCP en el laboratorio?
19. ¿Qué estructura de configuración utiliza Kea DHCPv4 para definir
    subredes?
20. ¿Por qué WSL2 no se utilizará como plataforma principal para una
    topología DHCP de varias LAN?

------------------------------------------------------------------------

# ✅ Solucionario de la autoevaluación

> 📌 Intenta responder primero sin consultar esta sección.

### 1. ¿Qué problema principal resuelve DHCP?

Automatiza la entrega de parámetros de configuración de red a los
clientes, reduciendo la configuración manual y los errores asociados.

### 2. ¿Qué parámetros puede recibir un cliente DHCP?

Como mínimo, una dirección IP y su máscara; habitualmente también
gateway, servidores DNS y otros parámetros mediante opciones DHCP.

### 3. ¿Qué diferencia existe entre asignación dinámica y reserva?

En la asignación dinámica se selecciona una dirección disponible de un
pool durante una concesión. En una reserva, el servidor asocia un
cliente determinado con una dirección concreta.

### 4. ¿Qué es una concesión?

Es el periodo durante el cual un cliente puede utilizar una
configuración asignada por DHCP.

### 5. ¿Qué significa DORA?

``` text
D = DHCPDISCOVER
O = DHCPOFFER
R = DHCPREQUEST
A = DHCPACK
```

Es la secuencia clásica de obtención inicial de una concesión DHCPv4.

### 6. ¿Qué función cumple DHCPDISCOVER?

Permite al cliente localizar servidores DHCP disponibles.

### 7. ¿Qué función cumple DHCPREQUEST?

Permite al cliente solicitar formalmente una configuración/oferta y
comunicar la selección de servidor en el proceso correspondiente.

### 8. ¿Qué puertos UDP utiliza DHCPv4?

**UDP 67** en el servidor y **UDP 68** en el cliente.

### 9. ¿Por qué es necesario DHCP relay entre redes diferentes?

Porque las peticiones iniciales DHCP utilizan difusión y los routers no
reenvían normalmente esos broadcasts entre redes. El relay recibe la
petición y la reenvía al servidor DHCP.

### 10. ¿Qué función cumple `ip helper-address`?

Configura en Cisco el destino al que se reenvían determinadas difusiones
UDP, incluidas las peticiones DHCP. citeturn3search0

### 11. ¿Qué información permite determinar la subred?

En un escenario con relay Cisco, el campo **giaddr** permite al servidor
identificar la red desde la que procede la petición y seleccionar el
ámbito correspondiente. citeturn3search1

### 12. ¿Qué es un pool DHCP?

Es un conjunto de direcciones disponibles para asignación dinámica a los
clientes.

### 13. ¿Para qué sirven las exclusiones?

Para impedir que determinadas direcciones sean asignadas dinámicamente,
normalmente porque están reservadas para infraestructura o dispositivos
con direccionamiento controlado.

### 14. ¿Reserva DHCP o IP estática?

En una reserva el cliente sigue utilizando DHCP y el servidor decide qué
dirección asignarle. Con una IP estática, el parámetro se configura
directamente en el cliente y no depende de una concesión DHCP.

### 15. ¿Qué es un DHCP rogue?

Un servidor DHCP no autorizado que responde a clientes y puede
proporcionar parámetros de red incorrectos o maliciosos.

### 16. ¿Qué herramienta permite observar DHCP paquete a paquete?

**Wireshark**.

### 17. ¿Qué utilidad tiene `journalctl -u kea-dhcp4-server`?

Permite consultar los registros del servicio Kea DHCPv4 gestionado por
systemd y utilizarlos para diagnosticar errores.

### 18. ¿Qué software sustituye actualmente a ISC DHCP?

**Kea DHCP**. ISC declaró ISC DHCP EOL en 2022 y recomienda migrar a
Kea. citeturn0search0turn0search2

### 19. ¿Qué estructura utiliza Kea DHCPv4 para definir subredes?

La estructura `subnet4`, que contiene las subredes DHCPv4 y puede
incluir `pools` y opciones asociadas. citeturn2search2

### 20. ¿Por qué WSL2 no es la plataforma principal para una topología DHCP de

varias LAN?

Porque WSL2 proporciona un entorno Linux integrado con una arquitectura
de red propia; para estudiar varias LAN, routers, relay e interfaces
virtuales independientes resulta más controlable utilizar Packet Tracer
o máquinas virtuales con VirtualBox.

------------------------------------------------------------------------

# 🏆 40. Reto final --- Diseña una infraestructura DHCP

Construye una infraestructura con:

``` text
                  INTERNET
                     │
                ┌────┴────┐
                │ ROUTER  │
                └────┬────┘
                     │
             ┌───────┴────────┐
             │                │
          LAN-A             LAN-B
     192.168.10.0/24    192.168.20.0/24
             │                │
             └───────┬────────┘
                     │
                  RELAY
                     │
                     ▼
             DHCP SERVER
       VirtualBox + Ubuntu 26.04 Server
                     │
                    KEA
```

## Requisitos

El servidor deberá:

-   Atender las dos redes.
-   Entregar IP dinámica.
-   Proporcionar gateway.
-   Proporcionar DNS.
-   Tener al menos una reserva.
-   Mantener concesiones.
-   Registrar actividad.
-   Permitir analizar el proceso mediante Wireshark.

## Evidencias

Entrega:

1.  Diagrama de red.
2.  Configuración del servidor.
3.  Configuración del relay.
4.  Captura de `DORA`.
5.  Captura de una concesión.
6.  Captura de una renovación.
7.  Evidencia de la reserva.
8.  Tabla de direccionamiento.
9.  Diagnóstico de un fallo provocado por el profesor.

------------------------------------------------------------------------

# 🧩 41. Correspondencia con el capítulo original

  -----------------------------------------------------------------------
  Material original                   Versión actualizada
  ----------------------------------- -----------------------------------
  DHCP y configuración automática     DHCP y configuración automática

  Servidor/cliente DHCP               Servidor/cliente DHCP

  Asignaciones                        Asignaciones y reservas

  Ámbitos y rangos                    Subredes y pools

  Exclusiones                         Exclusiones/diseño de pools

  Reservas                            Host reservations

  Lease time                          Lease time

  Mensajes DHCP                       DORA + análisis Wireshark

  Varios servidores                   Redundancia y HA

  DHCP relay                          Cisco relay + `ip helper-address`

  DHCP Failover                       HA moderno + concepto de
                                      redundancia

  ISC DHCP                            **Kea DHCP**

  Windows Server 2008                 **Packet Tracer / Ubuntu 26.04
                                      Server**

  Debian + `dhcpd`                    **VirtualBox + Ubuntu 26.04
                                      Server + Kea**

  Zentyal                             Se conserva el concepto, se
                                      sustituye por plataformas actuales

  Wireshark                           Wireshark

  BOOTP                               Se mantiene como antecedente
                                      histórico
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 📚 42. Referencias y actualización técnica

### Fuente principal

-   *Servicios de Red e Internet*, capítulo 2: **Servicios de
    configuración automática de red (DHCP)**, manual proporcionado por
    el departamento. El capítulo original cubre DHCP, asignaciones,
    concesiones, clientes, servidores, mensajes, relay, failover,
    seguridad y prácticas. fileciteturn4file0L15-L24 Las prácticas
    originales incluyen Windows Server, Linux, failover, Wireshark,
    relay y Zentyal. fileciteturn6file0L14-L23
    fileciteturn7file0L14-L17

### Actualización técnica

-   **ISC --- ISC DHCP:** ISC declaró ISC DHCP *End of Life* en 2022 y
    recomienda Kea para nuevas implantaciones.
    citeturn0search0turn0search3
-   **ISC --- Kea DHCP:** Kea es la implementación moderna de ISC para
    DHCPv4 y DHCPv6 y admite reservas, distintos backends y mecanismos
    de alta disponibilidad. citeturn0search2
-   **Ubuntu:** Ubuntu 26.04 LTS proporciona `kea-dhcp4-server` 3.0.3.
    citeturn1search0
-   **Kea DHCPv4:** la configuración se organiza mediante `Dhcp4`,
    `interfaces-config`, `lease-database`, `subnet4`, `pools` y
    opciones. citeturn2search2
-   **Cisco:** `ip helper-address` permite reenviar broadcasts UDP,
    incluidos DHCP, hacia un servidor DHCP remoto. citeturn3search0

> 🔄 **Criterio de actualización**
>
> Se conserva la estructura conceptual del capítulo original, pero se
> sustituyen las tecnologías obsoletas de las prácticas por herramientas
> actuales. La diferencia más importante es la sustitución de **ISC DHCP
> por Kea DHCP**: no se trata de cambiar únicamente nombres de paquetes,
> sino de adaptar también el modelo de configuración.

------------------------------------------------------------------------

## 🧭 Resultado esperado

Al terminar esta UT, el alumno debería poder responder a esta pregunta:

> **«Un equipo se conecta a una red y no tiene dirección IP. ¿Qué ocurre
> exactamente desde que comienza a solicitar configuración hasta que
> obtiene una concesión, y cómo demostrarías dónde está el problema si
> falla?»**

Si puede responderla **teóricamente, con comandos y observando los
paquetes**, la unidad se ha comprendido.


---

# 🐳 Laboratorio Docker Compose · Anexo IV

La configuración Kea de esta UT está disponible en [`docker/ut2`](docker/ut2/). Docker se utiliza para validar el fichero real de configuración; el intercambio DHCP broadcast se practica en una LAN/Packet Tracer o VM adecuada.

```bash
cd docker/ut2
docker compose build
docker compose run --rm kea-config
```

La comprobación equivalente a la práctica tradicional es `kea-dhcp4 -t /etc/kea/kea-dhcp4.conf`.
