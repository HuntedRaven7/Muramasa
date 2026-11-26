#!/usr/bin/env bash
# Generate a development Secure Boot keypair. The private key is never committed;
# the public certificate is staged into the image so users can enroll it.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRIVATE="${ROOT}/files/boot-keys/private"
PUBLIC="${ROOT}/files/boot-keys/public"

mkdir -p "$PRIVATE" "$PUBLIC"

if [ -f "$PRIVATE/secure-boot.key" ]; then
  echo "key already exists at $PRIVATE/secure-boot.key" >&2
  exit 1
fi

openssl req -new -x509 -newkey rsa:2048 -nodes \
  -keyout "$PRIVATE/secure-boot.key" \
  -out "$PUBLIC/secure-boot.crt" \
  -days 3650 -subj "/CN=Muramasa Secure Boot Development Key/"

chmod 600 "$PRIVATE/secure-boot.key"
chmod 644 "$PUBLIC/secure-boot.crt"

echo "Generated development key:"
echo "  private: $PRIVATE/secure-boot.key (gitignored)"
echo "  public:  $PUBLIC/secure-boot.crt (committed into the image)"
