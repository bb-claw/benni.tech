#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "usage: dump_pub.sh <file>" >&2
    exit 1
fi

SRC="$1"

if [[ ! -f "$SRC" ]]; then
    echo "error: not a file: $SRC" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORIGINAL="$(basename "$SRC")"
PREFIX="$(date +%Y-%m-%d)-$(openssl rand -hex 8)"
DEST="$SCRIPT_DIR/pub/${PREFIX}-${ORIGINAL}"

cp "$SRC" "$DEST"
echo "https://benni.tech/pub/${PREFIX}-${ORIGINAL}"
