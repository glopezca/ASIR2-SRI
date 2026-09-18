<div align="center">

# ✉️⚡ UT6 · LOS SERVICIOS DE CORREO ELECTRÓNICO ⚡✉️

### 📬 Del mensaje al buzón · SMTP · POP3 · IMAP · MIME · TLS · SPAM

```text
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║              ✉️ CORREO ELECTRÓNICO · END-TO-END                ║
║                                                                  ║
║   📨 MUA  →  📤 SMTP  →  🌐 Internet  →  📥 Buzón  →  📬 MUA   ║
║                                                                  ║
║       SMTP 📤       POP3 📥       IMAP 📂       MIME 📎         ║
║                                                                  ║
║    🔐 TLS · 🛡️ seguridad · 🦠 malware · 🗑️ spam · 🧪 análisis  ║
║                                                                  ║
║    Packet Tracer · WSL2 · VirtualBox + Ubuntu 26.04 Server      ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**SERVICIOS DE RED E INTERNET · CFGS ASIR**

**Material docente actualizado · 2026.09**

</div>

> 🔬 **VERSIÓN V2 · REVISIÓN TÉCNICA 2026-09-18**
>
> Se ha realizado una segunda pasada sobre los bloques de código y las configuraciones prácticas. Revisados los bloques Bash y el cliente `neomutt`; no se detectaron errores de sintaxis. La unidad no contiene una configuración de Dovecot que requiera adaptación en esta versión.
>
> ⚠️ La validación automática cubre sintaxis y configuraciones aisladas; la validación extremo a extremo > de Cisco Packet Tracer, WSL2 y una VM real de Ubuntu 26.04 Server requiere ejecutar el laboratorio en esos entornos.


---

> 🎯 **MISIÓN DE LA UT**
>
> Comprender cómo funciona el correo electrónico desde la composición de un
> mensaje hasta su entrega y lectura, identificar los protocolos implicados,
> interpretar el formato de un mensaje, configurar clientes de correo y
> analizar los mecanismos de seguridad, privacidad, malware y spam.
>
> La pregunta profesional es:
>
> **«¿Qué ocurre realmente desde que pulso _Enviar_ hasta que el destinatario
> recibe el mensaje?»**

> 📚 **Base del capítulo**
>
> El libro sitúa esta unidad como **CAPÍTULO 6 — LOS SERVICIOS DE CORREO
> ELECTRÓNICO**, comenzando en la página 179. La estructura original comprende:
>
> - 6.1 Introducción.
> - 6.2 Protocolos involucrados.
> - 6.2.1 Formatos de mensajes.
> - 6.2.2 Transferencia de correo.
> - 6.2.3 Seguridad y privacidad.
> - 6.2.4 Protección frente a virus.
> - 6.2.5 Correo basura (spam).
> - 6.3 Configuración de un cliente de correo.
> - 6.3.1 Configuración en Windows.
> - 6.3.2 Configuración en Linux.
> - Resumen.
> - Ejercicios propuestos.
> - Test de conocimientos.
>
> Esta versión mantiene esa organización conceptual y actualiza la parte
> práctica a **Cisco Packet Tracer**, **WSL2 + Ubuntu 26.04** y
> **VirtualBox + Ubuntu 26.04 Server**.

---

# 🧭 Mapa de la unidad

```text
                         ✉️ CORREO
                            │
              ┌─────────────┼─────────────┐
              │             │             │
            CREAR         ENVIAR        LEER
              │             │             │
             MUA           SMTP       POP3 / IMAP
              │             │             │
              └─────────────┼─────────────┘
                            │
                         INTERNET
                            │
                            ▼
                    ┌──────────────┐
                    │ SERVIDOR MX  │
                    └──────┬───────┘
                           │
                         BUZÓN
                           │
                  ┌────────┴────────┐
                  │                 │
                POP3              IMAP
                  │                 │
                  └────────┬────────┘
                           ▼
                         MUA
```

---

# 🎯 0. Objetivos

Al finalizar esta unidad deberás ser capaz de:

- Explicar qué es el correo electrónico.
- Identificar los elementos de una arquitectura de correo.
- Diferenciar MUA, MTA, MSA y MDA.
- Explicar el funcionamiento básico de SMTP.
- Diferenciar envío, relay y acceso al buzón.
- Diferenciar SMTP, POP3 e IMAP.
- Identificar los puertos habituales de los servicios de correo.
- Comprender el formato de un mensaje.
- Interpretar cabeceras de correo.
- Comprender MIME y los adjuntos.
- Explicar la diferencia entre cabecera y cuerpo.
- Comprender la resolución DNS asociada al correo.
- Interpretar registros MX.
- Comprender TLS en correo.
- Diferenciar STARTTLS de TLS implícito.
- Comprender autenticación SMTP.
- Analizar problemas de privacidad.
- Comprender los mecanismos básicos de filtrado de spam.
- Comprender el papel de los sistemas antivirus/antimalware.
- Configurar un cliente de correo.
- Diagnosticar problemas de conexión.
- Analizar SMTP, POP3 e IMAP desde terminal.
- Observar sesiones mediante herramientas de red.
- Utilizar Packet Tracer para simular un servicio de correo.
- Utilizar WSL2 para probar protocolos de correo.
- Relacionar correo, DNS, TCP/IP y seguridad.

---

# ✉️ 1. Introducción

El correo electrónico es un servicio distribuido.

A diferencia de una comunicación directa entre dos programas, intervienen
habitualmente varios componentes:

```text
USUARIO A
   │
   ▼
MUA
   │
   ▼
MSA / SMTP
   │
   ▼
MTA
   │
   │ Internet
   ▼
MTA destinatario
   │
   ▼
MDA / buzón
   │
   ▼
IMAP / POP3
   │
   ▼
MUA
   │
   ▼
USUARIO B
```

El sistema está diseñado para que el envío y la lectura sean funciones
separadas.

---

# 🧩 2. Componentes de un sistema de correo

## MUA — Mail User Agent

Es el cliente que utiliza el usuario.

Ejemplos:

```text
Thunderbird
Outlook
Apple Mail
Evolution
neomutt
```

Funciones:

- redactar;
- enviar;
- recibir;
- organizar;
- buscar;
- responder;
- reenviar.

---

## MSA — Mail Submission Agent

Recibe mensajes enviados por usuarios o aplicaciones autorizadas y los
introduce en el sistema de correo.

La **sumisión** está separada conceptualmente del relay entre servidores.

El puerto habitual para Message Submission es:

```text
TCP/587
```

RFC 6409 define el servicio de Message Submission y reserva normalmente el
puerto 587 para esta función.

---

## MTA — Mail Transfer Agent

Transfiere correo entre sistemas.

Ejemplos históricos y actuales:

```text
Postfix
Exim
Sendmail
OpenSMTPD
```

Su función principal es:

```text
recibir
   ↓
decidir destino
   ↓
entregar o reenviar
```

---

## MDA — Mail Delivery Agent

Realiza la entrega final al buzón.

Conceptualmente:

```text
MTA
 │
 ▼
MDA
 │
 ▼
MAILBOX
```

---

# 🌐 3. Arquitectura completa

Supongamos:

```text
ana@empresa-a.test
```

envía un correo a:

```text
luis@empresa-b.test
```

Proceso:

```text
ANA
 │
 ▼
