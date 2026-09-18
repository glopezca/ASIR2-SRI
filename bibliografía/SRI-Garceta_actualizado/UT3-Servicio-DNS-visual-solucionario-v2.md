
> 🔬 **VERSIÓN V2 · REVISIÓN TÉCNICA 2026-09-18**
>
> Se ha realizado una segunda pasada sobre los bloques de código y las configuraciones prácticas. Revisados BIND9, zonas directa/inversa y comandos `named-checkconf`/`named-checkzone`; no se detectaron errores de sintaxis en los bloques ejecutables.
>
> ⚠️ La validación automática cubre sintaxis y configuraciones aisladas; la validación extremo a extremo > de Cisco Packet Tracer, WSL2 y una VM real de Ubuntu 26.04 Server requiere ejecutar el laboratorio en esos entornos.

::: {align="center"}
# 🌐⚡ UT3 · SERVICIO DE NOMBRES DE DOMINIO (DNS) ⚡🌐

### 🧭 De una dirección IP a un nombre... y del nombre a la dirección

``` text
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║       🌐 DNS · NOMBRES · ZONAS · REGISTROS · RESOLUCIÓN         ║
║                                                                  ║
║    🔎 RECURSIVO   🔁 ITERATIVO   🗂️ BIND9   🛡️ DNSSEC          ║
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
> Comprender cómo funciona el sistema DNS desde el cliente hasta los
> servidores autoritativos, y ser capaz de **instalar, configurar,
> consultar, verificar y diagnosticar** un servicio DNS utilizando BIND9
> y herramientas de consulta como `dig`, `host` y `nslookup`.

> 💡 **Idea central**
>
> DNS no es simplemente «traducir nombres a IP». Es una **base de datos
> distribuida y jerárquica**, organizada en zonas y administrada
> mediante servidores que pueden desempeñar diferentes funciones:
> autoritativas, secundarias, caché y reenviadoras.

------------------------------------------------------------------------

# 🧭 Mapa de la unidad

``` text
                              🌐 DNS
                               │
              ┌────────────────┼─────────────────┐
              │                │                 │
          🏷️ NOMBRES        🗂️ ZONAS          📦 REGISTROS
              │                │                 │
              │          ┌─────┴─────┐      ┌────┼────┐
              │          │           │      │    │    │
              │       DIRECTA     INVERSA   A    AAAA MX
              │
              └──────────────┬────────────────────┘
                             │
                         🔎 RESOLUCIÓN
                             │
                 ┌───────────┴───────────┐
                 │                       │
             RECURSIVA                 ITERATIVA
                 │                       │
                 └───────────┬───────────┘
                             │
                       🖥️ SERVIDORES
                             │
             ┌───────────────┼────────────────┐
             │               │                │
          PRIMARIO        SECUNDARIO       CACHÉ
             │               │                │
             └───────────────┼────────────────┘
                             │
                         🛡️ SEGURIDAD
                             │
                   DNSSEC · TSIG · TKEY
```

------------------------------------------------------------------------

# 🎯 0. Objetivos

Al finalizar esta unidad deberás ser capaz de:

-   Explicar qué problema resuelve DNS.
-   Comprender el espacio jerárquico de nombres.
-   Diferenciar nombre relativo, nombre absoluto y FQDN.
-   Distinguir dominio, zona y subdominio.
-   Comprender la función de los servidores raíz y los TLD.
-   Explicar la delegación de dominios.
-   Diferenciar servidores primarios, secundarios, caché y reenviadores.
-   Comprender las consultas recursivas e iterativas.
-   Explicar el funcionamiento de la caché y el TTL.
-   Resolver nombres en sentido directo e inverso.
-   Interpretar registros `SOA`, `NS`, `A`, `AAAA`, `CNAME`, `MX`, `SRV`
    y `PTR`.
-   Configurar zonas DNS en BIND9.
-   Validar configuraciones mediante `named-checkconf` y
    `named-checkzone`.
-   Utilizar `dig`, `host` y `nslookup`.
-   Configurar transferencia de zonas entre servidores.
-   Comprender DNS dinámico.
-   Conocer las amenazas principales contra DNS.
-   Introducir mecanismos de seguridad como DNSSEC y TSIG.

------------------------------------------------------------------------

# 🚀 1. ¿Por qué necesitamos DNS?

Los dispositivos trabajan con direcciones IP, pero las personas
utilizamos nombres.

Recordar:

``` text
142.250.x.x
151.101.x.x
...
```

es mucho menos práctico que utilizar:

``` text
www.google.com
www.ubuntu.com
www.ejemplo.es
```

DNS proporciona un espacio de nombres que permite asociar nombres con
información de red.

``` text
              👤 Usuario
                  │
                  │ www.ejemplo.es
                  ▼
              🔎 RESOLVER
                  │
                  │ consulta DNS
                  ▼
             🖥️ SERVIDOR DNS
                  │
                  │ respuesta
                  ▼
             192.168.10.20
```

------------------------------------------------------------------------

# 🧱 2. DNS es una base de datos distribuida

No existe un único servidor que contenga todos los nombres de Internet.

La información está distribuida entre numerosos servidores y organizada
jerárquicamente.

ICANN describe el DNS como una jerarquía que comienza en la raíz y se
estructura mediante delegaciones hacia los dominios de nivel superior.
citeturn0search1turn0search2

``` text
                         .
                         │
             ┌───────────┼───────────┐
             │           │           │
            com         org         es
             │                       │
           google                   red
             │                       │
            www                    www
```

La raíz contiene información de referencia hacia los TLD; no contiene
todos los registros de todos los dominios finales. citeturn0search8

------------------------------------------------------------------------

# 🌳 3. Espacio de nombres de dominio

El DNS utiliza una estructura jerárquica.

Ejemplo:

``` text
www.sri.iesburgos.es.
│   │   │       │
│   │   │       └── TLD
│   │   └────────── dominio
│   └────────────── subdominio
└────────────────── host
```

Cada nivel está separado mediante un punto.

El árbol completo tiene como raíz:

``` text
.
```

Por eso un FQDN completo puede terminar conceptualmente en punto:

``` text
www.sri.iesburgos.es.
                    ↑
                  raíz
