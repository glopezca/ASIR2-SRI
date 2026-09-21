# UT2 · Docker Compose

## Importante: DHCP y Docker

DHCP depende de tráfico broadcast de capa 2. Una red bridge normal de Compose **no es equivalente a una LAN Ethernet real**, por lo que este stack usa Docker para validar y estudiar la configuración de Kea de forma portable.

```bash
docker compose build
docker compose run --rm kea-config
```

Para una práctica DHCP real con clientes, utilice la VM/Packet Tracer de la UT2. En WSL2 Linux puede prepararse un escenario específico con `network_mode: host`, pero no debe asumirse que será portable a Docker Desktop o Codespaces.