MUA
 │
 ▼
SMTP Submission
 │
 ▼
MTA empresa-a
 │
 ▼
DNS → MX empresa-b.test
 │
 ▼
SMTP
 │
 ▼
MTA empresa-b
 │
 ▼
MDA
 │
 ▼
BUZÓN DE LUIS
 │
 ▼
IMAP / POP3
 │
 ▼
MUA
```

> 🧠 **Idea clave**
>
> SMTP se utiliza principalmente para **enviar y transferir** correo.
> POP3 e IMAP se utilizan para **acceder al buzón**.

---

# 🔎 4. Dirección de correo

Una dirección tiene normalmente:

```text
usuario@dominio
```

Ejemplo:

```text
ger@asir.test
```

Separación:

```text
ger
│
└── local-part

@
│
└── separador

asir.test
│
└── dominio
```

El dominio desempeña un papel fundamental en el encaminamiento del correo.

---

# 🌳 5. Correo y DNS

Cuando un servidor necesita entregar correo para:

```text
empresa.test
```

debe determinar qué servidor recibe el correo para ese dominio.

Se consulta DNS:

```text
empresa.test
      │
      ▼
     MX
      │
      ▼
mail.empresa.test
      │
      ▼
     A/AAAA
      │
      ▼
  dirección IP
```

Consulta:

```bash
dig MX empresa.test
```

Consulta detallada:

```bash
dig MX empresa.test +short
```

---

# 📨 6. Registro MX

Un registro MX tiene:

```text
prioridad
     +
nombre del servidor
```

Ejemplo conceptual:

```text
empresa.test.   MX   10   mail1.empresa.test.
empresa.test.   MX   20   mail2.empresa.test.
```

Un valor numérico menor representa mayor prioridad.

```text
10 → preferido
20 → alternativa
```

> ⚠️ Un registro MX no contiene directamente una dirección IP.
>
> El nombre indicado debe resolverse mediante registros A/AAAA.

---

# 📡 7. SMTP

**SMTP — Simple Mail Transfer Protocol** es el protocolo fundamental para la
transferencia de correo.

Modelo:

```text
CLIENTE / MTA
     │
     │ SMTP
     ▼
SERVIDOR
```

SMTP es un protocolo textual basado en comandos y respuestas.

Ejemplo conceptual:

```text
S: 220 mail.example.test
C: EHLO cliente.example.test
S: 250-mail.example.test
S: 250 STARTTLS
C: STARTTLS
S: 220 Ready to start TLS
```

---

# 🔧 8. Comandos SMTP fundamentales

```text
EHLO
HELO
MAIL FROM
RCPT TO
DATA
RSET
NOOP
QUIT
```

Ejemplo:

```text
EHLO cliente.test
MAIL FROM:<ana@empresa-a.test>
RCPT TO:<luis@empresa-b.test>
DATA
From: Ana <ana@empresa-a.test>
To: Luis <luis@empresa-b.test>
Subject: Prueba

Hola Luis.
.
QUIT
```

---

# 🔢 9. Respuestas SMTP

Las respuestas se organizan por familias:

```text
2xx → éxito
3xx → continuación
4xx → error temporal
5xx → error permanente
```

Ejemplos:

```text
220 → servicio preparado
221 → cierre de conexión
250 → acción completada
354 → inicio del contenido del mensaje
421 → servicio no disponible
450 → acción no realizada
550 → buzón/destino no disponible o rechazo
```

---

# 📤 10. SMTP Submission

No debe confundirse:

```text
SMTP relay
```

con:

```text
SMTP submission
```

Arquitectura:

```text
MUA
 │
 │ autenticación
 │
 ▼
MSA
 │
 │ relay
 ▼
MTA
```

El puerto habitual de submission:

```text
587/TCP
```

RFC 6409 separa explícitamente la entrega de mensajes por usuarios del relay
entre MTAs.

---

# 🔐 11. TLS en correo

Un cliente de correo debe proteger normalmente:

```text
credenciales
contenido
cabeceras
```

cuando se comunica con el servidor.

Hay dos mecanismos habituales:

```text
STARTTLS
```

y:

```text
TLS implícito
```

---

# 🔒 12. STARTTLS

La conexión comienza inicialmente como protocolo SMTP/POP3/IMAP y se solicita
el cambio a TLS.

Conceptualmente:

```text
TCP
 │
 ▼
SMTP / IMAP / POP3
 │
 │ STARTTLS
 ▼
TLS
 │
 ▼
protocolo protegido
```

Para SMTP submission:

```text
587/TCP
```

es el puerto habitual asociado a submission y puede utilizar STARTTLS.

---

# 🔐 13. TLS implícito

En TLS implícito:

```text
TCP
 │
 ▼
TLS inmediatamente
 │
 ▼
SMTP / IMAP / POP3
```

Puertos habituales:

```text
SMTP Submission → 465
IMAPS           → 993
POP3S           → 995
```

RFC 8314 recomienda TLS implícito para los servicios de acceso y submission
cuando está disponible y actualizado.

> 🧠 No memorices solo números.
>
> Debes poder explicar qué ocurre sobre la conexión.

---

# 📊 14. Tabla de puertos

| Servicio | Puerto habitual | Función |
|---|---:|---|
| SMTP relay | 25/TCP | Transferencia entre servidores |
| SMTP Submission | 587/TCP | Envío autenticado desde clientes |
| SMTPS | 465/TCP | Submission con TLS implícito |
| POP3 | 110/TCP | Acceso al buzón |
| POP3S | 995/TCP | POP3 con TLS implícito |
| IMAP | 143/TCP | Acceso y gestión del buzón |
| IMAPS | 993/TCP | IMAP con TLS implícito |

> ⚠️ Los puertos no definen por sí solos el nivel de seguridad.
>
> Lo importante es el protocolo y cómo se establece y valida TLS.

---

# 📥 15. POP3

**POP3 — Post Office Protocol version 3** está orientado principalmente a
descargar mensajes.

Modelo tradicional:

```text
SERVIDOR
   │
   │ descargar
   ▼
CLIENTE
```

Puede configurarse para:

```text
descargar y eliminar
```

o:

```text
descargar y conservar copia
```

### Ventaja conceptual

Sencillez.

### Limitación

No está diseñado para mantener una visión remota completa del buzón como IMAP.

---

# 📂 16. IMAP

**IMAP — Internet Message Access Protocol** mantiene el correo en el servidor
y permite trabajar con carpetas y estado remoto.

```text
SERVIDOR
 ├── INBOX
 ├── Sent
 ├── Drafts
 ├── Trash
 └── carpetas
```

El cliente sincroniza:

```text
cliente
   ↕