```

------------------------------------------------------------------------

# 🏷️ 4. Dominios de primer nivel --- TLD

Los TLD (*Top-Level Domains*) aparecen inmediatamente bajo la raíz.

### Genéricos

``` text
.com
.org
.net
.info
```

### Geográficos

``` text
.es
.fr
.pt
.de
```

Existen además otras categorías y dominios especializados.

> 🧠 **Importante**
>
> El TLD no es simplemente «la última palabra». Es un nivel concreto
> dentro de la jerarquía DNS.

------------------------------------------------------------------------

# 📛 5. Nombre relativo, absoluto y FQDN

Supongamos:

``` text
www.asir.example.
```

Un nombre **absoluto** especifica completamente su posición en el árbol.

Un **FQDN** (*Fully Qualified Domain Name*) identifica un nombre
completo dentro del espacio DNS.

``` text
www.asir.example.
└───────┬────────┘
       FQDN
```

El punto final representa la raíz.

### Ejemplo

``` text
www
 └── asir
      └── example
            └── .
```

------------------------------------------------------------------------

# 🧩 6. Dominio, subdominio y zona

Estos conceptos no deben confundirse.

### Dominio

Es una parte del espacio de nombres.

### Subdominio

Es un dominio situado por debajo de otro.

``` text
example.es
└── asir.example.es
    └── aula.asir.example.es
```

### Zona

Es una **parte del espacio DNS administrada por una entidad o servidor
autoritativo**.

Un dominio puede contener una o varias zonas cuando se realizan
delegaciones.

> ⚠️ **Dominio ≠ zona**
>
> Una zona es una unidad administrativa de datos DNS, no simplemente una
> cadena de caracteres del nombre.

------------------------------------------------------------------------

# 🏛️ 7. Delegación

La delegación permite transferir la autoridad administrativa de una
parte del espacio de nombres a otros servidores.

Ejemplo:

``` text
              example.es
                  │
                  │ delegación
                  ▼
          ┌─────────────────┐
          │ asir.example.es│
          └─────────────────┘
                  │
            DNS propio
```

La zona padre mantiene información que permite encontrar los servidores
autoritativos de la zona hija.

La delegación es un elemento fundamental de la arquitectura DNS
jerárquica. citeturn0search2

------------------------------------------------------------------------

# 🌐 8. Servidores raíz

Los servidores raíz proporcionan referencias hacia los servidores de los
TLD.

Actualmente existen **13 identidades de servidores raíz**, operadas por
distintos operadores, que se sirven mediante una infraestructura global
de más de 1500 instancias. citeturn0search6turn0search8

``` text
CLIENTE
   │
   ▼
RESOLVER
   │
   ▼
ROOT ─────────► .es
                  │
                  ▼
                .es DNS
                  │
                  ▼
             example.es
                  │
                  ▼
             www.example.es
```

> 💡 No hay que imaginar los root servers como «el servidor DNS de
> Internet». Su función principal es proporcionar referencias en la raíz
> de la jerarquía.

------------------------------------------------------------------------

# 🔎 9. Resolución de nombres

Resolver un nombre significa obtener la información DNS asociada.

Ejemplo:

``` text
www.example.es
       │
       ▼
    ¿qué IP?
       │
       ▼
192.0.2.20
```

La resolución puede ser:

-   directa,
-   inversa.

Y las consultas pueden realizarse:

-   recursivamente,
-   iterativamente.

------------------------------------------------------------------------

# 🔄 10. Resolución recursiva

En una consulta recursiva, el servidor al que pregunta el cliente asume
la responsabilidad de obtener una respuesta completa o un error.

``` text
CLIENTE
   │
   │ www.example.es ?
   ▼
DNS RECURSOR
   │
   ├──► ROOT
   │
   ├──► .es
   │
   ├──► example.es
   │
   └──► respuesta
            │
            ▼
        CLIENTE
```

El cliente no necesita realizar cada consulta intermedia.

------------------------------------------------------------------------

# 🔁 11. Resolución iterativa

En una consulta iterativa el servidor responde con la mejor información
que tiene, pudiendo proporcionar una referencia a otro servidor.

``` text
Resolver ──► Root
              │
              └──► servidores .es

Resolver ──► .es
              │
              └──► NS de example.es

Resolver ──► example.es
              │
              └──► respuesta
```

El proceso recursivo completo puede estar compuesto internamente por
varias consultas iterativas.

------------------------------------------------------------------------

# 🧠 12. Recursividad vs. iteración

  Característica                           Recursiva            Iterativa
  ---------------------------------------- -------------------- ------------------------------
  El servidor debe resolver por nosotros   Sí                   No necesariamente
  Puede devolver una referencia            Sí, internamente     Sí
  Carga del servidor                       Mayor                Menor
  Uso típico                               Cliente → resolver   Resolver → DNS autoritativos

### Analiza con `dig`

``` bash
dig www.example.com
```

Consulta un resolver.

Para observar el proceso:

``` bash
dig +trace www.example.com
```

`dig` es una herramienta específica para interrogar servidores DNS y es
una de las herramientas habituales de diagnóstico de DNS.
citeturn1search0

------------------------------------------------------------------------

# 🗃️ 13. Zonas DNS

Un servidor autoritativo almacena información de una o más zonas.

En BIND9, Ubuntu organiza habitualmente la configuración bajo:

``` text
/etc/bind/
```

Incluyendo:

``` text
named.conf
named.conf.options
named.conf.local
named.conf.default-zones
```

Ubuntu documenta esta estructura para BIND9. citeturn0search5

------------------------------------------------------------------------

# 🖥️ 14. Tipos de servidores DNS

Un mismo servidor puede desempeñar varias funciones dependiendo de la
configuración.

## 14.1. Primario

Mantiene los datos de una zona de forma autoritativa.

En BIND9 actual se utiliza el término **primary** en la configuración de
zonas.

## 14.2. Secundario

Obtiene una copia de la zona desde otro servidor autoritativo mediante
transferencias de zona.

## 14.3. Caché

Almacena temporalmente respuestas para evitar repetir consultas.

## 14.4. Reenviador

Envía consultas a otros servidores DNS.

``` text
             BIND9
               │
       ┌───────┼────────┐
       │       │        │
   primary  secondary  cache
                       │
                    forwarder
