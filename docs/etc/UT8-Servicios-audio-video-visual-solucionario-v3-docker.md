<div align="center">

# 🎧📺 UT8 · SERVICIOS DE AUDIO Y VÍDEO 📺🎧

### 🌐 Multimedia · Códecs · Streaming · Podcast · VoIP · Videoconferencia

```text
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║                 🎧  SERVICIOS DE AUDIO Y VÍDEO  📺                  ║
║                                                                      ║
║     AUDIO ──► CÓDEC ──► STREAMING ──► CLIENTE                     ║
║        │                         │                                   ║
║      PODCAST                  HLS / RTMP                            ║
║                                  │                                   ║
║                                  ▼                                   ║
║                         ┌────────────────┐                           ║
║                         │ SERVIDOR MEDIA │                           ║
║                         └───────┬────────┘                           ║
║                                 │                                    ║
║                 ┌───────────────┼───────────────┐                    ║
║                 ▼               ▼               ▼                    ║
║              🎵 Audio         🎬 Vídeo       🎥 Directo              ║
║                                                                      ║
║  🧪 Cisco Packet Tracer · WSL2 · VirtualBox + Ubuntu 26.04 Server   ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
```

**SERVICIOS DE RED E INTERNET · CFGS ASIR**

**Material docente actualizado · 2026**

</div>

> 🔬 **VERSIÓN V2 · REVISIÓN TÉCNICA 2026-09-18**
>
> Se ha realizado una segunda pasada sobre los bloques de código y las configuraciones prácticas. Corregida la publicación FFmpeg→Icecast (`icecast://`), sustituido el placeholder de RTMP por `libnginx-mod-rtmp` y reforzada la configuración HLS con MIME types y `nginx -t`.
>
> ⚠️ La validación automática cubre sintaxis y configuraciones aisladas; la validación extremo a extremo > de Cisco Packet Tracer, WSL2 y una VM real de Ubuntu 26.04 Server requiere ejecutar el laboratorio en esos entornos.


---

> 🎯 **MISIÓN DE LA UT**
>
> Comprender cómo se distribuyen contenidos audiovisuales por una red y ser
> capaz de **identificar formatos, elegir códecs, desplegar servicios de
> streaming, configurar clientes y diagnosticar problemas de reproducción y
> transmisión**.
>
> El laboratorio se construirá progresivamente:
>
> ```text
> fichero multimedia
>       ↓
> códec / contenedor
>       ↓
> servidor
>       ↓
> protocolo de distribución
>       ↓
> red
>       ↓
> cliente
>       ↓
> reproducción
> ```

---

# 📚 1. Estructura de la unidad

La estructura de referencia para esta unidad gira alrededor de:

```text
8.1  Introducción
8.2  Formatos multimedia
8.3  Herramientas de reproducción multimedia
8.4  Streaming
8.5  Distribución y suscripción de audio y vídeo
8.6  Tecnología de Voz IP (VoIP)
8.7  Servicios de videoconferencia
8.8  Prácticas resueltas
8.9  Prácticas propuestas
8.10 Resumen
8.11 Test de repaso
8.12 Comprueba tu aprendizaje
```

La organización coincide con índices publicados para el módulo que incluyen
formatos multimedia, reproducción, streaming, distribución/suscripción,
VoIP, videoconferencia y bloques finales de prácticas, resumen y evaluación.
citeturn0search11turn0search2

> 🔄 **Actualización tecnológica**
>
> El contenido conceptual se conserva, pero las prácticas se trasladan a
> tecnologías actuales:
>
> - 🐧 **VirtualBox + Ubuntu 26.04 Server**
> - 🐧 **WSL2 + Ubuntu 26.04**
> - 🎧 **Icecast** para streaming de audio
> - 🎬 **FFmpeg** para codificación y pruebas
> - 📺 **Nginx + RTMP** como laboratorio de vídeo en directo
> - 🌐 **HLS** para distribución HTTP de vídeo
> - ▶️ **VLC** como cliente multimedia
> - 🖧 **Cisco Packet Tracer** para representar la infraestructura de red.
>
> La elección de estas herramientas es una actualización práctica del
> contenido, no una reproducción literal de una implementación histórica.

---

# 🧭 2. Mapa de la unidad

```text
                           🎧📺 MULTIMEDIA
                                  │
          ┌───────────────────────┼───────────────────────┐
          │                       │                       │
        AUDIO                   VÍDEO                  TIEMPO REAL
          │                       │                       │
       códec                   códec                  streaming
          │                       │                       │
      contenedor             contenedor                 │
          │                       │                ┌─────┴─────┐
          │                       │                │           │
       MP3/Ogg/AAC          MP4/WebM/MKV          HLS        RTMP
          │                       │                │           │
          └───────────────┬───────┘                │           │
                          ▼                        ▼           ▼
                       CLIENTE                  navegador    OBS/FFmpeg
                          │
                          ▼
                         VLC
```

---

# 🎯 3. Objetivos

Al terminar esta UT deberás poder:

- Explicar qué es un servicio multimedia.
- Diferenciar **formato**, **códec** y **contenedor**.
- Explicar el muestreo y la cuantificación del audio digital.
- Interpretar frecuencia de muestreo, profundidad de bits y bitrate.
- Identificar formatos habituales de audio.
- Identificar formatos de imagen.
- Identificar formatos y códecs de vídeo.
- Explicar resolución, FPS, bitrate y relación de aspecto.
- Utilizar herramientas de reproducción multimedia.
- Explicar qué es streaming.
- Diferenciar descarga progresiva y streaming en tiempo real.
- Diferenciar unicast y multicast conceptualmente.
- Comprender streaming bajo HTTP.
- Comprender RTMP y HLS.
- Instalar y configurar un servidor de audio.
- Utilizar Icecast.
- Publicar un stream de audio.
- Utilizar VLC como cliente.
- Utilizar FFmpeg para generar streams.
- Crear un flujo de vídeo de laboratorio.
- Comprender la arquitectura de un servidor RTMP.
- Generar HLS.
- Comprender podcast y vodcast.
- Explicar VoIP.
- Explicar RTP, SIP y señalización.
- Comprender la arquitectura básica de videoconferencia.
- Diagnosticar problemas de bitrate, red, códec, puertos y reproducción.
- Documentar un servicio multimedia reproducible.

---

# 🎵 4. Audio digital

Una señal de audio analógica es continua.

Para procesarla digitalmente se realiza, de forma simplificada:

```text
SEÑAL ANALÓGICA
       │
       ▼
   MUESTREO
       │
       ▼
 CUANTIFICACIÓN
       │
       ▼
   CODIFICACIÓN
       │
       ▼
 AUDIO DIGITAL
```

---

# 📐 5. Frecuencia de muestreo

La frecuencia de muestreo indica cuántas muestras se toman por segundo.

Se expresa en:

```text
Hz
kHz
```

Ejemplo:

```text
44.100 Hz
```

significa:

```text
44.100 muestras / segundo
```

Un audio:

```text
44,1 kHz
```

contiene 44.100 muestras por segundo y canal.

---

# 🔢 6. Profundidad de bits

La profundidad de bits determina cuántos niveles de amplitud pueden
representarse.

Ejemplo:

```text
8 bits  → 256 niveles
16 bits → 65.536 niveles
24 bits → 16.777.216 niveles
```

La relación es:

```text
niveles = 2^bits
```

---

# 📦 7. Bitrate de audio PCM

Para PCM sin compresión:

```text
bitrate =
frecuencia_muestreo × bits_por_muestra × canales
```

Ejemplo:

```text
44.100 × 16 × 2
```

resultado:

```text
1.411.200 bit/s
```

o aproximadamente:

```text
1.411,2 kbit/s
```

