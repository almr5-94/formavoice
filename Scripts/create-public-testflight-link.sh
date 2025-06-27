# FilePath: Scripts/create-public-testflight-link.sh
# Automates TestFlight public-link generation via App Store Connect API.
# Workflow adapted from CLI guides that wrap `altool` / `appstoreconnect-cli`:contentReference[oaicite:4]{index=4}.
#
# REQUIREMENTS:
#   * FASTLANE_SESSION or App Store Connect JWT set as env var.
#   * ipa already uploaded by previous CI step.
#   * TOOLCHAIN: altool deprecated; we use ASC-CLI for 2025 pipeline.

#!/usr/bin/env bash
set -euo pipefail

APP_ID="$1"        # e.g. 1234567890
GROUP_ID="$2"      # e.g. public-beta-group

echo "🔗 Creating public TestFlight link for app $APP_ID …"
/usr/local/bin/appstoreconnect-cli --json \
  POST "apps/$APP_ID/betaGroups/$GROUP_ID/publicLink" \
  -f data='{"publicLinkEnabled":true,"publicLinkLimit":1000}'

echo "✅ Public link created (fetch in next step)."
