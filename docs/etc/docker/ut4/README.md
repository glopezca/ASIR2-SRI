# UT4 · Docker Compose

El contenedor proporciona **FTP/FTP pasivo** y **SSH/SFTP** para comparar ambos modelos.

```bash
docker compose up -d
docker compose exec client nc -vz fileserver 21
docker compose exec client nc -vz fileserver 22
docker compose exec client sftp -P 22 alumno@fileserver
```

Contraseña de laboratorio: `ASIR-Lab-2026!`.

No utilizar esta contraseña ni esta configuración fuera del laboratorio.
