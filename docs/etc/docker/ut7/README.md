# UT7 · Docker Compose

El stack despliega los tres servicios prácticos de la unidad:

- XMPP → Prosody → TCP/5222
- IRC → InspIRCd → TCP/6667
- NNTP → INN → TCP/8119 en el laboratorio portable

```bash
docker compose up -d
docker compose exec client nc -vz xmpp 5222
docker compose exec client nc -vz irc 6667
docker compose exec client nc -vz nntp 8119
```

El puerto NNTP se publica como `8119` porque el laboratorio portable no debe depender de privilegios para enlazar TCP/119. Conceptualmente sigue siendo NNTP; la UT explica el puerto tradicional 119.
