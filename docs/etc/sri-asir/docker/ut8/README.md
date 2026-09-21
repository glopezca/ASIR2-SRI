# UT8 · Docker Compose

El stack demuestra los dos flujos principales de la UT8:

```text
FFmpeg → Icecast → cliente
FFmpeg → RTMP → Nginx → HLS → cliente
```

Arranque:

```bash
docker compose up -d
```

Comprobaciones:

```bash
curl http://localhost:8000/
curl http://localhost:8088/
curl http://localhost:8088/hls/ut8.m3u8
```

El contenido multimedia se genera mediante `lavfi`, por lo que no se necesita ningún archivo de audio/vídeo externo para validar el pipeline.