servidor
```

Es especialmente adecuado cuando:

- se utilizan varios dispositivos;
- se necesita conservar el estado en servidor;
- se gestionan carpetas remotas;
- se requiere sincronización.

---

# ⚖️ 17. POP3 frente a IMAP

| Característica | POP3 | IMAP |
|---|---|---|
| Modelo | Descarga | Acceso/sincronización |
| Mensajes en servidor | Opcional según configuración | Central |
| Carpetas remotas | Limitadas | Sí |
| Estado remoto | Limitado | Sí |
| Varios dispositivos | Menos apropiado | Muy apropiado |
| Puerto seguro habitual | 995 | 993 |

> 🧠 **Regla práctica**
>
> Si quieres que varios dispositivos vean el mismo buzón sincronizado,
> **IMAP** suele encajar mejor.

---

# 📨 18. Formato de un mensaje

Un mensaje de correo no es simplemente:

```text
texto + archivo adjunto
```

Conceptualmente:

```text
┌─────────────────────────────┐
│ HEADERS                     │
├─────────────────────────────┤
│                             │
│ BODY                        │
│                             │
└─────────────────────────────┘
```

Ejemplo:

```text
From: ana@example.test
To: luis@example.test
Date: ...
Subject: Reunión

Hola Luis.

Nos vemos mañana.
```

RFC 5322 define el formato de los mensajes de Internet y establece la
estructura de cabeceras y cuerpo.

---

# 🧾 19. Cabeceras

Cabeceras habituales:

```text
From:
To:
Date:
Subject:
Message-ID:
Reply-To:
Cc:
Bcc:
Received:
Content-Type:
MIME-Version:
```

Ejemplo:

```text
From: Ana <ana@example.test>
To: Luis <luis@example.test>
Subject: Prueba
Message-ID: <12345@example.test>
```

---

# 🕵️ 20. La cabecera Received

Una de las cabeceras más útiles para diagnóstico es:

```text
Received:
```

Un mensaje puede contener varias:

```text
Received: by servidor-3
Received: by servidor-2
Received: by servidor-1
```

Cada salto puede añadir información.

Conceptualmente:

```text
ORIGEN
  │
  ▼
MTA 1
  │
  ▼
MTA 2
  │
  ▼
MTA 3
  │
  ▼
DESTINO
```

### Diagnóstico

Las cabeceras `Received` ayudan a reconstruir la ruta del mensaje.

> ⚠️ No deben interpretarse de forma ingenua como una prueba absoluta de la
> identidad del remitente: el análisis depende de qué servidores sean de
> confianza y de dónde se hayan añadido las cabeceras.

---

# 📎 21. MIME

**MIME — Multipurpose Internet Mail Extensions** permite transportar distintos
tipos de contenido dentro del correo.

Ejemplos:

```text
text/plain
text/html
image/jpeg
image/png
application/pdf
application/zip
```

Una cabecera típica:

```text
Content-Type: text/plain; charset=UTF-8
```

Para mensajes multiparte:

```text
Content-Type: multipart/mixed;
    boundary="----ABC123"
```

---

# 📦 22. Adjuntos

Un mensaje puede contener:

```text
mensaje
 ├── texto
 ├── HTML
 └── adjunto
```

Ejemplo conceptual:

```text
multipart/mixed
│
├── text/plain
│
└── application/pdf
```

MIME utiliza estructuras multipart y mecanismos de codificación para transportar
contenido que no es texto plano.

---

# 🔤 23. Codificación y Base64

Los adjuntos suelen aparecer codificados mediante mecanismos MIME como
Base64.

Ejemplo:

```text
archivo.pdf
     │
     ▼
Base64
     │
     ▼
texto transportable
```

> ⚠️ Base64 **no es cifrado**.
>
> Cualquiera que tenga el contenido puede decodificarlo.

---

# 📨 24. Envelope frente a mensaje

Hay que distinguir:

```text
SMTP envelope
```

de:

```text
message headers
```

Por ejemplo:

```text
MAIL FROM:<alice@example.test>
RCPT TO:<bob@example.test>
```

no equivale necesariamente a:

```text
From: Alice <alice@example.test>
To: Bob <bob@example.test>
```

Esto es importante para comprender:

- bounces;
- spam;
- spoofing;
- autenticación;
- trazabilidad.

---

# 🛡️ 25. Seguridad y privacidad

El correo electrónico tradicional no debe considerarse un canal
intrínsecamente confidencial.

Existen varias capas:

```text
┌────────────────────────────┐
│ Seguridad del dispositivo  │
├────────────────────────────┤
│ Seguridad del cliente      │
├────────────────────────────┤
│ TLS durante transporte     │
├────────────────────────────┤
│ Seguridad del servidor     │
├────────────────────────────┤
│ Autenticación              │
├────────────────────────────┤
│ Seguridad del mensaje      │
└────────────────────────────┘
```

TLS protege una conexión.

No significa necesariamente que:

```text
remitente → destinatario
```

esté cifrado extremo a extremo.

---

# 🔐 26. TLS y cifrado extremo a extremo

Diferenciar:

```text
TLS
```

de:

```text
cifrado extremo a extremo
```

### TLS

Protege una conexión concreta:

```text
cliente ───── TLS ───── servidor
```

### Cifrado extremo a extremo

Busca que únicamente los extremos autorizados puedan descifrar el contenido.

Ejemplos de tecnologías relacionadas:

```text
OpenPGP
S/MIME
```

> 🧠 El correo puede viajar por varios servidores intermedios. TLS no implica
> que esos sistemas no puedan acceder al mensaje una vez terminado el canal
> cifrado.

---

# 🔑 27. Autenticación

Los clientes suelen autenticarse frente al servidor de submission/acceso.

Métodos pueden incluir:

```text
usuario + contraseña
OAuth 2.0
certificados
otros mecanismos
```

La autenticación debe realizarse sobre un canal protegido.

> ⚠️ Nunca debe enseñarse «SMTP AUTH = seguridad».
>
> SMTP AUTH identifica/autentica al cliente; TLS protege el canal.

---

# 🦠 28. Protección frente a virus y malware

El correo es un vector habitual para distribuir:

```text
malware
ransomware
troyanos
scripts maliciosos
documentos manipulados
phishing
```

Una infraestructura puede analizar:

```text
cabeceras
cuerpo
URLs
adjuntos
tipo MIME
reputación
firma antivirus
heurística
```

Arquitectura conceptual:

```text
SMTP
 │
 ▼
ANTIVIRUS
 │
 ├── limpio ─────► entrega
 │
 └── sospechoso ─► cuarentena/rechazo
```

---

# 🗑️ 29. Spam

El spam es correo no solicitado, normalmente distribuido masivamente.

Un sistema antispam puede utilizar:

```text
listas de reputación
DNSBL
análisis de cabeceras
análisis de contenido
heurística
filtros bayesianos
reputación del remitente
SPF
DKIM
DMARC
```

> 🧠 Ningún mecanismo individual resuelve todo el problema.

---

# 🧬 30. SPF

**SPF — Sender Policy Framework** permite publicar mediante DNS qué servidores
están autorizados para enviar correo para un dominio.

Conceptualmente:

```text
DNS
 │
 └── SPF
       │
       ▼
¿Esta IP está autorizada?
```

Ejemplo conceptual:

```text
v=spf1 ip4:192.0.2.10 -all
```

SPF ayuda a validar el servidor de envío respecto al dominio del envelope,
pero no constituye por sí solo una firma criptográfica del mensaje.

---

# ✍️ 31. DKIM

**DKIM — DomainKeys Identified Mail** utiliza criptografía de clave pública.

Proceso:

```text
MENSAJE
   │
   ▼
firma con clave privada
   │
   ▼