Esto explica por qué un formato PCM ocupa mucho más que un audio comprimido.

---

# 🧠 8. Códec

Un **códec** es un algoritmo o conjunto de algoritmos para codificar y
decodificar contenido.

```text
CODIFICADOR
     │
     ▼
audio/vídeo comprimido
     │
     ▼
DECODIFICADOR
     │
     ▼
reproducción
```

Ejemplos:

```text
Audio:
MP3
AAC
Opus
Vorbis

Vídeo:
H.264/AVC
H.265/HEVC
VP9
AV1
```

> ⚠️ No confundas códec con contenedor.

---

# 📦 9. Contenedor

El contenedor organiza uno o varios flujos multimedia y metadatos.

Por ejemplo:

```text
┌─────────────────────────────┐
│           MP4               │
│                             │
│  vídeo → H.264              │
│  audio → AAC                │
│  metadatos                  │
└─────────────────────────────┘
```

Otro ejemplo:

```text
┌─────────────────────────────┐
│           MKV               │
│                             │
│  vídeo → AV1                │
│  audio → Opus               │
│  subtítulos                 │
└─────────────────────────────┘
```

---

# 🧩 10. Códec ≠ contenedor ≠ formato

Una forma útil de recordarlo:

```text
CONTENEDOR
    │
    ├── vídeo → CÓDEC
    ├── audio → CÓDEC
    ├── subtítulos
    └── metadatos
```

Ejemplo:

```text
pelicula.mkv
    │
    ├── vídeo: H.264
    ├── audio: AAC
    └── subtítulos: SRT
```

La extensión:

```text
.mkv
```

no nos dice por sí sola qué códecs contiene.

---

# 🎧 11. Formatos de audio

| Formato/códec | Tipo | Característica |
|---|---|---|
| WAV/PCM | Sin compresión habitual | Gran tamaño |
| FLAC | Sin pérdida | Reduce tamaño sin perder información |
| MP3 | Con pérdida | Muy extendido |
| AAC | Con pérdida | Muy utilizado en distribución |
| Ogg Vorbis | Con pérdida | Formato abierto |
| Opus | Con pérdida | Voz, música y comunicaciones |
| ALAC | Sin pérdida | Audio lossless |

---

# 🎬 12. Formatos de vídeo

| Contenedor | Ejemplo de vídeo | Uso |
|---|---|---|
| MP4 | H.264/H.265 | Distribución general |
| WebM | VP9/AV1 | Web |
| MKV | múltiples códecs | Contenedor flexible |
| MOV | H.264/HEVC, etc. | Ecosistema multimedia |
| MPEG-TS | MPEG/H.264/H.265 | Transporte/broadcast |

---

# 🖼️ 13. Formatos de imagen

La imagen también forma parte del ecosistema multimedia.

```text
JPEG
PNG
GIF
WebP
AVIF
SVG
```

### Mapa rápido

```text
JPEG  → fotografías
PNG   → transparencia / gráficos
WebP  → web
AVIF  → alta eficiencia
SVG   → vectorial
```

---

# 📐 14. Vídeo: resolución

La resolución indica normalmente:

```text
ancho × alto
```

Ejemplos:

```text
1280 × 720
1920 × 1080
3840 × 2160
```

Con frecuencia:

```text
720p  → 1280×720
1080p → 1920×1080
2160p → 3840×2160
```

---

# 🎞️ 15. FPS

FPS significa:

```text
Frames Per Second
```

Ejemplos:

```text
24 fps
25 fps
30 fps
50 fps
60 fps
```

A mayor FPS:

```text
más imágenes por segundo
→ potencialmente más fluidez
→ potencialmente más datos/procesamiento
```

---

# 📊 16. Bitrate de vídeo

El bitrate indica la cantidad de bits utilizados por unidad de tiempo.

Ejemplo:

```text
4 Mbit/s
```

significa aproximadamente:

```text
4 millones de bits por segundo
```

El bitrate afecta directamente:

```text
calidad
tamaño
ancho de banda
```

Pero la calidad no depende únicamente del bitrate.

También depende de:

```text
códec
resolución
FPS
contenido
perfil
preset
escena
```

---

# 📐 17. Relación de aspecto

Ejemplos:

```text
4:3
16:9
21:9
```

Para:

```text
1920×1080
```

tenemos:

```text
1920 / 1080 = 16 / 9
```

---

# 🧪 18. PRÁCTICA 8.1 — Inspección multimedia

Instala FFmpeg:

```bash
sudo apt update
sudo apt install ffmpeg
```

Consulta un fichero:

```bash
ffprobe video.mp4
```

También:

```bash
ffprobe -v error \
  -show_entries stream=index,codec_name,codec_type,width,height,r_frame_rate,bit_rate \
  video.mp4
```

Identifica:

```text
contenedor
códec de vídeo
códec de audio
resolución
FPS
bitrate
```

---

# 🧪 19. PRÁCTICA 8.2 — Comparar contenedores

Utiliza un mismo contenido y genera:

```text
video.mp4
video.mkv
video.webm
```

Comprueba:

```bash
ffprobe video.mp4
ffprobe video.mkv
ffprobe video.webm
```

Responde:

> ¿Cambiar la extensión cambia necesariamente el códec?

---

# ▶️ 20. Herramientas de reproducción

En el laboratorio utilizaremos principalmente:

```text
VLC
ffplay
navegador web
```

VLC resulta especialmente útil porque permite reproducir:

```text
archivos
URLs
streams
listas
```

---

# 🧪 21. PRÁCTICA 8.3 — VLC

Instala VLC en el cliente que corresponda.

Desde terminal:

```bash
vlc video.mp4
```

Prueba después:

```text
Media → Open Network Stream
```

Introduce una URL HTTP de prueba.

### Objetivo

Distinguir:

```text
fichero local
      ≠
recurso remoto
      ≠
stream en directo
```

---

# 🌊 22. ¿Qué es streaming?

Streaming es una técnica de distribución en la que el contenido puede comenzar
a reproducirse mientras se recibe.

```text
SERVIDOR
   │
   │ datos
   ▼
CLIENTE
   │
   ├──► búfer
   │
   └──► reproducción
```

No es necesario esperar a disponer de todo el contenido.

---

# 📥 23. Descarga frente a streaming

## Descarga tradicional

```text
SERVIDOR
   │
   ▼
████████████████████
        │
        ▼
     fichero
        │
        ▼
   reproducción
```

## Streaming

```text
SERVIDOR
   │
   ▼
███
 │
 ▼
reproduce
 │
 ▼
████
 │
 ▼
sigue reproduciendo
```

---

# 🧠 24. Búfer

El cliente mantiene una cantidad de datos temporalmente.

```text
          RED
           │
           ▼
      ┌──────────┐
      │  BÚFER   │
      └────┬─────┘
           │
           ▼
      REPRODUCTOR
```

Si la tasa de llegada es inferior a la tasa necesaria de reproducción:

```text
búfer ↓↓↓
     ↓
  buffering
```

---

# 📊 25. Condición básica de streaming

De forma simplificada:

```text
tasa de recepción ≥ tasa de reproducción
```

Si:

```text
vídeo = 5 Mbit/s
red efectiva = 2 Mbit/s
```

el cliente terminará quedándose sin datos.

Pero una red con suficiente ancho de banda tampoco garantiza una reproducción
perfecta.

También importan:

```text
latencia
jitter
pérdidas
CPU
decodificación
búfer
servidor
```

---

# 🔄 26. Streaming bajo demanda y directo

## VOD

```text
Video On Demand
```

El usuario solicita contenido almacenado.

```text
película
curso
grabación
vídeo educativo
```

## Live

Contenido generado en directo:

```text
cámara
  ↓
codificador
  ↓
servidor
  ↓
clientes
```

