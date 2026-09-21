# UT6 · Docker Compose

Se utiliza `docker-mailserver` como empaquetado didáctico de **Postfix + Dovecot**. La imagen integra ambos componentes y permite estudiar SMTP, submission, IMAP y POP3 sin construir manualmente un MTA y un servidor IMAP/POP3 desde cero.

La versión está fijada a `15.1.0` para evitar el comportamiento cambiante de `latest`.

## Arranque

```bash
docker compose up -d
docker compose ps
```

## Crear una cuenta

```bash
docker compose exec mailserver setup email add alumno@asir.test 'ASIR-Lab-2026!'
```

## Comprobaciones

```bash
openssl s_client -connect localhost:2993
openssl s_client -connect localhost:2995
openssl s_client -connect localhost:2587 -starttls smtp
```

Los puertos del host se desplazan para evitar conflictos con servicios locales.
