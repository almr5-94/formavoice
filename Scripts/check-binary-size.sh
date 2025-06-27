# FilePath: Scripts/check-binary-size.sh
# Fails the CI pipeline if the .ipa payload (minus ODR packs) exceeds Apple’s
# 200 MB over-cellular limit. :contentReference[oaicite:6]{index=6}

#!/usr/bin/env bash
set -e
IPA="$1"           # Path supplied by CI workflow.
LIMIT=$((200*1024*1024))
SIZE=$(stat -f%z "$IPA")
if [[ $SIZE -gt $LIMIT ]]; then
  echo "✖️ Build size $SIZE bytes exceeds 200 MB OTA cap"
  exit 1
fi
echo "✅ Size check passed: $SIZE bytes"