```

Ubuntu documenta que BIND9 puede funcionar simultáneamente como caché,
primary y secondary dependiendo de las zonas que sirva.
citeturn0search5

------------------------------------------------------------------------

# 🧾 15. Registros de recursos --- RR

La información DNS se almacena mediante **Resource Records (RR)**.

Formato conceptual:

``` text
NOMBRE   TTL   CLASE   TIPO   DATOS
```

Ejemplo:

``` text
www.example.es.   3600   IN   A   192.0.2.10
```

BIND9 utiliza registros de recursos para describir las características
de una zona. citeturn1search2

------------------------------------------------------------------------

# 🟦 16. Registro A

Asocia un nombre con una dirección IPv4.

``` text
www.example.es.   IN   A   192.0.2.10
```

``` text
www.example.es
       │
       ▼
  192.0.2.10
```

Consulta:

``` bash
dig www.example.es A
```

------------------------------------------------------------------------

# 🟪 17. Registro AAAA

Asocia un nombre con una dirección IPv6.

``` text
www.example.es.   IN   AAAA   2001:db8::10
```

Consulta:

``` bash
dig www.example.es AAAA
```

------------------------------------------------------------------------

# 🟨 18. Registro CNAME

Crea un alias para otro nombre.

``` text
web.example.es.   IN   CNAME   www.example.es.
```

``` text
web
 │
 └──── CNAME ───► www
                    │
                    └── A ──► 192.0.2.10
```

> ⚠️ Un CNAME apunta a un **nombre**, no directamente a una dirección
> IP.

------------------------------------------------------------------------

# 🟥 19. Registro MX

Indica qué servidores reciben correo para un dominio.

``` text
example.es.   IN   MX   10   mail.example.es.
```

El número es la **preferencia**: un valor menor tiene prioridad sobre
uno mayor.

Ejemplo:

``` text
MX 10 mail1.example.es.
MX 20 mail2.example.es.
```

------------------------------------------------------------------------

# 🟩 20. Registro NS

Indica los servidores de nombres autoritativos de una zona.

``` text
example.es.   IN   NS   ns1.example.es.
example.es.   IN   NS   ns2.example.es.
```

Una zona debería contar con servidores autoritativos adecuadamente
configurados.

------------------------------------------------------------------------

# 🟧 21. Registro PTR

Se utiliza en la resolución inversa.

``` text
10.2.0.192.in-addr.arpa.
             │
             ▼
        www.example.es.
```

Consulta:

``` bash
dig -x 192.0.2.10
```

------------------------------------------------------------------------

# 🟦 22. Registro SOA

El registro **SOA (Start of Authority)** contiene información
fundamental sobre una zona.

Ejemplo conceptual:

``` text
example.es. IN SOA ns1.example.es. hostmaster.example.es. (
    2026091701
    3600
    600
    604800
    300
)
```

Incluye valores como:

-   servidor primario,
-   contacto administrativo,
-   número de serie,
-   refresh,
-   retry,
-   expire,
-   TTL negativo.

------------------------------------------------------------------------

# 🔢 23. Número de serie del SOA

El `serial` permite detectar cambios en la zona.

Ejemplo:

``` text
2026091701
```

Al modificar la zona:

``` text
2026091702
```

Los servidores secundarios pueden utilizar este valor para determinar si
deben actualizar su copia.

> 🧠 **Regla práctica**
>
> Cada modificación relevante de una zona debe acompañarse de una
> actualización coherente del número de serie.

------------------------------------------------------------------------

# ⏱️ 24. TTL

**TTL --- Time To Live** determina durante cuánto tiempo una respuesta
puede permanecer en caché.

``` text
Consulta
   │
   ▼
Respuesta
   │
   ├── TTL 3600
   │
   ▼
Caché durante un máximo aproximado de 3600 s
```

Un TTL bajo permite cambios más rápidos, pero puede aumentar las
consultas.

Un TTL alto reduce consultas, pero prolonga la permanencia de
información en caché.

------------------------------------------------------------------------

# 🔄 25. TTL positivo y negativo

No solo se almacenan respuestas positivas.

También puede almacenarse información sobre nombres que no existen.

``` text
www.example.es  ──► existe ──► A
noexiste.es      ──► NXDOMAIN
```

El TTL negativo controla durante cuánto tiempo puede mantenerse en caché
determinada información negativa.

------------------------------------------------------------------------

# 🗂️ 26. Resolución inversa

La resolución directa:

``` text
NOMBRE ─────► IP
```

La resolución inversa:

``` text
IP ──────────► NOMBRE
```

Para IPv4 se utiliza:

``` text
in-addr.arpa
```

Ejemplo:

``` text
192.0.2.10

10.2.0.192.in-addr.arpa
```

Consulta:

``` bash
dig -x 192.0.2.10
```

------------------------------------------------------------------------

# 🧩 27. Zonas directas e inversas

Una configuración completa puede tener:

``` text
Zona directa
example.es
     │
     └── www → 192.0.2.10


Zona inversa
2.0.192.in-addr.arpa
     │
     └── 10 → www.example.es
```

Ambas zonas son independientes y deben configurarse correctamente.

------------------------------------------------------------------------

# 🖥️ 28. Cliente DNS --- Resolver

Las aplicaciones normalmente no consultan directamente todos los
servidores DNS de Internet.

Utilizan un **resolver** proporcionado por el sistema operativo o por
una biblioteca.

En Linux moderno pueden intervenir:

``` text
Aplicación
    │
    ▼
Resolver
    │
    ▼
