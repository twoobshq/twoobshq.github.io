#!/bin/bash
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source "$REPO_ROOT/.env"

PRIVATE_DIR="$REPO_ROOT/private"
ENCRYPTED_DIR="$REPO_ROOT/public-encrypted"

find "$ENCRYPTED_DIR" -type f -name "*.enc" | while read -r file; do
  rel="${file#$ENCRYPTED_DIR/}"
  rel="${rel%.enc}"
  outfile="$PRIVATE_DIR/$rel"
  mkdir -p "$(dirname "$outfile")"
  openssl enc -d -aes-256-cbc -pbkdf2 -salt -pass env:ENCRYPTION_SECRET -in "$file" -out "$outfile"
done