DKIM-Signature
   │
   ▼
DESTINATARIO
   │
   ▼
clave pública DNS
   │
   ▼
verificación
```

La clave pública se publica mediante DNS.

---

# 🛡️ 32. DMARC

**DMARC — Domain-based Message Authentication, Reporting and Conformance**
permite establecer políticas sobre cómo tratar mensajes que no superen las
comprobaciones de autenticación asociadas.

Conceptualmente:

```text
SPF ──┐
      ├──► DMARC ───► política
DKIM ─┘
```

Políticas habituales:

```text
none
quarantine
reject
```

DMARC también proporciona mecanismos de reporte.

---

# 🧠 33. SPF + DKIM + DMARC

No son equivalentes:

```text
SPF
│
└── autorización del servidor/IP de envío

DKIM
│
└── firma criptográfica del mensaje

DMARC
│
└── política y alineación basada en autenticación
```

Juntos forman una parte importante de la autenticación moderna del correo.

---

# 🧪 34. PRÁCTICA 6.1 — Correo en Cisco Packet Tracer

Construye:

```text
PC-A
 │
 ├──────────┐
 │          │
 ▼          ▼
SWITCH    SERVER
             │
             └── Email
```

Configura en el servidor:

```text
DNS
Email
```

Dominio:

```text
asir.test
```

Cuentas:

```text
ana@asir.test
luis@asir.test
```

Configura los clientes.

### Objetivo

Enviar:

```text
ana → luis
```

y comprobar:

```text
✔ DNS
✔ SMTP
✔ buzón
✔ recepción
```

---

# 🧪 35. PRÁCTICA 6.2 — Analizar el correo en Packet Tracer

Utiliza:

```text
Simulation Mode
```

Filtra protocolos relacionados con:

```text
DNS
SMTP
POP3
```

Observa la secuencia:

```text
DNS
 ↓
SMTP
 ↓
servidor
 ↓
POP3
```

### Entrega

Captura el flujo y explica cada paso.

---

# 🧪 36. PRÁCTICA 6.3 — DNS y correo

En Ubuntu Server configura una zona de laboratorio:

```text
asir.test
```

Incluye:

```text
MX 10 mail.asir.test.
A    mail.asir.test → IP servidor
```

Comprueba:

```bash
dig MX asir.test
dig A mail.asir.test
```

### Objetivo

Relacionar:

```text
UT3 DNS
   +
UT6 CORREO
```

---

# 🧪 37. PRÁCTICA 6.4 — Inspeccionar SMTP desde WSL2

Desde WSL2:

```bash
nc -v mail.asir.test 25
```

Si el servidor responde:

```text
220 ...
```

prueba:

```text
EHLO wsl.asir.test
QUIT
```

### Analiza

```text
220
250
221
```

### Importante

No envíes correo a sistemas externos ni realices relay contra servidores que
no administres.

---

# 🧪 38. PRÁCTICA 6.5 — SMTP Submission con TLS

Con un servidor de laboratorio que proporcione submission:

```bash
openssl s_client \
  -connect mail.asir.test:587 \
  -starttls smtp
```

Observa:

```text
certificado
versión TLS
cipher
nombre del servidor
```

Después:

```text
EHLO wsl.asir.test
```

Busca capacidades como:

```text
AUTH
SIZE
STARTTLS
```

---

# 🧪 39. PRÁCTICA 6.6 — SMTP con TLS implícito

Prueba:

```bash
openssl s_client \
  -connect mail.asir.test:465 \
  -servername mail.asir.test
```

Compara con:

```bash
openssl s_client \
  -connect mail.asir.test:587 \
  -starttls smtp
```

Explica la diferencia:

```text
465 → TLS desde el comienzo
587 → SMTP + STARTTLS
```

---

# 🧪 40. PRÁCTICA 6.7 — POP3

Con un servidor POP3 de laboratorio:

```bash
openssl s_client \
  -connect mail.asir.test:995 \
  -servername mail.asir.test
```

Observa el saludo:

```text
+OK
```

Después identifica el estado de autorización.

No introduzcas credenciales reales.

---

# 🧪 41. PRÁCTICA 6.8 — IMAP

Con IMAPS:

```bash
openssl s_client \
  -connect mail.asir.test:993 \
  -servername mail.asir.test
```

Tras establecer TLS:

```text
A001 CAPABILITY
```

El servidor puede devolver capacidades.

### Objetivo

Comprobar que:

```text
993 ≠ POP3
993 = IMAP sobre TLS implícito
```

---

# 🧪 42. PRÁCTICA 6.9 — Configurar un cliente de correo en WSL2

Instala un cliente de terminal:

```bash
sudo apt update
sudo apt install neomutt
```

Configura una cuenta de laboratorio utilizando:

```text
IMAP
SMTP submission
TLS
```

No utilices credenciales personales.

### Debes documentar

```text
Servidor IMAP
Puerto
TLS
Servidor SMTP
Puerto
TLS
Autenticación
Usuario
```

> 💡 Si el laboratorio dispone de WSLg, también puede utilizarse un cliente
> gráfico Linux. La práctica conceptual debe ser la misma.

---

# 🧪 43. PRÁCTICA 6.10 — Configuración de cliente gráfico

Si se dispone de un entorno gráfico Linux:

```text
Cliente
   │
   ├── IMAP
   └── SMTP Submission
```

Configura:

```text
Nombre
Dirección de correo
Servidor entrante
Servidor saliente
Puertos
TLS
Autenticación
```

Comprueba:

```text
✔ recepción
✔ envío
✔ carpetas
✔ sincronización
✔ certificado
```

---

# 🧪 44. PRÁCTICA 6.11 — POP3 frente a IMAP

Configura dos perfiles de laboratorio.

### Perfil A

```text
POP3
995/TLS
```

### Perfil B

```text
IMAP
993/TLS
```

Realiza:

```text
1. recibir mensaje
2. leerlo
3. marcarlo
4. moverlo
5. comprobar desde otro cliente
```

### Conclusión

Explica qué operaciones permanecen en el servidor y cuáles dependen del modelo
de cada protocolo.

---

# 🧪 45. PRÁCTICA 6.12 — Analizar cabeceras

Envía un mensaje de laboratorio y analiza:

```text
From:
To:
Date:
Subject:
Message-ID:
Received:
MIME-Version:
Content-Type:
```

Identifica:

```text
origen
destino
fecha
ruta
tipo de contenido
identificador
```

### Reto

Dibuja la ruta utilizando exclusivamente las cabeceras `Received`.

---

# 🧪 46. PRÁCTICA 6.13 — MIME y adjuntos

Envía:

```text
mensaje.txt
imagen.png
documento.pdf
```

Analiza el mensaje bruto.

Busca:

```text
MIME-Version
Content-Type
Content-Disposition
Content-Transfer-Encoding
boundary
```

Identifica las diferentes partes:

```text
multipart/mixed
├── text/plain
├── image/png
└── application/pdf
```

---

# 🧪 47. PRÁCTICA 6.14 — Base64 no es cifrado

Obtén una parte Base64 de un mensaje de laboratorio.

Decodifícala:

```bash
base64 -d archivo.b64 > archivo_original
```

Comprueba que:

```text
Base64 ≠ cifrado
```

### Pregunta

¿Por qué se utiliza Base64 si no aporta confidencialidad?

---

# 🧪 48. PRÁCTICA 6.15 — DNS MX y encaminamiento

Consulta:

```bash
dig MX gmail.com
```

Después:

```bash
dig MX ejemplo.es
```

Analiza:

```text
prioridad
hostname
A
AAAA
```

### Reto

Explica qué debería hacer un MTA para encontrar el siguiente salto.

---

# 🧪 49. PRÁCTICA 6.16 — Diagnóstico con `dig`

Simula un fallo:

```text
mail.asir.test no resuelve
```

Ejecuta:

```bash
dig A mail.asir.test
dig MX asir.test
```

Comprueba:

```text
zona
registro MX
registro A/AAAA
TTL
respuesta
```

Relaciona con UT3.

---

# 🧪 50. PRÁCTICA 6.17 — Diagnóstico de TLS

Ejecuta:

```bash
openssl s_client \
  -connect mail.asir.test:993 \
  -servername mail.asir.test