Configuración DNS del sistema
    │
    ▼
Servidor DNS
```

Herramientas útiles:

``` bash
resolvectl status
resolvectl query www.example.com
```

------------------------------------------------------------------------

# 🔍 29. `dig`

`dig` proporciona información detallada sobre las consultas.

``` bash
dig www.example.com
```

Especificar servidor:

``` bash
dig @192.168.10.10 www.example.com
```

Tipo concreto:

``` bash
dig @192.168.10.10 www.example.com MX
```

Respuesta corta:

``` bash
dig +short www.example.com
```

Resolución inversa:

``` bash
dig -x 192.168.10.10
```

Traza:

``` bash
dig +trace www.example.com
```

------------------------------------------------------------------------

# 🔎 30. `host`

Herramienta sencilla para consultas rápidas.

``` bash
host www.example.com
```

Consulta inversa:

``` bash
host 192.168.10.10
```

Consultar un servidor concreto:

``` bash
host www.example.com 192.168.10.10
```

------------------------------------------------------------------------

# 🧰 31. `nslookup`

Aunque `dig` suele ser preferible para diagnóstico detallado, `nslookup`
continúa siendo útil para consultas rápidas y para comparar el
comportamiento entre plataformas.

``` bash
nslookup www.example.com
```

Modo interactivo:

``` text
> server 192.168.10.10
> set type=MX
> example.com
```

------------------------------------------------------------------------

# 🧪 32. PRÁCTICA 1 --- Explorar DNS desde WSL2

## Objetivo

Observar el funcionamiento del resolver del sistema.

Ejecuta:

``` bash
resolvectl status
```

Después:

``` bash
dig www.example.com
```

``` bash
dig +short www.example.com
```

``` bash
dig www.example.com NS
```

``` bash
dig www.example.com MX
```

``` bash
dig -x 8.8.8.8
```

Y finalmente:

``` bash
dig +trace www.example.com
```

### Entrega

Una tabla:

  Consulta            Servidor utilizado   Tipo     Resultado
  ------------------- -------------------- -------- -----------
  `www.example.com`                        A/AAAA   
  `example.com NS`                         NS       
  `example.com MX`                         MX       
  `8.8.8.8`                                PTR      

------------------------------------------------------------------------

# 🧪 33. PRÁCTICA 2 --- Instalar BIND9 en VirtualBox + Ubuntu 26.04 Server

## Topología

``` text
               VirtualBox
                    │
          ┌─────────┴─────────┐
          │                   │
       🖥️ DNS01             💻 CLIENTE
       192.168.10.10        DHCP/estática
          │                   │
          └──── SRI-DNS ──────┘
```

Ubuntu documenta BIND9 como servidor DNS y mantiene su configuración
bajo `/etc/bind`. citeturn0search5

Instalación:

``` bash
sudo apt update
sudo apt install bind9 bind9-utils bind9-dnsutils
```

Comprobar:

``` bash
systemctl status bind9
```

Versión:

``` bash
named -v
```

En Ubuntu 26.04 LTS el paquete `bind9` pertenece a la rama BIND 9.20.24
en los repositorios publicados para `resolute`.
citeturn1search3turn1search13

------------------------------------------------------------------------

# 🧪 34. PRÁCTICA 3 --- Servidor DNS caché/reenviador

## Objetivo

Configurar BIND9 para proporcionar resolución a una LAN y utilizar
*forwarders* para las consultas externas.

Archivo:

``` text
/etc/bind/named.conf.options
```

Estructura conceptual:

``` text
options {
    directory "/var/cache/bind";

    recursion yes;

    forwarders {
        1.1.1.1;
        8.8.8.8;
    };
};
```

> ⚠️ En una red real los forwarders deben elegirse según las políticas y
> requisitos de la organización. Los valores anteriores son únicamente
> un ejemplo de laboratorio.

Ubuntu documenta el uso de `forwarders` en BIND9 para un servidor caché.
citeturn0search5

### Verificación

``` bash
dig @127.0.0.1 www.example.com
```

Repite la consulta y compara:

``` text
;; Query time:
```

El almacenamiento en caché puede reducir el tiempo necesario para
resolver consultas repetidas.

------------------------------------------------------------------------

# 🧪 35. PRÁCTICA 4 --- Crear una zona autoritativa

Dominio de laboratorio:

``` text
asir.test
```

Servidor:

``` text
dns01.asir.test
192.168.10.10
```

Edita:

``` bash
sudo nano /etc/bind/named.conf.local
```

Añade:

``` text
zone "asir.test" {
    type primary;
    file "/etc/bind/db.asir.test";
};
```

Crea:

``` bash
sudo nano /etc/bind/db.asir.test
```

Ejemplo:

``` text
$TTL 3600
@   IN SOA dns01.asir.test. admin.asir.test. (
        2026091701
        3600
        600
        604800
        300
)

    IN NS dns01.asir.test.

dns01   IN A 192.168.10.10
www     IN A 192.168.10.20
mail    IN A 192.168.10.30
```

------------------------------------------------------------------------

# 🔎 36. Validar una zona

Primero:

``` bash
sudo named-checkconf
```

Después:

``` bash
sudo named-checkzone asir.test /etc/bind/db.asir.test
```

`named-checkconf` comprueba la sintaxis de la configuración de `named`,
pero no sustituye a la comprobación de las zonas. `named-checkzone`
comprueba la sintaxis e integridad de un fichero de zona antes de
cargarlo. citeturn0search9turn1search0

Finalmente:

``` bash
sudo systemctl restart bind9
```

Y consulta:

``` bash
dig @192.168.10.10 www.asir.test
```

------------------------------------------------------------------------

# 🧪 37. PRÁCTICA 5 --- Zona inversa

Para:

``` text
192.168.10.0/24
```

crea:

``` text
10.168.192.in-addr.arpa
```

En:

``` text
/etc/bind/named.conf.local
```

``` text
zone "10.168.192.in-addr.arpa" {
    type primary;
    file "/etc/bind/db.192.168.10";
};
```

Zona:

``` text
$TTL 3600
@ IN SOA dns01.asir.test. admin.asir.test. (
    2026091701
    3600
    600
    604800
    300
)

  IN NS dns01.asir.test.