---

# 🌐 27. Arquitectura de streaming

```text
              FUENTE
                │
                ▼
          CODIFICADOR
                │
                ▼
         SERVIDOR MEDIA
                │
       ┌────────┼────────┐
       │        │        │
      C1       C2       C3
       │        │        │
       ▼        ▼        ▼
     VLC      navegador  móvil
```

---

# 🧱 28. Componentes

Un sistema puede contener:

```text
1. Fuente
2. Capturadora
3. Codificador
4. Servidor
5. Red
6. Cliente
7. Reproductor
```

Ejemplo:

```text
Micrófono
   │
   ▼
FFmpeg / IceS
   │
   ▼
Icecast
   │
   ▼
VLC
```

---

# 📡 29. Protocolos multimedia

Dependiendo de la arquitectura podemos encontrar:

```text
HTTP/HTTPS
HLS
RTMP
RTP
RTSP
WebRTC
SIP
```

No todos cumplen la misma función.

```text
HTTP/HLS → distribución
RTMP     → ingest / streaming
RTP      → transporte multimedia en tiempo real
RTSP     → control de sesiones multimedia
SIP      → señalización VoIP
WebRTC   → comunicación multimedia interactiva
```

---

# 🎧 30. Icecast

Icecast es un servidor orientado a streaming, especialmente habitual en
radio por Internet.

Arquitectura:

```text
FUENTE
  │
  │ stream
  ▼
┌──────────────┐
│   ICECAST    │
│              │
│ /radio.ogg   │
│ /radio.mp3   │
└──────┬───────┘
       │
   ┌───┼───┐
   ▼   ▼   ▼
  C1  C2  C3
```

Icecast utiliza **mountpoints** para identificar streams independientes. Un
mismo servidor puede alojar varios streams. citeturn1search4

---

# 🔌 31. Icecast y mountpoints

Ejemplo:

```text
/radio.mp3
```

o:

```text
/radio.ogg
```

Cada mountpoint identifica un stream.

```text
Icecast
   │
   ├── /rock.mp3
   ├── /jazz.ogg
   └── /classical.ogg
```

La documentación de Icecast describe los mountpoints como identificadores
únicos de cada broadcast/stream y permite configurar parámetros específicos
por mountpoint. citeturn1search4turn1search5

---

# 🧪 32. PRÁCTICA 8.4 — Instalar Icecast

En **VirtualBox + Ubuntu 26.04 Server**:

```bash
sudo apt update
sudo apt install icecast2
```

Comprueba:

```bash
systemctl status icecast2
```

Y:

```bash
ss -ltnp | grep 8000
```

> ℹ️ La disponibilidad exacta del paquete y los nombres de servicio pueden
> variar según la distribución/repositorio. Comprueba siempre:
>
> ```bash
> apt policy icecast2
> ```

---

# ⚙️ 33. Configuración de Icecast

El fichero habitual es:

```text
/etc/icecast2/icecast.xml
```

Parámetros importantes:

```text
listen socket
source password
relay password
admin credentials
mountpoints
limits
logging
```

La documentación de Icecast organiza la configuración en límites,
autenticación, relays, mountpoints, rutas, logging y seguridad.
citeturn1search0turn1search5

---

# 🔐 34. Contraseñas de Icecast

Debes diferenciar:

```text
source password
relay password
admin password
```

No utilices:

```text
1234
admin
password
```

aunque sea un laboratorio.

Utiliza credenciales de laboratorio claramente identificadas y no las
publiques en GitHub.

---

# 🧪 35. PRÁCTICA 8.5 — Configurar Icecast

Configura:

```text
Servidor:
radio.asir.test

Puerto:
8000

Mount:
radio.mp3
```

Comprueba desde WSL2:

```bash
curl -I http://radio.asir.test:8000/
```

Y:

```bash
curl -s http://radio.asir.test:8000/status-json.xsl
```

Si la instalación proporciona ese endpoint, úsalo para estudiar el estado
del servidor.

---

# 🎙️ 36. Generar audio con FFmpeg

Puedes utilizar un fichero local:

```bash
ffmpeg \
  -re \
  -i audio.mp3 \
  -c:a libmp3lame \
  -b:a 128k \
  -f mp3 \
  icecast://source:CONTRASEÑA_SOURCE@radio.asir.test:8000/radio.mp3
```

La sintaxis concreta de publicación depende de cómo esté configurado el
servidor y de la autenticación requerida.

---

# 🧪 37. PRÁCTICA 8.6 — Publicar un stream de audio

Objetivo:

```text
audio.mp3
   │
   ▼
FFmpeg
   │
   ▼
Icecast
   │
   ▼
VLC
```

Comprueba desde el cliente:

```text
http://radio.asir.test:8000/radio.mp3
```

En VLC:

```text
Media
  ↓
Open Network Stream
  ↓
URL
```

---

# 🔍 38. Diagnóstico de Icecast

Comprueba:

```bash
systemctl status icecast2
```

Puerto:

```bash
ss -ltnp | grep 8000
```

Conectividad:

```bash
nc -vz radio.asir.test 8000
```

HTTP:

```bash
curl -I http://radio.asir.test:8000/
```

Logs:

```bash
journalctl -u icecast2
```

---

# 🧪 39. PRÁCTICA 8.7 — Provocar un fallo

Cambia temporalmente:

```text
puerto
mountpoint
contraseña
```

Observa qué ocurre.

Diagnóstico:

```text
DNS
 ↓
TCP
 ↓
Icecast
 ↓
autenticación
 ↓
mountpoint
 ↓
cliente
```

Documenta:

```text
síntoma
causa
evidencia
corrección
```

---

# 🎙️ 40. Podcast

Un podcast es una forma de distribución y suscripción de contenidos
audiovisuales, habitualmente mediante feeds.

Arquitectura conceptual:

```text
CREADOR
   │
   ▼
audio.mp3
   │
   ▼
SERVIDOR WEB
   │
   ├── archivo
   └── feed RSS
          │
          ▼
        CLIENTE
```

El feed permite descubrir y suscribirse a nuevos episodios.

---

# 📡 41. RSS y podcast

Conceptualmente:

```text
<rss>
   <channel>
      <title>ASIR Radio</title>

      <item>
         <title>UT8 · Streaming</title>
         <enclosure ... />
      </item>
   </channel>
</rss>
```

El elemento `enclosure` permite asociar el recurso multimedia.

---

# 🧪 42. PRÁCTICA 8.8 — Mini-podcast

Crea:

```text
podcast/
├── feed.xml
├── episodio01.mp3
└── episodio02.mp3
```

Sirve el directorio mediante Nginx:

```bash
sudo apt install nginx
```

Comprueba:

```text
http://podcast.asir.test/feed.xml
```

### Reto

Añade un tercer episodio sin modificar los anteriores.

---

# 📺 43. Vídeo bajo demanda

Para VOD podemos utilizar un servidor web:

```text
Nginx
   │
   ├── video01.mp4
   ├── video02.mp4
   └── video03.mp4
```

El cliente solicita:

```text
https://video.asir.test/video01.mp4
```

Esto no convierte automáticamente Nginx en un servidor de streaming
especializado.

---

# 🎬 44. Streaming HTTP y HLS

HLS utiliza:

```text
playlist .m3u8
+
segmentos
```

Conceptualmente:

```text
stream.m3u8
   │
   ├── segment001.ts
   ├── segment002.ts
   ├── segment003.ts
   └── ...
```

El cliente solicita los segmentos sucesivamente.

---

# 🌐 45. HLS

Arquitectura:

```text
          CODIFICADOR
               │
               ▼
        ┌──────────────┐
        │   SERVIDOR   │
        │               │
        │ stream.m3u8   │
        │ segment*.ts   │
        └──────┬────────┘
               │ HTTP
               ▼
             CLIENTE
```