```

Identifica:

```text
Subject
Issuer
Validity
TLS version
Cipher
Verification
```

### Reto

Provoca o identifica un certificado no confiable y explica el motivo.

---

# 🧪 51. PRÁCTICA 6.18 — Captura SMTP con Wireshark

En un entorno de laboratorio sin TLS:

```text
tcp.port == 25
```

Busca:

```text
EHLO
MAIL FROM
RCPT TO
DATA
QUIT
```

Observa que SMTP tradicional puede ser legible si no está protegido.

> ⚠️ Hazlo exclusivamente con tráfico de laboratorio.

---

# 🧪 52. PRÁCTICA 6.19 — Captura IMAP/POP3 con TLS

Captura:

```text
tcp.port == 993
```

o:

```text
tcp.port == 995
```

Compara con el SMTP sin TLS.

### Pregunta

¿Por qué ya no aparecen directamente:

```text
LOGIN
PASS
Subject:
From:
```

como texto legible?

---

# 🧪 53. PRÁCTICA 6.20 — Seguridad del cliente

Realiza una auditoría de un cliente de correo:

```text
☐ ¿Utiliza TLS?
☐ ¿Valida el certificado?
☐ ¿Utiliza autenticación?
☐ ¿Utiliza SMTP submission?
☐ ¿Usa contraseña de aplicación/OAuth cuando corresponde?
☐ ¿Descarga automáticamente imágenes?
☐ ¿Ejecuta contenido activo?
☐ ¿Permite bloquear adjuntos peligrosos?
☐ ¿Tiene filtro de spam?
☐ ¿Está actualizado?
```

---

# 🧪 54. PRÁCTICA 6.21 — Analizar spam

Crea mensajes de laboratorio con:

```text
Subject sospechoso
URL
adjunto
remitente falso
cabeceras anómalas
```

Analiza:

```text
From
Return-Path
Received
Message-ID
Authentication-Results
DKIM-Signature
```

### Objetivo

Aprender que la dirección mostrada en `From:` no basta para determinar la
autenticidad del mensaje.

---

# 🧪 55. PRÁCTICA 6.22 — SPF

Para un dominio de laboratorio, diseña conceptualmente:

```text
asir.test
```

con una política SPF.

Consulta:

```bash
dig TXT asir.test
```

Identifica:

```text
v=spf1 ...
```

### Explica

```text
¿Qué IP está autorizada?
¿Qué ocurre con -all?
¿Qué diferencia existe entre ~all y -all?
```

---

# 🧪 56. PRÁCTICA 6.23 — DKIM

Analiza un mensaje real de un laboratorio o entorno autorizado.

Busca:

```text
DKIM-Signature:
```

Identifica:

```text
d=
s=
bh=
b=
```

Después localiza mediante DNS la clave pública correspondiente al selector.

> ⚠️ El objetivo es interpretar la firma, no implementar una infraestructura
> completa de DKIM en esta UT.

---

# 🧪 57. PRÁCTICA 6.24 — DMARC

Consulta:

```bash
dig TXT _dmarc.example.test
```

Interpreta una política:

```text
p=none
p=quarantine
p=reject
```

Identifica:

```text
rua
pct
adkim
aspf
```

### Reto

Explica por qué DMARC no sustituye a SPF ni DKIM.

---

# 🧪 58. PRÁCTICA 6.25 — Flujo completo

Construye y documenta:

```text
               DNS
                │
                ▼
              SMTP
                │
                ▼
          ┌──────────┐
          │  BUZÓN   │
          └────┬─────┘
               │
          ┌────┴────┐
          │         │
        IMAP       POP3
          │         │
          └────┬────┘
               ▼
             MUA
```

Demuestra:

```text
1. resolución MX
2. conexión SMTP
3. entrega
4. acceso IMAP/POP3
5. TLS
6. análisis de cabeceras
7. captura de tráfico
```

---

# 🔍 59. Diagnóstico sistemático

Cuando un usuario dice:

> «No puedo enviar correo».

No empieces cambiando la contraseña.

Comprueba:

```text
                   ❌ NO ENVÍA
                        │
                        ▼
                  ¿DNS funciona?
                   /          \
                 NO            SÍ
                 │              │
                DNS             ▼
                         ¿Puerto accesible?
                           /          \
                         NO            SÍ
                         │              │
                      firewall          ▼
                              ¿TLS funciona?
                               /        \
                             NO          SÍ
                             │            │
                          certificado     ▼
                                      ¿AUTH?
                                       /   \
                                     NO     SÍ
                                     │       │
                                  cuenta     ▼
                                          SMTP
```

---

# 🧰 60. Herramientas

## DNS

```bash
dig MX dominio.test
dig A mail.dominio.test
dig TXT dominio.test
```

## Conectividad

```bash
nc -vz mail.dominio.test 587
nc -vz mail.dominio.test 993
nc -vz mail.dominio.test 995
```

## TLS

```bash
openssl s_client -connect mail.dominio.test:993
openssl s_client -connect mail.dominio.test:995
openssl s_client -connect mail.dominio.test:587 -starttls smtp
```

## Captura

```bash
sudo tcpdump -ni any port 25
sudo tcpdump -ni any port 587
sudo tcpdump -ni any port 993
```

## Análisis

```text
Wireshark
```

---

# 🧠 61. Caso profesional

Una empresa informa:

> «Los usuarios pueden recibir correo, pero no pueden enviarlo.»

Datos:

```text
IMAP → 993/TLS → funciona
SMTP → 587 → falla
DNS → funciona
```

Investiga:

```text
1. ¿Resuelve el servidor SMTP?
2. ¿Está abierto TCP/587?
3. ¿Funciona TLS?
4. ¿El certificado es válido?
5. ¿El cliente autentica?
6. ¿El servidor acepta AUTH?
7. ¿Se rechaza MAIL FROM?
8. ¿Se rechaza RCPT TO?
9. ¿Hay problema de relay?
10. ¿Qué indican los logs?
```

### Evidencia

```bash
dig
nc
openssl
curl / cliente
tcpdump
Wireshark
logs
```

---

# 🧪 62. Caso profesional 2 — «Recibo el correo duplicado»

Investiga:

```text
cliente
 ↓
IMAP
 ↓
servidor
 ↓
