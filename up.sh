#!/usr/bin/env bash
set -euo pipefail

git submodule update --init --recursive
docker compose up --build