HLS permite distribuir vídeo utilizando HTTP y playlists `.m3u8`. Nginx
dispone además de un módulo HLS específico para determinados escenarios de
ficheros multimedia. citeturn2search1

---

# 📡 46. RTMP

RTMP es un protocolo de streaming utilizado históricamente y todavía muy
presente en flujos de **ingest** hacia servidores multimedia.

Arquitectura típica:

```text
OBS / FFmpeg
     │
     │ RTMP
     ▼
RTMP SERVER
     │
     ├──► HLS
     └──► otros destinos
```

El módulo `nginx-rtmp-module` proporciona soporte para RTMP y puede generar
HLS/DASH según la configuración. citeturn2search0turn2search6

---

# ⚠️ 47. RTMP no es HLS

No son lo mismo:

```text
RTMP
│
└── protocolo de ingest / distribución

HLS
│
└── distribución mediante HTTP + playlist/segmentos
```

Una arquitectura puede utilizar ambos:

```text
FFmpeg
  │
  │ RTMP
  ▼
Nginx RTMP
  │
  │ HLS
  ▼
navegador
```

---

# 🧪 48. PRÁCTICA 8.9 — Nginx RTMP

El módulo RTMP no está integrado necesariamente de la misma forma en todas
las instalaciones de Nginx.

Primero comprueba:

```bash
nginx -V 2>&1
```

y:

```bash
apt search nginx | grep rtmp
```

Si existe un paquete/módulo compatible en tu repositorio:

```bash
sudo apt install libnginx-mod-rtmp
```

Después comprueba que Nginx reconoce el módulo y valida la configuración:

```bash
sudo nginx -t
```

> ⚠️ No asumas que cualquier paquete denominado `nginx` incluye RTMP.

---

# ⚙️ 49. Arquitectura Nginx + RTMP + HLS

Ejemplo conceptual:

```nginx
rtmp {
    server {
        listen 1935;

        application live {
            live on;

            hls on;
            hls_path /var/www/hls;
            hls_fragment 3s;
            hls_playlist_length 12s;
        }
    }
}
```

El esquema anterior pertenece al modelo habitual del módulo
`nginx-rtmp-module`: una aplicación `live`, entrada RTMP y generación HLS.
citeturn2search0

> 🔐 Para producción deben añadirse controles de publicación, autenticación,
> límites, TLS en la distribución HTTP y una política de acceso adecuada.

---

# 🧪 50. PRÁCTICA 8.10 — Publicar RTMP con FFmpeg

Una vez disponible el servidor RTMP:

```bash
ffmpeg \
  -re \
  -stream_loop -1 \
  -i video.mp4 \
  -c:v libx264 \
  -preset veryfast \
  -c:a aac \
  -b:a 128k \
  -f flv \
  rtmp://video.asir.test/live/ut8
```

Arquitectura:

```text
video.mp4
   │
   ▼
 FFmpeg
   │
 RTMP
   │
   ▼
Nginx RTMP
   │
   ▼
 HLS
```

---

# 🌐 51. Servir HLS

Si el servidor genera:

```text
/var/www/hls/ut8.m3u8
```

Nginx debe servirlo mediante HTTP.

Ejemplo conceptual:

```nginx
location /hls {
    root /var/www;

    types {
        application/vnd.apple.mpegurl m3u8;
        video/mp2t ts;
    }

    add_header Cache-Control no-cache;
    add_header Access-Control-Allow-Origin *;
}
```

Comprueba:

```bash
curl -I http://video.asir.test/hls/ut8.m3u8
```

---

# 🧪 52. PRÁCTICA 8.11 — Reproducir HLS

Desde VLC:

```text
Media
  ↓
Open Network Stream
  ↓
http://video.asir.test/hls/ut8.m3u8
```

Analiza:

```text
playlist
segmentos
latencia
buffer
```

---

# 📊 53. Latencia

En directo existe un compromiso:

```text
más búfer
   ↓
más estabilidad
   ↓
más latencia
```

Mientras:

```text
menos búfer
   ↓
menos latencia
   ↓
más sensibilidad a problemas de red
```

Conceptualmente:

```text
          estabilidad
              ▲
              │
              │
              │
              └──────────────► latencia
```

No existe un valor universalmente óptimo.

---

# 🧪 54. PRÁCTICA 8.12 — Medir comportamiento

Realiza una transmisión:

```text
FFmpeg → RTMP → Nginx → HLS → VLC
```

Registra:

```text
resolución
FPS
bitrate
latencia aproximada
CPU
uso de red
```

Después cambia:

```text
720p → 1080p
```

y compara.

---

# 🧠 55. Calidad y bitrate

Un aumento de bitrate puede mejorar la calidad:

```text
2 Mbit/s
      ↓
5 Mbit/s
```

pero también:

```text
más tráfico
más almacenamiento
más requisitos de red
```

La calidad depende de la eficiencia del códec.

Por eso no es correcto afirmar:

> «más bitrate siempre significa mejor experiencia».

---

# 🧪 56. PRÁCTICA 8.13 — Comparar códecs

Genera versiones de un mismo vídeo utilizando un tamaño objetivo comparable.

Por ejemplo:

```text
H.264
VP9
AV1
```

Compara:

```text
tamaño
bitrate
tiempo de codificación
CPU
calidad visual
compatibilidad
```

> 💡 La práctica es experimental: no existe una única respuesta válida para
> todos los equipos y contenidos.

---

# 🧮 57. Estimar ancho de banda

Si tenemos:

```text
bitrate = 4 Mbit/s
clientes = 20
```

aproximación:

```text
4 × 20 = 80 Mbit/s
```

Sin contar overhead ni otros consumos.

Con:

```text
100 clientes
```

serían aproximadamente:

```text
400 Mbit/s
```

Esto explica por qué un servicio multimedia escala de forma diferente a una
web con ficheros pequeños.

---

# 🧪 58. PRÁCTICA 8.14 — Capacidad del servidor

Calcula el ancho de banda necesario para:

```text
100 clientes
5 Mbit/s por cliente
```

Después repite:

```text
500 clientes
5 Mbit/s
```

Y:

```text
1000 clientes
5 Mbit/s
```

Analiza:

```text
NIC
switch
router
servidor
CPU
CDN
```

---

# 📡 59. Unicast y multicast

## Unicast

Cada cliente recibe su flujo:

```text
       ┌── C1
       │
SERVER ├── C2
       │
       └── C3
```

El servidor puede tener que enviar varias copias.

## Multicast

Conceptualmente:

```text
SERVER
   │
   ▼
MULTICAST
 ┌─┼─┐
 ▼ ▼ ▼
C1 C2 C3
```

La red puede replicar el tráfico donde sea necesario.

---

# ⚠️ 60. Multicast en Internet

Multicast no equivale automáticamente a:

```text
«streaming eficiente en Internet»
```

Su disponibilidad depende de:

```text
red
routers
protocolos
operador
arquitectura
```

Para el laboratorio se estudiará principalmente como concepto.

---

# 🎙️ 61. VoIP

VoIP significa:

```text
Voice over IP
```

Consiste en transportar comunicaciones de voz sobre redes IP.

Arquitectura simplificada:

```text
TELÉFONO
   │
   ▼
RED IP
   │
   ▼
SISTEMA VoIP
   │
   ▼
OTRO TELÉFONO
```

---

# 📞 62. Telefonía tradicional frente a VoIP

| Aspecto | Telefonía tradicional | VoIP |
|---|---|---|
| Transporte | Redes telefónicas | IP |
| Señalización | Tecnologías PSTN/RTC | SIP u otras |
| Media | Circuito/red telefónica | RTP normalmente |
| Infraestructura | Red específica | Infraestructura IP |
| Integración | Más específica | Alta integración con datos |

