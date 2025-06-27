# FilePath: Scripts/run-instruments.sh
# One-liner wrapper: launches Instruments with the pre-baked MemoryProfile.plan
# so any dev (or CI node) can replicate the “All Allocations” + “Leaks” run
# described in Apple docs and forums. :contentReference[oaicite:9]{index=9}
#
# Usage:  ./run-instruments.sh  com.abdallah.FormaVoice
# Requires Xcode 16 CLT and Instruments CLI extras installed.

#!/usr/bin/env bash
set -euo pipefail
BUNDLEID="$1"
PLAN="Instruments/MemoryProfile.plan"
echo "📈  Launching Instruments for $BUNDLEID using $PLAN …"
/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/MacOS/Instruments \
  -l "$PLAN" \
  -t "All Allocations" \
  -p "$BUNDLEID"
