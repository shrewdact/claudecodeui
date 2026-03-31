#!/bin/sh
set -e

echo "[pre] Removing dangling images..."
docker image prune -f

echo "[docker] Starting containers..."
docker compose up -d "$@"