10 IN PTR dns01.asir.test.
20 IN PTR www.asir.test.
30 IN PTR mail.asir.test.
```

Validar:

``` bash
sudo named-checkzone 10.168.192.in-addr.arpa /etc/bind/db.192.168.10
```

Consultar:

``` bash
dig @192.168.10.10 -x 192.168.10.20
```

------------------------------------------------------------------------

# 🧪 38. PRÁCTICA 6 --- Registros DNS

Amplía la zona `asir.test` con:

### A

``` text
web IN A 192.168.10.20
```

### AAAA

``` text
web IN AAAA 2001:db8:10::20
```

### CNAME

``` text
portal IN CNAME web.asir.test.
```

### MX

``` text
@ IN MX 10 mail.asir.test.
```

### TXT

``` text
@ IN TXT "Laboratorio SRI"
```

### SRV

Como actividad de investigación:

``` text
_servicio._tcp.asir.test.
```

Consulta:

``` bash
dig @192.168.10.10 asir.test ANY
```

> ⚠️ En entornos modernos, `ANY` no debe utilizarse como método general
> para obtener «todos» los registros. Es preferible consultar
> explícitamente el tipo que interesa.

------------------------------------------------------------------------

# 🧪 39. PRÁCTICA 7 --- Servidor secundario y transferencia de zona

## Topología

``` text
             PRIMARY
          192.168.10.10
                │
                │ AXFR/IXFR
                ▼
            SECONDARY
          192.168.10.11
```

El servidor secundario obtiene los datos de la zona desde el primary.

Ubuntu documenta esta función de BIND9: el primary obtiene los datos de
zona desde un fichero local y el secondary obtiene los datos desde otro
servidor autoritativo. citeturn0search5

### Objetivos

-   Configurar primary.
-   Configurar secondary.
-   Permitir transferencia únicamente al secondary.
-   Modificar el serial.
-   Comprobar la actualización.

### Verificación

``` bash
dig @192.168.10.11 www.asir.test
```

Y:

``` bash
dig @192.168.10.11 asir.test SOA
```

Compara el `serial` de ambos servidores.

------------------------------------------------------------------------

# 🔐 40. Transferencias de zona y seguridad

Una transferencia de zona puede proporcionar mucha información sobre la
infraestructura DNS.

Por ello no debe permitirse indiscriminadamente.

``` text
❌ CUALQUIER HOST ──► AXFR ──► DNS

✅ PRIMARY ──► SECONDARY autorizado
```

La política debe restringir las transferencias a servidores autorizados.

Para autenticación puede utilizarse **TSIG**.

------------------------------------------------------------------------

# 🔑 41. TSIG

TSIG permite autenticar comunicaciones entre servidores DNS mediante una
clave compartida.

``` text
PRIMARY                         SECONDARY
   │                                │
   │──── consulta firmada ─────────►│
   │                                │
   │◄── respuesta autenticada ──────│
```

En BIND9, TSIG utiliza claves compartidas para autenticar determinadas
comunicaciones y operaciones. citeturn1search0

### Idea fundamental

``` text
MISMA CLAVE
    │
    ├── Primary
    │
    └── Secondary
```

No se debe incluir una clave TSIG real en un repositorio Git público.

------------------------------------------------------------------------

# 🧪 42. PRÁCTICA 8 --- Transferencia autenticada

Configura:

``` text
DNS01 → primary
DNS02 → secondary
```

Objetivo:

1.  Crear clave TSIG.
2.  Asociarla a la transferencia.
3.  Permitir AXFR/IXFR solo con autenticación.
4.  Intentar una transferencia desde un host no autorizado.
5.  Comprobar que se rechaza.
6.  Comprobar que DNS02 continúa funcionando.

------------------------------------------------------------------------

# 🔄 43. DNS dinámico --- DDNS

DNS dinámico permite modificar registros automáticamente.

Caso típico:

``` text
DHCP
 │
 │ asigna IP
 ▼
CLIENTE
 │
 │ actualización DNS
 ▼
DNS
```

Esto resulta especialmente útil cuando las direcciones cambian con
frecuencia.

Puede utilizarse para integrar DHCP y DNS en determinados entornos.

------------------------------------------------------------------------

# 🧪 44. PRÁCTICA 9 --- DHCP + DNS dinámico

Utilizando la infraestructura de la UT2:

``` text
          DHCP / KEA
              │
              │ IP
              ▼
           CLIENTE
              │
              │ actualización
              ▼
          BIND9 DNS
```

Investiga y documenta:

-   qué componente genera la actualización,
-   cómo se autentica,
-   qué registros se actualizan,
-   cómo se evita que cualquier cliente pueda modificar la zona.

------------------------------------------------------------------------

# 🛡️ 45. DNSSEC

DNSSEC proporciona mecanismos para validar la autenticidad e integridad
de los datos DNS.

Añade registros como:

``` text
DNSKEY
RRSIG
NSEC / NSEC3
DS
```

BIND9 proporciona herramientas y políticas específicas para firmar zonas
y mantener sus claves. citeturn0search3turn0search7

``` text
Zona DNS
   │
   ├── A
   ├── AAAA
   ├── NS
   └── ...
        │
        ▼
     DNSSEC
        │
        ├── DNSKEY
        ├── RRSIG
        └── NSEC/NSEC3
```

> ⚠️ **DNSSEC no cifra las consultas DNS.**
>
> Su objetivo es proporcionar autenticidad e integridad de los datos
> DNS, no confidencialidad del tráfico. citeturn0search13

------------------------------------------------------------------------

# 🧨 46. Amenazas DNS

Entre los problemas de seguridad tratados en el capítulo original se
encuentran:

-   DNS spoofing.
-   Envenenamiento de caché.
-   Transferencias de zona no autorizadas.
-   Modificaciones no autorizadas.
-   Ataques contra servidores DNS.
-   Actualizaciones dinámicas no protegidas.

``` text
                 🚨 ATAQUE
                    │
       ┌────────────┼────────────┐
       │            │            │
     CACHE         ZONA        SERVIDOR
    POISONING    ALTERADA       DoS