---

# 📡 63. SIP

SIP se utiliza para señalización.

Permite operaciones conceptuales como:

```text
REGISTER
INVITE
RINGING
200 OK
ACK
BYE
```

Ejemplo:

```text
A ── INVITE ──► B
A ◄─ 180 ───── B
A ◄─ 200 ───── B
A ── ACK ─────► B
       │
       ▼
      RTP
       │
       ▼
      VOZ
```

---

# 🎧 64. RTP

RTP se utiliza para transportar medios en tiempo real.

```text
SIP
 │
 └── establece/controla sesión

RTP
 │
 └── transporta audio/vídeo
```

No deben confundirse:

```text
SIP ≠ RTP
```

---

# ⏱️ 65. Jitter

El jitter es la variación del tiempo de llegada de paquetes.

Ejemplo ideal:

```text
10 ms
10 ms
10 ms
10 ms
```

Con jitter:

```text
10 ms
18 ms
7 ms
25 ms
12 ms
```

El receptor puede utilizar un:

```text
jitter buffer
```

para suavizar esas variaciones.

---

# 🧪 66. PRÁCTICA 8.15 — Analizar RTP

Con una captura autorizada de laboratorio:

```text
Wireshark
```

Filtra:

```text
rtp
```

Observa:

```text
Sequence Number
Timestamp
SSRC
Payload Type
```

Relaciona:

```text
paquete
   ↓
secuencia
   ↓
jitter
   ↓
calidad percibida
```

---

# 🎥 67. Videoconferencia

Una videoconferencia añade:

```text
audio
+
vídeo
+
señalización
+
sincronización
+
control
```

Arquitectura:

```text
Cámara ──┐
         ├──► cliente ───► red ───► cliente
Micrófono┘
```

---

# 🌐 68. WebRTC

WebRTC permite comunicación multimedia interactiva desde aplicaciones
compatibles, especialmente navegadores.

Conceptualmente:

```text
NAVEGADOR A
    │
    │ señalización
    ▼
SERVIDOR
    │
    │ establecimiento
    ▼
NAVEGADOR B
    │
    └──── audio/vídeo ────►
```

En escenarios reales intervienen mecanismos de establecimiento de conectividad
y servidores auxiliares cuando es necesario.

---

# 🧪 69. PRÁCTICA 8.16 — Videoconferencia

Utiliza una herramienta de videoconferencia autorizada por el centro.

Identifica:

```text
micrófono
cámara
codec
resolución
FPS
bitrate
latencia
jitter
```

Después documenta:

```text
cliente
servidor
señalización
medios
red
```

---

# 🧪 70. PRÁCTICA 8.17 — Red degradada

Simula o provoca en un entorno controlado:

```text
latencia
pérdidas
ancho de banda limitado
```

Observa:

```text
audio
vídeo
buffering
pixelación
saltos
desincronización
```

### Objetivo

Relacionar:

```text
problema de red
      ↓
efecto multimedia
```

---

# 🔍 71. Diagnóstico sistemático

Cuando un vídeo no reproduce:

```text
                 ❌ VÍDEO NO FUNCIONA
                          │
                          ▼
                    ¿DNS resuelve?
                     /          \
                   NO            SÍ
                   │              │
                  DNS             ▼
                           ¿TCP conecta?
                            /         \
                          NO           SÍ
                          │             │
                       firewall         ▼
                                 ¿HTTP/RTMP/HLS?
                                  /           \
                                NO             SÍ
                                │               │
                             servidor           ▼
                                           ¿Códec?
                                            /   \
                                          NO     SÍ
                                          │       │
                                      transcodificar
                                                  ▼
                                             ¿bitrate?
                                              /   \
                                            NO     SÍ
                                            │       │
                                          red      ▼
                                                 cliente
```

---

# 🩺 72. Herramientas de diagnóstico

## DNS

```bash
dig video.asir.test
```

## TCP

```bash
nc -vz video.asir.test 1935
nc -vz video.asir.test 80
```

## HTTP

```bash
curl -I http://video.asir.test/
```

## Puertos

```bash
ss -ltnp
```

## Logs

```bash
journalctl -u nginx
journalctl -u icecast2
```

## Captura

```bash
sudo tcpdump -ni any
```

## Multimedia

```bash
ffprobe video.mp4
```

---

# 🧪 73. PRÁCTICA 8.18 — Diagnóstico completo

Síntoma:

> VLC no reproduce el directo.

Realiza obligatoriamente:

```text
1. dig
2. ping
3. nc
4. ss
5. systemctl
6. logs
7. curl
8. ffprobe
9. captura
```

No soluciones el problema «a ciegas».

Para cada paso:

```text
PRUEBA
  ↓
RESULTADO
  ↓
HIPÓTESIS
  ↓
SIGUIENTE PRUEBA
```

---

# 🔐 74. Seguridad multimedia

Un servidor multimedia puede ser abusado.

Riesgos:

```text
stream no autorizado
consumo masivo de ancho de banda
credenciales expuestas
contenido no autorizado
abuso del servidor
denegación de servicio
```

Medidas:

```text
☑ autenticación
☑ límites
☑ firewall
☑ TLS cuando proceda
☑ control de publicación
☑ logs
☑ monitorización
☑ actualización
```

---

# 🛡️ 75. No publicar secretos

Nunca subas al repositorio:

```text
stream keys
passwords
private keys
tokens
credenciales
```

Utiliza:

```text
.env
variables de entorno
secret managers
ficheros fuera de Git
```

y:

```gitignore
.env
*.key
*.pem
secrets/
```

---

# 🧪 76. PRÁCTICA 8.19 — Git seguro

Crea:

```text
.env.example
```

Ejemplo:

```text
ICECAST_SOURCE_PASSWORD=CAMBIAR
RTMP_STREAM_KEY=CAMBIAR
```

Pero nunca:

```text
.env
```

con las credenciales reales.

---

# 📊 77. Comparativa de tecnologías

| Tecnología | Función | Uso principal en la UT |
|---|---|---|
| Icecast | Servidor audio | ⭐ Laboratorio |
| FFmpeg | Codificación/transcodificación | ⭐ Laboratorio |
| VLC | Cliente/reproductor | ⭐ Laboratorio |
| Nginx | HTTP | ⭐ Laboratorio |
| nginx-rtmp-module | RTMP/HLS | ⭐ Laboratorio |
| HLS | Distribución HTTP | ⭐ Laboratorio |
| RTMP | Ingest/directo | ⭐ Laboratorio |
| RTP | Transporte multimedia tiempo real | Conceptual/análisis |
| SIP | Señalización VoIP | Conceptual |
| WebRTC | Multimedia interactiva | Videoconferencia |

---

# 🧪 78. PRÁCTICA 8.20 — Proyecto integrado

Construye:

```text
                    DNS
                     │
          ┌──────────┴──────────┐
          │                     │
      radio.asir.test       video.asir.test
          │                     │
          ▼                     ▼
       Icecast              Nginx/RTMP
          │                     │
          │                     ▼
          │                    HLS
          │                     │
          ▼                     ▼
         VLC                  VLC/Web
```

### Audio

```text
FFmpeg → Icecast → VLC
```

### Vídeo

```text
FFmpeg → RTMP → Nginx → HLS → VLC
```

---

# 🏆 79. Reto profesional

## «La radio funciona, el vídeo no»

Dispones de:

```text
radio.asir.test
video.asir.test
```

Radio:

```text
✔ DNS
✔ TCP/8000
✔ Icecast
✔ VLC
```

Vídeo:

```text
✔ DNS
✔ TCP/1935
❌ VLC
```

