#!/usr/bin/env bash
set -euo pipefail

VER=$(date +%Y%m%d)
VERDATE=$(date +%Y-%m-%d)

# Bump CSS version comment
sed -i "s|/\* v: [0-9-]* \*/|/* v: $VERDATE */|" style*.css

# Bump HTML cache-busting query string
find . -name "*.html" -not -path "./.git/*" \
  | xargs sed -i "s|/style\.css?v=[0-9]*|/style.css?v=$VER|g"

echo "Version bumped to $VERDATE / $VER"

rsync -av --delete \
  --exclude .git \
  --exclude README.md \
  --exclude LICENSE \
  --exclude deploy.sh \
  ./ server2:/var/www/benni.tech/
