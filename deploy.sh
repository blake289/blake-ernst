#!/usr/bin/env bash
# Deploy guard — keeps /1, /2, /3 from overwriting each other across terminals.
# Usage: ./deploy.sh 1   (or 2, or 3)
set -euo pipefail
cd "$(dirname "$0")"

SUBDIR="${1:-}"
if [[ -z "$SUBDIR" ]]; then
  echo "usage: ./deploy.sh <subdir>   e.g. ./deploy.sh 1"
  exit 1
fi
if [[ ! -d "$SUBDIR" ]]; then
  echo "no local $SUBDIR/ dir — build it first"
  exit 1
fi

echo "==> pulling other terminals' work"
git fetch origin main
git pull --rebase origin main

echo "==> committing /$SUBDIR/"
git add "$SUBDIR"
git diff --cached --quiet || git commit -m "deploy: update /$SUBDIR/"

echo "==> pushing so other terminals can pull"
git push origin main

echo "==> deploying full tree to vercel"
vercel deploy --prod --yes