Debes determinar si el fallo está en:

```text
RTMP
Nginx
FFmpeg
HLS
HTTP
playlist
segmentos
codec
cliente
```

### Evidencias obligatorias

```bash
dig
ss
nc
systemctl
journalctl
curl
ffprobe
tcpdump
```

---

# 🏆 80. Reto profesional 2 — Escalabilidad

Una empresa quiere distribuir:

```text
vídeo 1080p
8 Mbit/s
500 usuarios simultáneos
```

Calcula el tráfico aproximado necesario.

Después analiza:

```text
servidor
NIC
switch
router
firewall
Internet
CDN
```

Explica qué elementos se convierten en posibles cuellos de botella.

---

# 🧠 81. Errores conceptuales frecuentes

### ❌ «MP4 es un códec»

No.

```text
MP4 = contenedor
```

### ❌ «H.264 es un formato contenedor»

No.

```text
H.264 = códec de vídeo
```

### ❌ «RTMP y HLS son lo mismo»

No.

```text
RTMP → protocolo
HLS  → mecanismo de distribución HTTP mediante playlist/segmentos
```

### ❌ «Más bitrate siempre es mejor»

No necesariamente.

### ❌ «Si hay ping, el streaming funciona»

No.

`ping` no demuestra:

```text
puerto
servicio
protocolo
codec
buffer
```

---

# 🧪 82. Práctica de integración con Packet Tracer

Packet Tracer no sustituye a Icecast, Nginx RTMP o FFmpeg.

Su función aquí es representar:

```text
cliente
   │
switch
   │
router
   │
servidor
```

y estudiar:

```text
IP
TCP
puertos
rutas
```

La implementación multimedia real se realiza en:

```text
VirtualBox + Ubuntu 26.04 Server
```

---

# 🧪 83. Topología Packet Tracer

```text
                  ROUTER
                 /      \
                /        \
              SW1        SERVER
             /   \
           PC1   PC2
```

Configura:

```text
192.168.100.0/24
```

Comprueba:

```text
ping
```

Después relaciona:

```text
IP
 ↓
TCP
 ↓
puerto
 ↓
servicio multimedia
```

---

# 🐧 84. WSL2 como estación de análisis

WSL2 proporciona herramientas especialmente útiles:

```bash
sudo apt update
sudo apt install \
  ffmpeg \
  vlc \
  dnsutils \
  netcat-openbsd \
  tcpdump \
  curl
```

Herramientas:

```text
ffprobe → metadatos multimedia
ffmpeg  → conversión/codificación
curl    → HTTP
nc      → TCP
dig     → DNS
tcpdump → captura
```

---

# 🖥️ 85. VirtualBox + Ubuntu 26.04 Server

Servidor recomendado:

```text
hostname:
media.asir.test
```

Servicios:

```text
DNS
Icecast
Nginx
RTMP
HLS
```

Red:

```text
192.168.100.10
```

Arquitectura:

```text
                 media.asir.test
                       │
          ┌────────────┼────────────┐
          │            │            │
       :8000         :80         :1935
       Icecast       HTTP        RTMP
          │            │            │
          │            │            ▼
          │            │          HLS
          │            │            │
          └────────────┴────────────┘
                       │
                      VLC
```

---

# 🧪 86. PRÁCTICA 8.21 — Monitorización

Comprueba:

```bash
sudo ss -ltnp
```

Filtra:

```bash
sudo ss -ltnp | grep -E ':80|:8000|:1935'
```

CPU:

```bash
top
```

Memoria:

```bash
free -h
```

Red:

```bash
ip -s link
```

Procesos:

```bash
ps aux | grep -E 'ffmpeg|nginx|icecast'
```

---

# 📈 87. Monitorización multimedia

Una infraestructura multimedia debe observar:

```text
CPU
RAM
red
conexiones
bitrate
clientes
latencia
errores
```

En Icecast interesa especialmente:

```text
sources
listeners
mountpoints
```

En Nginx/RTMP:

```text
publish
play
streams
conexiones
errores
```

---

# 🧪 88. PRÁCTICA 8.22 — Captura de tráfico

Audio Icecast:

```bash
sudo tcpdump -ni any port 8000
```

RTMP:

```bash
sudo tcpdump -ni any port 1935
```

HTTP/HLS:

```bash
sudo tcpdump -ni any port 80
```

Relaciona:

```text
puerto
protocolo
flujo
cliente
servidor
```

---

# 🔬 89. ¿Qué ocurre cuando reproducimos?

Ejemplo HLS:

```text
1. DNS
      ↓
2. TCP
      ↓
3. HTTP GET playlist.m3u8
      ↓
4. servidor responde
      ↓
5. cliente solicita segmento
      ↓
6. servidor responde
      ↓
7. cliente almacena en búfer
      ↓
8. decodifica
      ↓
9. reproduce
      ↓
10. solicita siguiente segmento
```

---

# 🧪 90. PRÁCTICA 8.23 — Analizar HLS

Captura:

```text
tcp.port == 80
```

Busca:

```text
.m3u8
```

Después:

```text
.ts
```

o los segmentos utilizados por la implementación.

Explica:

```text
playlist
   ↓
segmento 1
   ↓
segmento 2
   ↓
segmento 3
```

---

# 🔧 91. Transcodificación

Puede ser necesario convertir:

```text
entrada
   ↓
FFmpeg
   ↓
salida
```

Ejemplo:

```bash
ffmpeg \
  -i entrada.mkv \
  -c:v libx264 \
  -c:a aac \
  salida.mp4
```

No confundas:

```text
transcodificación
```

con:

```text
cambio de contenedor sin recodificar
```

---

# 🧪 92. PRÁCTICA 8.24 — Remux frente a transcodificación

### Remux

```bash
ffmpeg -i entrada.mkv -c copy salida.mp4
```

### Transcodificación

```bash
ffmpeg \
  -i entrada.mkv \
  -c:v libx264 \
  -c:a aac \
  salida.mp4
```

Compara:

```text
CPU
tiempo
tamaño
calidad
```

---

# 🧮 93. Almacenamiento

Para vídeo:

```text
tamaño ≈ bitrate × duración
```

Ejemplo:

```text
8 Mbit/s
1 hora
```

Aproximación:

```text
8.000.000 bit/s
× 3600 s
= 28.800.000.000 bits
```

Dividiendo entre 8:

```text
3.600.000.000 bytes
```

aproximadamente:

```text
3,6 GB
```

sin considerar audio adicional, contenedor y otros factores.

---

# 🧪 94. PRÁCTICA 8.25 — Planificar almacenamiento

Calcula cuánto espacio necesitas para:

```text
10 vídeos
1 hora cada uno
8 Mbit/s
```

Después compara con:

```text
4 Mbit/s
```

y:

```text
12 Mbit/s
```

Explica la relación entre:

```text
calidad
bitrate
almacenamiento
ancho de banda
```

---

# 🛡️ 95. Checklist de seguridad

```text
☐ firewall activo
☐ solo puertos necesarios
☐ contraseñas robustas
☐ stream keys protegidas
☐ publicación autenticada
☐ HTTPS para distribución cuando proceda
☐ logs
☐ monitorización
☐ límites de clientes
☐ límites de bitrate
☐ software actualizado
☐ backups
☐ contenido autorizado
```

---

# 📦 96. Estructura del repositorio GitHub

```text
ut8-audio-video/
│
├── README.md
├── 01-formatos-multimedia.md
├── 02-codecs-contenedores.md
├── 03-reproduccion.md
├── 04-streaming.md
├── 05-icecast.md
├── 06-hls.md
├── 07-rtmp.md
├── 08-voip.md
├── 09-videoconferencia.md
├── 10-diagnostico.md
│
├── scripts/
│   ├── media-info.sh
│   └── test-stream.sh
│
├── icecast/
│   └── README.md
│
├── nginx/
│   └── README.md
│
├── packet-tracer/
│   └── README.md
│
└── capturas/
```