```

------------------------------------------------------------------------

# 🔐 47. Buenas prácticas de seguridad

### En un servidor autoritativo

-   Mantener BIND actualizado.
-   Limitar las transferencias de zona.
-   Restringir recursividad cuando no sea necesaria.
-   Separar servidores autoritativos y resolvers cuando el diseño lo
    requiera.
-   Utilizar TSIG para operaciones que lo necesiten.
-   Utilizar DNSSEC cuando corresponda.
-   Revisar logs.
-   Evitar exponer interfaces de administración.
-   Aplicar firewall.

### Principio

``` text
           DNS
            │
      ┌─────┴─────┐
      │           │
 AUTORITATIVO   RECURSOR
      │           │
      ▼           ▼
   zonas        caché
```

------------------------------------------------------------------------

# 🧪 48. PRÁCTICA 10 --- Diagnóstico DNS con Wireshark

Captura tráfico mientras ejecutas:

``` bash
dig www.example.com
```

Filtro:

``` text
dns
```

Analiza:

-   dirección IP origen,
-   destino,
-   puerto UDP 53,
-   consulta,
-   respuesta,
-   tipo de registro,
-   flags,
-   `Transaction ID`,
-   `Answer`,
-   `Authority`,
-   `Additional`.

Después repite:

``` bash
dig +tcp www.example.com
```

Compara UDP y TCP.

------------------------------------------------------------------------

# 🧪 49. PRÁCTICA 11 --- Diagnóstico con `dig`

Realiza:

``` bash
dig @192.168.10.10 www.asir.test A
dig @192.168.10.10 www.asir.test AAAA
dig @192.168.10.10 asir.test NS
dig @192.168.10.10 asir.test SOA
dig @192.168.10.10 asir.test MX
dig @192.168.10.10 -x 192.168.10.20
```

Después:

``` bash
dig +trace www.example.com
```

### Informe

Para cada consulta indica:

-   servidor consultado,
-   tipo,
-   respuesta,
-   autoridad,
-   TTL,
-   tiempo de respuesta.

------------------------------------------------------------------------

# 🩺 50. Diagnóstico sistemático

Cuando DNS falla, no empieces cambiando configuraciones al azar.

``` text
                 ❌ NO RESUELVE
                       │
                       ▼
              ¿Hay conectividad IP?
                  /          \
                NO            SÍ
                │              │
             resolver          ▼
                          ¿Puerto 53?
                           /       \
                         NO         SÍ
                         │           │
                      firewall       ▼
                               ¿Servidor activo?
                                  /       \
                                NO         SÍ
                                │           │
                              systemd       ▼
                                   ¿Zona correcta?
                                      /      \
                                    NO        SÍ
                                    │          │
                                 zona       registros
                                               │
                                               ▼
                                          ¿caché/TTL?
```

------------------------------------------------------------------------

# 🚨 51. Errores frecuentes de BIND9

### ❌ Error de sintaxis

Comprobar:

``` bash
sudo named-checkconf
```

### ❌ Error en una zona

``` bash
sudo named-checkzone asir.test /etc/bind/db.asir.test
```

### ❌ El servicio no arranca

``` bash
systemctl status bind9
journalctl -u bind9
```

### ❌ El servidor responde REFUSED

Comprobar:

-   `allow-query`,
-   `allow-recursion`,
-   configuración de zona,
-   ACL,
-   interfaz de escucha.

### ❌ NXDOMAIN

Puede indicar:

-   nombre inexistente,
-   zona incorrecta,
-   registro ausente,
-   consulta al servidor equivocado.

### ❌ SERVFAIL

Puede indicar un problema más profundo:

-   servidor autoritativo inaccesible,
-   DNSSEC,
-   configuración,
-   dependencia de otro servidor,
-   error en la resolución.

------------------------------------------------------------------------

# 🧪 52. PRÁCTICA 12 --- Reto integral DNS

Construye:

``` text
                         🌐 INTERNET
                              │
                         ┌────┴────┐
                         │ RESOLVER│
                         └────┬────┘
                              │
                 ┌────────────┴────────────┐
                 │                         │
              DNS01                      DNS02
             PRIMARY                   SECONDARY
          192.168.10.10              192.168.10.11
                 │                         │
                 └──────────┬──────────────┘
                            │
                       LAN SRI-DNS
```

## Debe incluir

### Zona directa

``` text
asir.test
```

### Zona inversa

``` text
10.168.192.in-addr.arpa
```

### Registros

-   SOA.
-   NS.
-   A.  
-   AAAA.
-   CNAME.
-   MX. 
-   PTR.

### Servicios

-   Primary.
-   Secondary.
-   Caché/recursividad según diseño.
-   Transferencia de zona.
-   Consultas con `dig`.

### Seguridad

-   Restricción de AXFR.
-   TSIG.
-   Restricción de recursividad.
-   Firewall.

### Evidencias

1.  Configuración.
2.  Validación.
3.  Estado de servicios.
4.  Consulta directa.
5.  Consulta inversa.
6.  Transferencia.
7.  Captura Wireshark.
8.  Diagnóstico de un fallo introducido deliberadamente.

------------------------------------------------------------------------

# 🧠 53. Resumen

``` text
                           DNS
                            │
                ┌───────────┼───────────┐
                │           │           │
             NOMBRES       ZONAS     REGISTROS
                │           │           │
                │       DIRECTA/INV.    │
                │                       │
                └──────────┬────────────┘
                           │
                      RESOLUCIÓN
                           │
                  ┌────────┴────────┐
                  │                 │
              RECURSIVA          ITERATIVA
                  │                 │
                  └────────┬────────┘
                           │
                     SERVIDORES
                           │
            ┌──────────────┼──────────────┐
            │              │              │
         PRIMARY        SECONDARY       CACHÉ
            │              │              │
            └──────────────┼──────────────┘
                           │
                       SEGURIDAD
                           │
                 DNSSEC · TSIG · ACL
