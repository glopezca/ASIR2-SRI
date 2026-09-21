# UT1 · Docker Compose

Este laboratorio reproduce con Docker Compose la parte ejecutable de cliente/servidor, direccionamiento lógico, puertos y diagnóstico TCP/IP.

## Ejecutar

```bash
docker compose up -d

docker compose exec client ping -c 3 server
docker compose exec client nc -vz server 8080
docker compose exec client curl http://server:8080/
docker compose exec client ip addr
docker compose exec client ip route
```

La topología de routers, NAT/PAT y simulación Cisco sigue realizándose con Packet Tracer; Docker no pretende sustituir esa simulación L2/L3.
