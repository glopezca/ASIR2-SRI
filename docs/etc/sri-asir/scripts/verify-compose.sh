#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_ONLY=0
[[ "${1:-}" == "--config-only" ]] && CONFIG_ONLY=1

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker no está disponible en este entorno."
  exit 2
fi

echo "== Docker =="
docker version --format '{{.Server.Version}}'
docker compose version

echo "== Compose config =="
for f in "$ROOT"/docker/ut*/compose.yaml; do
  echo "-- $f"
  docker compose -f "$f" config >/dev/null
done

if [[ "$CONFIG_ONLY" -eq 1 ]]; then
  echo "OK: todas las configuraciones Compose son válidas."
  exit 0
fi

echo "== Smoke tests =="
for n in 1 3 4 5 6 7 8; do
  dir="$ROOT/docker/ut$n"
  echo "### UT$n"
  docker compose -f "$dir/compose.yaml" up -d --build
  case "$n" in
    1) docker compose -f "$dir/compose.yaml" exec -T client ping -c 2 server >/dev/null; docker compose -f "$dir/compose.yaml" exec -T client curl -fsS http://server:8080/ >/dev/null ;;
    3) docker compose -f "$dir/compose.yaml" exec -T client dig @dns www.asir.test +short | grep -q 10.30.0.20 ;;
    4) docker compose -f "$dir/compose.yaml" exec -T client nc -z fileserver 21 ;;
    5) docker compose -f "$dir/compose.yaml" exec -T client curl -fsS http://nginx/ | grep -q 'Apache' ;;
    6) docker compose -f "$dir/compose.yaml" ps --status running | grep -q mailserver ;;
    7) docker compose -f "$dir/compose.yaml" exec -T client nc -z xmpp 5222; docker compose -f "$dir/compose.yaml" exec -T client nc -z irc 6667; docker compose -f "$dir/compose.yaml" exec -T client nc -z nntp 8119 ;;
    8) sleep 8; curl -fsS http://localhost:8000/ >/dev/null; curl -fsS http://localhost:8088/ >/dev/null; curl -fsS http://localhost:8088/hls/ut8.m3u8 >/dev/null ;;
  esac
  docker compose -f "$dir/compose.yaml" down -v
  echo "UT$n OK"
done

echo "OK: smoke tests completados."
