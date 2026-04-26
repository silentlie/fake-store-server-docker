#!/usr/bin/env bash
set -euo pipefail

git pull
git submodule update --init --recursive --remote

if [[ -n "$(git status --porcelain)" ]]; then
  git add fake-store-server
  git commit -m "chore: update fake-store-server submodule"
  git push
fi

docker compose down
docker compose build --no-cache
docker compose up