```

Ideas fundamentales:

1.  DNS es jerárquico y distribuido.
2.  La raíz delega hacia los TLD.
3.  Los dominios pueden dividirse administrativamente en zonas.
4.  Un servidor puede tener diferentes funciones según la zona.
5.  La resolución puede ser recursiva o iterativa.
6.  Las respuestas se almacenan en caché durante un TTL.
7.  Los registros RR contienen la información DNS.
8.  `A` y `AAAA` proporcionan direcciones.
9.  `NS` identifica servidores autoritativos.
10. `SOA` contiene información fundamental de la zona.
11. `MX` identifica servidores de correo.
12. `CNAME` crea alias.
13. `PTR` participa en resolución inversa.
14. Las transferencias permiten mantener secundarios.
15. TSIG puede autenticar operaciones entre servidores.
16. DNSSEC proporciona autenticidad e integridad de los datos DNS.
17. BIND9 sigue siendo una plataforma adecuada para el laboratorio.
18. `dig`, `host`, `named-checkconf` y `named-checkzone` son
    herramientas fundamentales.

------------------------------------------------------------------------

# ❓ 54. Autoevaluación

1.  Explica brevemente cuál es la función de los componentes del
    servicio DNS.
2.  Dibuja una parte del espacio de nombres de dominio que represente
    parte de los dominios de resolución directa y parte de los dominios
    de resolución inversa.
3.  Enumera tres dominios TLD genéricos y tres TLD geográficos.
4.  Explica qué diferencia existe entre dominio, subdominio y zona.
5.  Explica qué es un FQDN y diferencia nombre relativo y absoluto.
6.  Explica en qué consiste la delegación de un dominio y qué utilidad
    tiene.
7.  Explica la secuencia de consultas DNS que se produce cuando un
    resolver realiza una consulta recursiva para un dominio.
8.  Explica qué diferencia existe entre una consulta recursiva y una
    iterativa.
9.  Explica qué es el caché DNS y qué función desempeña el TTL.
10. Explica qué es la resolución inversa y qué espacio de nombres
    utiliza.
11. Explica qué es una transferencia de zona y diferencia AXFR e IXFR.
12. Explica la utilidad del registro SOA.
13. Explica qué es el envenenamiento de caché DNS y qué mecanismos
    pueden utilizarse para reducir el riesgo.
14. Explica qué es DNSSEC y qué aporta frente al DNS tradicional.

------------------------------------------------------------------------

# ✅ Solucionario de la autoevaluación

> 📌 Primero intenta resolver las cuestiones sin consultar esta sección.

### 1. Componentes del servicio DNS

El sistema DNS está formado, entre otros, por:

-   **Clientes/resolvers**, que generan consultas.
-   **Servidores DNS**, que responden a consultas.
-   **Zonas**, que contienen información autoritativa.
-   **Registros de recursos**, que describen nombres y datos.
-   **Jerarquía DNS**, que permite distribuir la autoridad.

### 2. Espacio de nombres

Ejemplo:

``` text
                    .
                    │
              ┌─────┴─────┐
             com           es
              │            │
           example        asir
              │            │
             www          www
```

Para resolución inversa:

``` text
                in-addr.arpa
                     │
                  192
                     │
                   168
                     │
                    10
                     │
                 host PTR
```

### 3. TLD

Genéricos:

``` text
.com
.org
.net
```

Geográficos:

``` text
.es
.pt
.fr
```

### 4. Dominio, subdominio y zona

Un **dominio** es un nombre dentro del árbol DNS.

Un **subdominio** está situado bajo otro dominio.

Una **zona** es una parte del espacio DNS cuya información es
administrada autoritativamente.

Un dominio puede incluir delegaciones y, por tanto, varias zonas.

### 5. FQDN, nombre relativo y absoluto

Un FQDN identifica completamente un nombre dentro de la jerarquía.

Ejemplo:

``` text
www.asir.example.
```

Un nombre relativo necesita un contexto u origen para interpretarse.

Un nombre absoluto contiene toda la ruta jerárquica hasta la raíz.

### 6. Delegación

La delegación consiste en que una zona padre indica qué servidores son
autoritativos para una zona hija.

Ejemplo:

``` text
example.es
     │
     └──► asir.example.es
              │
              └── DNS propio
```

Permite distribuir la administración del espacio DNS.

### 7. Consulta recursiva

El cliente pregunta a un resolver:

``` text
www.example.com ?
```

El resolver puede consultar:

``` text
ROOT
  ↓
.COM
  ↓
example.com
  ↓
respuesta
```

y devolver al cliente la respuesta final.

### 8. Recursiva vs. iterativa

**Recursiva:** el servidor consultado asume la responsabilidad de
obtener una respuesta completa.

**Iterativa:** el servidor devuelve la información que conoce o una
referencia, y el proceso continúa mediante nuevas consultas.

### 9. Caché y TTL

La caché almacena temporalmente respuestas DNS para evitar consultas
repetidas.

El TTL indica cuánto tiempo puede mantenerse una respuesta en caché.

### 10. Resolución inversa

Es la obtención de un nombre a partir de una dirección IP.

En IPv4 utiliza:

``` text
in-addr.arpa
```

Ejemplo:

``` text
192.168.10.20
      ↓
20.10.168.192.in-addr.arpa
      ↓