reglas
 ↓
carpetas
```

Comprueba:

```text
Message-ID
Received
UID
carpetas
reglas/filtros
```

### Objetivo

Distinguir:

```text
duplicación real
```

de:

```text
visualización duplicada
```

---

# 🧪 63. Caso profesional 3 — «El correo llega a spam»

Analiza:

```text
SPF
DKIM
DMARC
reputación
Received
Authentication-Results
contenido
URLs
adjuntos
```

No concluyas simplemente:

```text
«Es culpa del servidor».
```

El filtrado puede depender de múltiples señales.

---

# 📊 64. Comparativa de protocolos

| Protocolo | Función | Modelo | TLS habitual |
|---|---|---|---|
| SMTP | Envío/relay | Push | 587/STARTTLS, 465/TLS |
| POP3 | Acceso | Descarga | 995/TLS |
| IMAP | Acceso/sincronización | Estado remoto | 993/TLS |

---

# 🧱 65. Arquitectura moderna

```text
                         INTERNET
                            │
                            ▼
                           DNS
                            │
                           MX
                            │
                            ▼
                     ┌────────────┐
                     │    MTA     │
                     └─────┬──────┘
                           SMTP
                            │
                            ▼
                     ┌────────────┐
                     │    MDA     │
                     └─────┬──────┘
                           │
                         BUZÓN
                           │
                  ┌────────┴────────┐
                  │                 │
                IMAP              POP3
                  │                 │
                  └────────┬────────┘
                           ▼
                          MUA
```

Capas de protección:

```text
DNS
 │
 ▼
TLS
 │
 ▼
AUTH
 │
 ▼
SPF
DKIM
DMARC
 │
 ▼
ANTISPAM
 │
 ▼
ANTIMALWARE
```

---

# 🧪 66. Reto final — «Construye y demuestra el correo»

## Infraestructura

```text
             ┌────────────────────┐
             │ VirtualBox         │
             │ Ubuntu 26.04 Server│
             └─────────┬──────────┘
                       │
                 DNS + MAIL
                       │
             ┌─────────┴─────────┐
             │                   │
           WSL2              Packet Tracer
        Ubuntu 26.04          simulación
             │
             ▼
            MUA
```

## Requisitos

### DNS

```text
mail.asir.test
asir.test MX 10 mail.asir.test
```

### SMTP

```text
submission
TLS
autenticación
```

### Acceso

```text
IMAP
TLS
```

### Seguridad

```text
certificado
TLS
credenciales protegidas
```

### Análisis

Demostrar:

```text
DNS
SMTP
IMAP
TLS
cabeceras
MIME
```

### Entrega

```text
01-arquitectura.md
02-dns.md
03-smtp.md
04-imap.md
05-tls.md
06-cabeceras.md
07-mime.md
08-seguridad.md
09-pruebas.md
10-diagnostico.md
```

---

# 🏆 67. Reto avanzado

Explica qué ocurre cuando:

```text
ana@empresa-a.es
```

envía:

```text
Asunto: Reunión
Adjunto: informe.pdf
```

a:

```text
luis@empresa-b.es
```

Tu explicación debe incluir:

```text
1. MUA
2. SMTP submission
3. autenticación
4. TLS
5. DNS
6. MX
7. MTA origen
8. SMTP relay
9. MTA destino
10. MDA
11. buzón
12. IMAP
13. MUA destino
14. MIME
15. cabeceras
16. seguridad
```

### Representación esperada

```text
ANA
 │
 ▼
MUA
 │
 │ SMTP Submission + TLS
 ▼
MSA
 │
 ▼
MTA A
 │
 │ DNS → MX
 ▼
MTA B
 │
 ▼
MDA
 │
 ▼
BUZÓN
 │
 │ IMAP + TLS
 ▼
MUA
 │
 ▼
LUIS
```

---

# 🧠 68. Errores conceptuales que debes evitar

> 🔴 **SMTP ≠ protocolo para leer el buzón**

> 🔴 **POP3 ≠ IMAP**

> 🔴 **TLS ≠ cifrado extremo a extremo**

> 🔴 **Base64 ≠ cifrado**

> 🔴 **From: ≠ identidad autenticada**

> 🔴 **SPF ≠ firma criptográfica**

> 🔴 **DKIM ≠ antivirus**

> 🔴 **DMARC ≠ sustituto de SPF/DKIM**

> 🔴 **Puerto 25 ≠ puerto de cliente recomendado para submission**

> 🔴 **587 ≠ TLS implícito necesariamente**

> 🔴 **465 ≠ SMTP sin cifrado**

> 🔴 **MX ≠ dirección IP**

> 🔴 **IMAP ≠ descarga simple de mensajes**

> 🔴 **Spam ≠ malware**

---

# 📚 69. Resumen

```text
                    ✉️ CORREO
                       │
         ┌─────────────┼─────────────┐
         │             │             │
        SMTP          MIME       POP3/IMAP
         │             │             │
       enviar       contenido       leer
         │             │             │
         └─────────────┼─────────────┘
                       │
                      TLS
                       │
                ┌──────┴──────┐
                │             │
               SPF           DKIM
                │             │
                └──────┬──────┘
                       ▼
                      DMARC
                       │
                       ▼
                 🛡️ SEGURIDAD
