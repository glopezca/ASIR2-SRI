# UT3 · Docker Compose

BIND9 se ejecuta en primer plano dentro del contenedor y la zona `asir.test` se valida durante la construcción de la imagen.

```bash
docker compose up -d
docker compose exec client dig @dns www.asir.test A +short
docker compose exec client dig @dns asir.test SOA
docker compose exec client dig @dns asir.test NS
```

El puerto 53 del contenedor se publica como `1053` en el host para evitar exigir privilegios y conflictos con un resolver local.