www.asir.test
```

### 11. AXFR e IXFR

**AXFR** realiza una transferencia completa de la zona.

**IXFR** permite transferir los cambios realizados desde una versión
anterior, reduciendo el volumen de datos cuando resulta aplicable.

### 12. SOA

El registro SOA contiene información fundamental de la zona:

-   servidor principal,
-   contacto administrativo,
-   serial,
-   refresh,
-   retry,
-   expire,
-   TTL negativo.

### 13. Envenenamiento de caché

Consiste en introducir información DNS falsa en una caché para que los
clientes reciban respuestas manipuladas.

Medidas relacionadas:

-   DNSSEC.
-   Actualizaciones y configuraciones seguras.
-   BIND actualizado.
-   Control de recursividad.
-   Políticas de seguridad.
-   Evitar servidores abiertos innecesariamente.

### 14. DNSSEC

DNSSEC añade mecanismos criptográficos para validar la autenticidad e
integridad de la información DNS.

Utiliza registros como:

``` text
DNSKEY
RRSIG
DS
NSEC/NSEC3
```

No cifra las consultas DNS: su objetivo es validar los datos y proteger
la cadena de confianza. citeturn0search3turn0search13

------------------------------------------------------------------------

# 📝 55. Test de repaso --- respuestas

El capítulo original incluye además un test de 10 preguntas.
fileciteturn16file0L1-L10

### Respuestas

    Nº    Respuesta
  ---- ----------------
     1      **c**
     2      **b**
     3      **b**
     4      **d**
     5      **a**
     6  ⚠️ **Revisar**
     7      **b**
     8      **b**
     9      **a**
    10      **a**

> ⚠️ **Nota sobre la pregunta 6 del material original**
>
> La redacción presenta un problema: las opciones mostradas pueden ser
> compatibles con el funcionamiento normal de servidores DNS que
> desempeñan funciones distintas para diferentes zonas. Por tanto, no se
> identifica una única opción falsa de forma inequívoca. Se recomienda
> **corregir esta pregunta antes de incorporarla a un examen o
> cuestionario Moodle**.

------------------------------------------------------------------------

# 🧪 56. Actividad final --- «¿Dónde está el problema?»

El profesor proporciona:

``` text
Cliente
192.168.10.50

DNS
192.168.10.10

Zona
asir.test
```

El cliente ejecuta:

``` bash
dig @192.168.10.10 www.asir.test
```

y obtiene:

``` text
SERVFAIL
```

### El alumno deberá comprobar, en orden:

``` text
1️⃣ conectividad IP
       ↓
2️⃣ puerto 53
       ↓
3️⃣ servicio bind9
       ↓
4️⃣ named-checkconf
       ↓
5️⃣ named-checkzone
       ↓
6️⃣ SOA
       ↓
7️⃣ NS
       ↓
8️⃣ A
       ↓
9️⃣ logs
       ↓
🔟 captura DNS
```

### Evidencia final

El alumno debe identificar:

-   causa del fallo,
-   comando utilizado para detectarlo,
-   configuración responsable,
-   corrección aplicada,
-   prueba que demuestra que el problema está resuelto.

------------------------------------------------------------------------

# 🔄 57. Correspondencia con el capítulo original

  -----------------------------------------------------------------------
  Capítulo original                   UT3 actualizada
  ----------------------------------- -----------------------------------
  Sistemas de nombres planos y        Jerarquía DNS
  jerárquicos                         

  Historia de DNS                     Arquitectura y evolución

  Características y utilidad          Funciones DNS

  Espacio de nombres                  Árbol, dominios, TLD y FQDN

  ICANN / TLD / registradores         Delegación y administración

  Servidores de nombres               Primary, secondary, cache,
                                      forwarder

  Zonas                               Zonas directas e inversas

  Consultas                           Recursivas e iterativas

  Cache y TTL                         Caché, TTL positivo y negativo

  Resolución inversa                  `in-addr.arpa`

  RR                                  SOA, NS, A, AAAA, CNAME, MX, SRV,
                                      PTR

  Transferencias                      AXFR / IXFR

  DNS dinámico                        DDNS

  Seguridad DNS                       ACL, TSIG, DNSSEC

  Whois                               Se trata como herramienta
                                      histórica/complementaria

  BIND9                               **BIND9 actual en Ubuntu 26.04**

  Windows Server 2008                 Sustituido por VirtualBox + Ubuntu
                                      26.04 Server

  Zentyal                             Eliminado como plataforma principal

  Dnsmasq                             Se mantiene como tecnología
                                      complementaria

  Wireshark                           Análisis de tráfico DNS

  nslookup / host / dig               Herramientas actuales de
                                      diagnóstico
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 📚 58. Referencias técnicas

### Fuente principal

Capítulo 3, **«Servicio de nombres de dominio (DNS)»**, del manual
*Servicios de Red e Internet* proporcionado por el departamento. El
capítulo original cubre jerarquía, dominios, servidores, zonas,
resolución, caché, registros, transferencias, DNS dinámico, seguridad y
numerosas prácticas. fileciteturn7file0L21-L25
fileciteturn10file0L19-L27

### Documentación actual

-   Ubuntu Server --- DNS/BIND9. citeturn0search5
-   Ubuntu 26.04 --- paquete BIND9 9.20.x.
    citeturn1search3turn1search13
-   BIND 9 --- configuración y ficheros de zona. citeturn1search2
-   BIND 9 --- `dig`, `named-checkconf`, `named-checkzone` y `rndc`.
    citeturn1search0
-   BIND 9 --- DNSSEC. citeturn0search3
-   ICANN --- sistema de servidores raíz. citeturn0search8
-   ICANN --- delegación DNS. citeturn0search2

------------------------------------------------------------------------

# 🏆 Resultado esperado

Al finalizar esta UT, el alumno debería poder enfrentarse a una
situación real como:

> **«Un cliente tiene conectividad IP, pero no puede resolver
> `www.asir.test`. ¿Cómo demostrarías si el problema está en el cliente,
> el resolver, BIND9, la zona, el registro, la delegación, la caché o la
> comunicación con otro servidor DNS?»**

La respuesta correcta no debe consistir únicamente en «reiniciar BIND».

Debe poder demostrarse mediante:

``` text
        🔎 dig
          +
      🧰 herramientas
          +
      🗂️ configuración
          +
       📜 logs
          +
      📡 Wireshark
          =
    🧠 DIAGNÓSTICO DNS
```