```

Ideas fundamentales:

1. El correo es un sistema distribuido.
2. MUA es el cliente del usuario.
3. MSA recibe el correo enviado por clientes.
4. MTA transporta correo entre sistemas.
5. MDA realiza la entrega al buzón.
6. SMTP se utiliza para envío y transferencia.
7. POP3 e IMAP proporcionan acceso al buzón.
8. IMAP mantiene una visión remota del buzón.
9. DNS MX permite localizar servidores de correo.
10. Los mensajes tienen cabeceras y cuerpo.
11. MIME permite representar múltiples tipos de contenido.
12. Base64 es codificación, no cifrado.
13. TLS protege conexiones concretas.
14. STARTTLS permite negociar TLS sobre una conexión existente.
15. TLS implícito comienza la conexión directamente con TLS.
16. SPF publica servidores autorizados para el envío de un dominio.
17. DKIM proporciona una firma criptográfica.
18. DMARC establece políticas y alineación para autenticación de correo.
19. El spam y el malware requieren mecanismos de filtrado diferentes.
20. Las cabeceras `Received` son fundamentales para diagnosticar rutas.
21. La seguridad del correo debe analizarse por capas.
22. DNS, TCP/IP, TLS y correo están estrechamente relacionados.

---

# ❓ 70. Autoevaluación

1. ¿Qué es un MUA?
2. ¿Qué función realiza un MTA?
3. ¿Qué diferencia existe entre MSA y MTA?
4. ¿Qué función desempeña un MDA?
5. ¿Para qué se utiliza SMTP?
6. ¿Para qué se utiliza POP3?
7. ¿Para qué se utiliza IMAP?
8. ¿Qué diferencia fundamental existe entre POP3 e IMAP?
9. ¿Qué función desempeña un registro MX?
10. ¿Por qué un MX no contiene normalmente una dirección IP?
11. ¿Qué es SMTP submission?
12. ¿Qué puerto se utiliza habitualmente para Message Submission?
13. ¿Qué diferencia existe entre STARTTLS y TLS implícito?
14. ¿Qué puertos se asocian habitualmente a IMAPS y POP3S?
15. ¿Qué estructura básica tiene un mensaje de correo?
16. ¿Qué función tiene MIME?
17. ¿Por qué Base64 no es un mecanismo de cifrado?
18. ¿Qué información puede aportar `Received:`?
19. ¿Qué diferencia existe entre TLS y cifrado extremo a extremo?
20. ¿Qué función desempeña SPF?
21. ¿Qué función desempeña DKIM?
22. ¿Qué función desempeña DMARC?
23. ¿Qué diferencia existe entre spam y malware?
24. ¿Por qué `From:` no basta para demostrar quién envió realmente un mensaje?
25. ¿Qué herramientas utilizarías para diagnosticar un problema SMTP?
26. ¿Cómo comprobarías un registro MX?
27. ¿Cómo analizarías una conexión IMAPS?
28. ¿Qué ventaja tiene IMAP cuando se utilizan varios dispositivos?
29. ¿Qué riesgos existen al utilizar correo sin TLS?
30. ¿Qué relación existe entre DNS, MX y SMTP?

---

# ✅ 71. Solucionario de la autoevaluación

### 1. MUA

Es el programa que utiliza el usuario para redactar, enviar, recibir y gestionar
mensajes.

### 2. MTA

Transfiere correo entre sistemas de correo.

### 3. MSA y MTA

El MSA recibe mensajes enviados por clientes y aplica políticas de submission.
El MTA se ocupa principalmente de transferir correo entre sistemas.

### 4. MDA

Realiza la entrega final del mensaje en el buzón correspondiente.

### 5. SMTP

Se utiliza para enviar y transferir mensajes de correo.

### 6. POP3

Permite acceder al buzón, tradicionalmente mediante un modelo orientado a
descargar mensajes.

### 7. IMAP

Permite acceder y gestionar el buzón manteniendo su estado en el servidor.

### 8. POP3 frente a IMAP

POP3 está orientado principalmente a descarga. IMAP mantiene una representación
remota del buzón y facilita la sincronización entre dispositivos.

### 9. MX

Indica qué servidores reciben correo para un dominio y en qué orden de
preferencia.

### 10. MX e IP

MX contiene nombres de servidores. Esos nombres se resuelven posteriormente
mediante A/AAAA.

### 11. SMTP Submission

Es el servicio mediante el que un cliente autorizado entrega un mensaje a la
infraestructura de correo.

### 12. Puerto de submission

Habitualmente:

```text
TCP/587
```

### 13. STARTTLS y TLS implícito

STARTTLS comienza con el protocolo y posteriormente negocia TLS. TLS implícito
establece TLS desde el comienzo de la conexión.

### 14. IMAPS y POP3S

```text
IMAPS → 993/TCP
POP3S → 995/TCP
```

### 15. Estructura del mensaje

Principalmente:

```text
cabeceras
línea vacía
cuerpo
```

### 16. MIME

Permite representar y transportar contenido de diferentes tipos, incluidos
adjuntos y mensajes multiparte.

### 17. Base64

Base64 es una codificación reversible. No aporta confidencialidad.

### 18. Received

Permite observar saltos por los que ha pasado el mensaje y ayuda al diagnóstico
de su ruta.

### 19. TLS frente a E2EE

TLS protege conexiones concretas. El cifrado extremo a extremo pretende que
solo los extremos autorizados puedan descifrar el contenido.

### 20. SPF

Publica mediante DNS qué sistemas están autorizados para enviar correo para un
dominio.

### 21. DKIM

Añade una firma criptográfica que permite verificar determinados elementos del
mensaje mediante una clave pública publicada en DNS.

### 22. DMARC

Permite establecer políticas y mecanismos de alineación respecto de SPF y DKIM,
además de proporcionar informes.

### 23. Spam y malware

Spam es correo no solicitado. Malware es software o contenido destinado a
realizar acciones perjudiciales o no autorizadas.

### 24. From:

Porque `From:` es parte del contenido del mensaje y puede no demostrar por sí
solo qué sistema o identidad realizó realmente la entrega.

### 25. Diagnóstico SMTP

Por ejemplo:

```bash
dig
nc
openssl s_client
tcpdump
Wireshark
logs
```

### 26. MX

```bash
dig MX dominio.test
```

### 27. IMAPS

```bash
openssl s_client \
  -connect mail.dominio.test:993 \
  -servername mail.dominio.test