---

# ⚠️ 97. Qué NO debe entrar en Git

```text
.env
*.key
*.pem
stream-key.txt
passwords.txt
credenciales/
```

Incluye:

```text
.env.example
```

pero no las credenciales reales.

---

# 🏁 98. Proyecto final

## «Campus Multimedia ASIR»

Construye una pequeña infraestructura multimedia:

```text
                       DNS
                        │
             ┌──────────┴──────────┐
             │                     │
          radio                  video
             │                     │
          Icecast               Nginx
             │                  RTMP/HLS
             │                     │
             └──────────┬──────────┘
                        │
                       VLC
```

Debe proporcionar:

### 🎧 Radio

```text
/radio.mp3
```

### 📺 Vídeo

```text
/hls/ut8.m3u8
```

### 🌐 Podcast

```text
/feed.xml
```

### 📞 VoIP

Documento técnico explicando:

```text
SIP
RTP
jitter
QoS
```

### 🎥 Videoconferencia

Documento técnico explicando:

```text
WebRTC
señalización
audio
vídeo
red
```

---

# 🧪 99. Entrega del proyecto

La documentación debe contener:

```text
1. Arquitectura
2. Direccionamiento
3. DNS
4. Instalación
5. Configuración
6. Pruebas
7. Capturas
8. Logs
9. Seguridad
10. Diagnóstico
11. Conclusiones
```

Cada prueba debe seguir:

```text
OBJETIVO
   ↓
CONFIGURACIÓN
   ↓
COMANDO
   ↓
RESULTADO
   ↓
EVIDENCIA
   ↓
CONCLUSIÓN
```

---

# 📚 100. Resumen

```text
                       MULTIMEDIA
                           │
           ┌───────────────┼────────────────┐
           │               │                │
         AUDIO            VÍDEO          TIEMPO REAL
           │               │                │
        códecs          códecs            RTP
           │               │                │
       Icecast        RTMP/HLS           SIP
           │               │                │
           └───────────────┼────────────────┘
                           │
                         CLIENTE
                           │
                          VLC
```

Ideas fundamentales:

1. El audio y el vídeo digitales son datos.
2. El muestreo convierte una señal continua en muestras discretas.
3. La profundidad de bits determina niveles de cuantificación.
4. El bitrate determina cantidad de datos por unidad de tiempo.
5. Un códec codifica/decodifica contenido.
6. Un contenedor agrupa flujos y metadatos.
7. MP4 no es un códec.
8. H.264 no es un contenedor.
9. Streaming permite reproducir mientras se reciben datos.
10. El búfer ayuda a absorber variaciones de red.
11. VOD y live tienen necesidades diferentes.
12. Icecast es especialmente adecuado para radio/streaming de audio.
13. Un mountpoint identifica un stream en Icecast.
14. FFmpeg permite inspeccionar, convertir y generar streams.
15. RTMP y HLS cumplen funciones diferentes.
16. RTMP puede utilizarse como entrada de un servidor multimedia.
17. HLS utiliza playlists y segmentos sobre HTTP.
18. VLC puede utilizarse como cliente multimedia.
19. SIP se utiliza para señalización VoIP.
20. RTP transporta medios en tiempo real.
21. Jitter es variación del tiempo de llegada.
22. Videoconferencia combina señalización y medios.
23. WebRTC está orientado a comunicación multimedia interactiva.
24. El ancho de banda debe dimensionarse según bitrate y número de clientes.
25. Los problemas multimedia deben diagnosticarse con evidencia.

---

# ❓ 101. Autoevaluación

1. ¿Qué es el muestreo de una señal de audio?
2. ¿Qué representa la profundidad de bits?
3. ¿Qué es un códec?
4. ¿Qué es un contenedor?
5. ¿Es MP4 un códec?
6. ¿Es H.264 un contenedor?
7. ¿Qué diferencia existe entre MP3 y WAV/PCM?
8. ¿Qué significa bitrate?
9. ¿Qué significa FPS?
10. ¿Qué es la resolución de un vídeo?
11. ¿Qué es streaming?
12. ¿Qué función realiza el búfer?
13. ¿Qué diferencia existe entre VOD y live?
14. ¿Qué componentes forman un sistema de streaming?
15. ¿Qué es Icecast?
16. ¿Qué es un mountpoint?
17. ¿Para qué sirve FFmpeg?
18. ¿Qué es RTMP?
19. ¿Qué es HLS?
20. ¿Qué diferencia existe entre RTMP y HLS?
21. ¿Qué es un podcast?
22. ¿Qué es VoIP?
23. ¿Qué función tiene SIP?
24. ¿Qué función tiene RTP?
25. ¿Qué es jitter?
26. ¿Qué problemas puede provocar una red con pérdidas?
27. ¿Qué comando permite inspeccionar un vídeo con FFmpeg?
28. ¿Qué comando permite comprobar si TCP/1935 está accesible?
29. ¿Qué herramienta permite reproducir un stream desde una URL?
30. ¿Por qué no debemos guardar una stream key en GitHub?

---

# ✅ 102. Respuestas de la autoevaluación

### 1.
El muestreo consiste en medir la amplitud de una señal a intervalos regulares.

### 2.
Indica cuántos bits se utilizan para representar cada muestra y, por tanto,
cuántos niveles de amplitud pueden representarse.

### 3.
Un códec es un mecanismo para codificar y decodificar audio o vídeo.

### 4.
Un contenedor organiza uno o varios flujos multimedia y metadatos.

### 5.
No. MP4 es un formato contenedor.

### 6.
No. H.264 es un códec de vídeo.

### 7.
WAV puede contener audio PCM sin compresión; MP3 utiliza compresión con
pérdida.

### 8.
Cantidad de bits transmitidos o utilizados por unidad de tiempo, normalmente
bit/s.

### 9.
Frames Per Second: número de imágenes de vídeo mostradas por segundo.

### 10.
Normalmente, el número de píxeles de ancho y alto del vídeo.

### 11.
Técnica de distribución que permite reproducir contenido mientras se recibe.

### 12.
Almacena temporalmente datos para compensar variaciones en la llegada de
datos.

### 13.
VOD distribuye contenido almacenado bajo demanda; live distribuye contenido
generado en directo.

### 14.
Fuente, codificador, servidor, red y cliente/reproductor, además de los
componentes auxiliares que requiera la arquitectura.

### 15.
Un servidor de streaming utilizado especialmente para distribución de audio.

### 16.
Un identificador de un stream dentro de Icecast.

### 17.
Permite inspeccionar, convertir, codificar, decodificar y procesar contenido
multimedia, además de participar en flujos de streaming.

### 18.
Un protocolo utilizado para streaming y especialmente habitual como mecanismo
de ingest hacia servidores multimedia.

### 19.
HTTP Live Streaming: mecanismo de distribución multimedia mediante playlists y
segmentos sobre HTTP.

### 20.
RTMP y HLS son tecnologías diferentes: RTMP se utiliza frecuentemente para
ingest/directo, mientras HLS distribuye mediante HTTP y segmentos.

### 21.
Sistema de distribución y suscripción de episodios multimedia mediante feeds.

### 22.
Voice over IP: transmisión de comunicaciones de voz sobre redes IP.

### 23.
SIP realiza señalización y establecimiento/control de sesiones multimedia.

### 24.
RTP transporta datos multimedia en tiempo real.

### 25.
Variación en el tiempo de llegada de los paquetes.

### 26.
Pérdidas pueden producir cortes, degradación, artefactos, pérdida de
sincronización o interrupciones.

