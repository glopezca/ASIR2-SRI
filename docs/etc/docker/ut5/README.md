# UT5 · Docker Compose

El stack demuestra la práctica de **Nginx como reverse proxy delante de Apache**.

```bash
docker compose up -d
docker compose run --rm client
curl http://localhost:8080/
```

La separación entre Apache y Nginx hace visible la arquitectura `cliente → reverse proxy → servidor web` de la UT5.