```

### 28. Ventaja de IMAP

Mantiene mensajes, carpetas y estado en el servidor, facilitando el uso desde
varios dispositivos.

### 29. Correo sin TLS

Puede exponer credenciales y contenido a observadores de red, dependiendo del
tráfico y de la infraestructura.

### 30. DNS + MX + SMTP

DNS permite localizar el servidor que recibe correo para un dominio mediante
MX. SMTP se utiliza posteriormente para realizar la transferencia.

---

# 📝 72. Test de repaso

### 1. ¿Qué protocolo se utiliza principalmente para transferir correo entre
servidores?

a) IMAP  
b) SMTP  
c) POP3  
d) DNS

### 2. ¿Qué protocolo está orientado al acceso remoto y sincronización del buzón?

a) SMTP  
b) FTP  
c) IMAP  
d) DHCP

### 3. ¿Qué puerto se utiliza habitualmente para SMTP Submission?

a) 25  
b) 53  
c) 587  
d) 993

### 4. ¿Qué registro DNS permite localizar servidores de correo?

a) A  
b) CNAME  
c) MX  
d) PTR

### 5. ¿Qué puerto se asocia normalmente con IMAPS?

a) 110  
b) 143  
c) 993  
d) 995

### 6. ¿Qué puerto se asocia normalmente con POP3S?

a) 25  
b) 465  
c) 993  
d) 995

### 7. ¿Qué tecnología permite incluir adjuntos y contenido multimedia en el
correo?

a) MIME  
b) DHCP  
c) ARP  
d) SSH

### 8. Base64 es:

a) cifrado  
b) hashing  
c) codificación  
d) autenticación

### 9. ¿Qué mecanismo publica servidores autorizados para enviar correo?

a) DKIM  
b) SPF  
c) IMAP  
d) MIME

### 10. ¿Qué mecanismo utiliza una firma criptográfica?

a) DKIM  
b) POP3  
c) MX  
d) SMTP

### 11. ¿Qué mecanismo permite establecer políticas sobre SPF/DKIM y su
alineación?

a) DNSSEC  
b) DMARC  
c) MIME  
d) POP3

### 12. ¿Qué cabecera ayuda especialmente a reconstruir la ruta de un mensaje?

a) Subject  
b) Received  
c) Content-Type  
d) Date

### 13. ¿Qué mecanismo protege una conexión entre cliente y servidor?

a) TLS  
b) Base64  
c) SPF  
d) MIME

### 14. ¿Qué afirmación es correcta?

a) SPF cifra el correo.  
b) DKIM elimina el spam.  
c) TLS y cifrado extremo a extremo son conceptos idénticos.  
d) SMTP se utiliza para envío/transferencia.

### 15. ¿Qué herramienta permite inspeccionar una sesión TLS desde terminal?

a) `dig`  
b) `openssl s_client`  
c) `ip route`  
d) `hostnamectl`

---

# ✅ 73. Respuestas del test

| Nº | Respuesta |
|---:|:---:|
| 1 | **b** |
| 2 | **c** |
| 3 | **c** |
| 4 | **c** |
| 5 | **c** |
| 6 | **d** |
| 7 | **a** |
| 8 | **c** |
| 9 | **b** |
| 10 | **a** |
| 11 | **b** |
| 12 | **b** |
| 13 | **a** |
| 14 | **d** |
| 15 | **b** |

---

# 🔄 74. Correspondencia con el capítulo original

| Capítulo original | UT6 actualizada |
|---|---|
| 6.1 Introducción | Arquitectura moderna del correo |
| 6.2 Protocolos involucrados | SMTP, POP3, IMAP |
| 6.2.1 Formatos de mensajes | RFC 5322 + MIME |
| 6.2.2 Transferencia de correo | MUA/MSA/MTA/MDA + DNS MX |
| 6.2.3 Seguridad y privacidad | TLS, autenticación y E2EE |
| 6.2.4 Protección frente a virus | Antimalware y análisis de adjuntos |
| 6.2.5 Correo basura | Spam + SPF/DKIM/DMARC |
| 6.3 Cliente de correo | Configuración práctica |
| 6.3.1 Windows | Conceptos transferibles a clientes gráficos |
| 6.3.2 Linux | **WSL2 + Ubuntu 26.04** |
| Ejercicios | Laboratorios actualizados |
| Test | Test actualizado + solucionario |

---

# 🧪 75. Entornos de laboratorio

```text
┌─────────────────────────────────────────────────────────────┐
│                    LABORATORIO ASIR                         │
├─────────────────┬─────────────────┬─────────────────────────┤
│ Packet Tracer   │ WSL2            │ VirtualBox              │
│                 │                 │                         │
│ SMTP/POP3       │ Cliente CLI     │ Ubuntu 26.04 Server    │
│ DNS             │ OpenSSL         │ DNS + servicios         │
│ Simulation Mode │ dig / nc        │ infraestructura         │
└─────────────────┴─────────────────┴─────────────────────────┘
```

### Packet Tracer

Ideal para:

```text
arquitectura
DNS
SMTP
POP3
flujo de paquetes
```

### WSL2

Ideal para:

```text
dig
nc
openssl
tcpdump
clientes CLI
análisis de protocolos
```

### VirtualBox + Ubuntu 26.04 Server

Ideal para:

```text
DNS
servidores de correo
TLS
usuarios
buzones
logs
firewall
```

---

# 🧠 76. Integración con las UT anteriores

El correo permite integrar prácticamente todo lo estudiado:

```text
                 UT1 · TCP/IP
                      │
                      ▼
                 conectividad
                      │
                      ▼
                 UT2 · DHCP
                      │
                      ▼
                 configuración IP
                      │
                      ▼
                  UT3 · DNS
                      │
                     MX
                      │
                      ▼
                 UT6 · CORREO
                      │
          ┌───────────┼───────────┐
          │           │           │
        SMTP         IMAP        POP3
          │           │           │
          └───────────┼───────────┘
                      │
                      ▼
                TLS / seguridad
                      │
                      ▼
                UT5 · WEB / PKI
```

Y se relaciona con UT4 mediante:

```text
transferencia de datos
autenticación
TLS
puertos
firewall
```

---

# 🩺 77. Árbol de diagnóstico completo

```text
                       ❌ CORREO FALLA
                              │
                              ▼
                         ¿DNS OK?
                         /      \
                       NO        SÍ
                       │          │
                      DNS         ▼
                           ¿TCP OK?
                           /      \
                         NO        SÍ
                         │          │
                     firewall      ▼
                              ¿TLS OK?
                               /   \
                             NO     SÍ
                             │       │
                          cert       ▼
                                  ¿AUTH?
                                   /  \
                                 NO    SÍ
                                 │      │
                              cuenta    ▼
                                     ¿SMTP?
                                      /  \
                                    NO    SÍ
                                    │      │
                                  logs    ▼
                                       entrega
                                         │
                                         ▼
                                      buzón
                                         │
                                         ▼
                                      IMAP/POP
```

---

# 🏁 78. Resultado esperado

Al finalizar la UT6, el alumno debería poder enfrentarse a:

> **«Un usuario puede resolver el dominio, pero no puede enviar correo. Otro
> usuario puede enviar pero no recibe. ¿Cómo determinarías si el problema está
> en DNS, SMTP, TLS, autenticación, entrega, buzón, IMAP/POP3 o en el cliente?»**

La respuesta profesional debe seguir:

```text
REQUISITOS
    ↓
DNS
    ↓
TCP
    ↓
SMTP / IMAP / POP3
    ↓
TLS
    ↓
AUTENTICACIÓN
    ↓
ENTREGA
    ↓
BUZÓN
    ↓
CLIENTE
    ↓
CABECERAS
    ↓
LOGS
    ↓
CAPTURA
    ↓
DIAGNÓSTICO
```

---

# 📖 79. Referencias

### Fuente principal

**Fco. José Molina Robles — _Servicios de Red e Internet (Grado Superior)_**,
Grupo Editorial RA-MA.

El índice del libro sitúa:

```text
CAPÍTULO 5 → Terminal remoto
CAPÍTULO 6 → Los servicios de correo electrónico
CAPÍTULO 7 → Servidores de correo electrónico
```

y el capítulo 6 comienza en la página 179. citeturn2view0

La estructura del capítulo 6 comprende introducción, protocolos involucrados,
formatos de mensajes, transferencia, seguridad y privacidad, protección frente
a virus, spam y configuración de clientes Windows/Linux. citeturn0search2

### Estándares utilizados para la actualización

- **RFC 5322** — formato de los mensajes de Internet.
- **RFC 6409** — Message Submission.
- **RFC 8314** — TLS para submission y acceso al correo.
- **RFC 2045** — MIME.

RFC 5322 define la estructura de cabeceras y cuerpo del mensaje; MIME extiende
el formato para transportar diferentes tipos de contenido. citeturn1search1turn1search4

RFC 6409 separa el servicio de Message Submission del relay y establece
normalmente el puerto 587 para submission. citeturn1search0

RFC 8314 documenta TLS para POP3, IMAP y SMTP Submission y define, entre otros,
los puertos 993 para IMAPS, 995 para POP3S y 465 para submission con TLS
implícito. citeturn1search2turn1search3

---

<div align="center">

## ✉️ UT6 · LOS SERVICIOS DE CORREO ELECTRÓNICO

```text
                 DNS
                  │
                  ▼
             ┌────────┐
             │   MX   │
             └───┬────┘
                 │
                 ▼
               SMTP
                 │
          ┌──────┴──────┐
          │             │
        IMAP           POP3
          │             │
          └──────┬──────┘
                 ▼
                MUA
                 │
        ┌────────┼────────┐
        │        │        │
       TLS      MIME     SPAM
        │        │        │
        └────────┼────────┘
                 ▼
             🛡️ CORREO
```

**NO SOLO ENVIAR UN CORREO.  
ENTENDER TODO EL SISTEMA QUE LO HACE POSIBLE.**

**FIN DE LA UT6**

</div>