### 27.
Por ejemplo:

```bash
ffprobe video.mp4
```

### 28.
Por ejemplo:

```bash
nc -vz servidor 1935
```

### 29.
VLC, mediante la opción de abrir un flujo de red.

### 30.
Porque una stream key es una credencial que permite publicar contenido en el
servidor. Si se expone, otra persona podría utilizarla.

---

# 📝 103. Test de repaso

### 1. ¿Qué es H.264?

a) Contenedor  
b) Códec de vídeo  
c) Protocolo DNS  
d) Servidor multimedia

### 2. ¿Qué es MP4?

a) Códec  
b) Contenedor  
c) Protocolo  
d) Servidor

### 3. ¿Qué herramienta utilizamos para inspeccionar streams multimedia?

a) dig  
b) ffprobe  
c) ssh  
d) nslookup

### 4. ¿Qué software utilizamos como servidor de audio?

a) Apache  
b) Icecast  
c) Dovecot  
d) BIND9

### 5. ¿Qué identifica un mountpoint de Icecast?

a) Una interfaz de red  
b) Un stream  
c) Un DNS  
d) Una ruta IP

### 6. ¿Qué protocolo se utiliza habitualmente para ingest hacia Nginx RTMP?

a) FTP  
b) RTMP  
c) SMTP  
d) IMAP

### 7. ¿Qué utiliza HLS?

a) FTP + ZIP  
b) HTTP + playlist/segmentos  
c) SMTP + MIME  
d) SSH + SFTP

### 8. ¿Qué herramienta puede reproducir una URL multimedia?

a) VLC  
b) dig  
c) ss  
d) tcpdump

### 9. ¿Qué protocolo se asocia principalmente con señalización VoIP?

a) RTP  
b) SIP  
c) HLS  
d) RTMP

### 10. ¿Qué protocolo transporta habitualmente los medios en VoIP?

a) RTP  
b) SIP  
c) DNS  
d) HTTP

### 11. ¿Qué es jitter?

a) Pérdida de resolución  
b) Variación del tiempo de llegada  
c) Compresión de vídeo  
d) Un códec

### 12. ¿Qué componente ayuda a absorber variaciones de red?

a) DNS  
b) búfer  
c) MX  
d) switch

### 13. ¿Qué significa VOD?

a) Video Over DNS  
b) Video On Demand  
c) Voice On Data  
d) Video Open Distribution

### 14. ¿Qué tecnología es especialmente adecuada para radio por Internet?

a) Icecast  
b) Dovecot  
c) Postfix  
d) BIND9

### 15. ¿Qué componente no debe confundirse con un códec?

a) contenedor  
b) bit  
c) FPS  
d) bitrate

---

# ✅ 104. Respuestas del test

| Nº | Respuesta |
|---:|:---:|
| 1 | **b** |
| 2 | **b** |
| 3 | **b** |
| 4 | **b** |
| 5 | **b** |
| 6 | **b** |
| 7 | **b** |
| 8 | **a** |
| 9 | **b** |
| 10 | **a** |
| 11 | **b** |
| 12 | **b** |
| 13 | **b** |
| 14 | **a** |
| 15 | **a** |

---

# 🔄 105. Correspondencia conceptual

| Contenido de la unidad | Actualización práctica |
|---|---|
| Formatos multimedia | MP3, AAC, Opus, FLAC, MP4, WebM, MKV |
| Códecs | H.264, H.265, VP9, AV1, AAC, Opus |
| Reproducción | VLC + navegador |
| Streaming | VOD + Live |
| Servidores de audio | **Icecast** |
| Codificación | **FFmpeg** |
| Streaming vídeo | **Nginx + RTMP** |
| Distribución vídeo | **HLS** |
| Podcast | RSS + enclosure |
| VoIP | SIP + RTP |
| Videoconferencia | WebRTC + arquitectura multimedia |
| Análisis | Wireshark/tcpdump |
| Cliente de pruebas | WSL2 |
| Servidor | **VirtualBox + Ubuntu 26.04 Server** |
| Red/simulación | Cisco Packet Tracer |

---

# 🧪 106. Secuencia recomendada de laboratorio

```text
UT3 · DNS
   │
   ▼
media.asir.test
   │
   ├──────────────────────┐
   ▼                      ▼
🎧 AUDIO                 📺 VÍDEO
   │                      │
   ▼                      ▼
FFmpeg                  FFmpeg
   │                      │
   ▼                      ▼
Icecast                  RTMP
   │                      │
   ▼                      ▼
VLC                     Nginx
                          │
                          ▼
                         HLS
                          │
                          ▼
                       VLC/Web
```

Después:

```text
                 MULTIMEDIA
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
      Podcast       VoIP    Videoconferencia
        │            │            │
       RSS          SIP          WebRTC
                     │
                    RTP
```

---

# 🏁 107. Resultado esperado

Al finalizar esta UT, el alumno debería ser capaz de enfrentarse a:

> **«Tengo un servidor Ubuntu, un fichero multimedia y varios clientes. Debo
> decidir qué códec y contenedor utilizar, publicar el contenido mediante el
> servicio adecuado, permitir que los clientes lo reproduzcan y diagnosticar
> cualquier fallo de red, servidor o formato.»**

El procedimiento profesional:

```text
REQUISITOS
    ↓
FORMATO
    ↓
CÓDEC
    ↓
BITRATE
    ↓
SERVIDOR
    ↓
PROTOCOLO
    ↓
DNS
    ↓
TCP/UDP
    ↓
CLIENTE
    ↓
BÚFER
    ↓
DECODIFICACIÓN
    ↓
REPRODUCCIÓN
    ↓
MONITORIZACIÓN
    ↓
DIAGNÓSTICO
```

---

# 📖 108. Referencias

### Estructura curricular

La unidad de **Servicios de audio y vídeo** incluye como bloques principales
formatos multimedia, herramientas de reproducción, streaming, distribución y
suscripción, VoIP y videoconferencia. citeturn0search11turn0search2

### Icecast

La documentación de Icecast describe los mountpoints, fuentes, clientes,
límites y configuración específica de cada stream. citeturn1search4turn1search5

### Nginx / RTMP

El módulo RTMP de Nginx proporciona funcionalidades para streaming RTMP y
puede trabajar con HLS y DASH según la implementación utilizada.
citeturn2search0turn2search6

### HLS

La documentación de Nginx describe HLS mediante playlists `.m3u8` y
segmentos, y especifica los formatos/códecs compatibles con su módulo HLS
concreto. citeturn2search1

---

<div align="center">

# 🎧📺 UT8 · SERVICIOS DE AUDIO Y VÍDEO 📺🎧

```text
                 🎵 AUDIO
                    │
                  CÓDEC
                    │
                 ICECAST
                    │
                    ▼
                   VLC

                 🎬 VÍDEO
                    │
                  CÓDEC
                    │
                  RTMP
                    │
                 NGINX
                    │
                  HLS
                    │
                    ▼
                 VLC / WEB

             📞 SIP + RTP · 🎥 WebRTC
```

**CODIFICAR · TRANSMITIR · REPRODUCIR · DIAGNOSTICAR**

**FIN DE LA UT8**

</div>


---

# 🐳 Laboratorio Docker Compose · Anexo IV

Los pipelines multimedia reproducibles están en [`docker/ut8`](docker/ut8/):

```text
FFmpeg → Icecast
FFmpeg → RTMP → Nginx → HLS
```

Ejecutar:

```bash
cd docker/ut8
docker compose up -d
curl http://localhost:8000/
curl http://localhost:8088/hls/ut8.m3u8
```

Las fuentes se generan con FFmpeg (`lavfi`), por lo que no es necesario copiar archivos multimedia al repositorio.
