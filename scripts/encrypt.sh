#!/bin/bash
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source "$REPO_ROOT/.env"

PRIVATE_DIR="$REPO_ROOT/private"
ENCRYPTED_DIR="$REPO_ROOT/public-encrypted"

find "$PRIVATE_DIR" -type f ! -name ".gitkeep" | while read -r file; do
  rel="${file#$PRIVATE_DIR/}"
  outfile="$ENCRYPTED_DIR/$rel.enc"
  mkdir -p "$(dirname "$outfile")"
  openssl enc -aes-256-cbc -pbkdf2 -salt -pass env:ENCRYPTION_SECRET -in "$file" -out "$outfile"
done

git add "$ENCRYPTED_DIR"
