// FilePath: Scripts/clean-cache.sh
// Removes DerivedData and Xcode’s module-cache to ensure reproducible CI builds.
// Usage: `bash Scripts/clean-cache.sh`

#!/usr/bin/env bash
set -e
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Developer/Xcode/ModuleCache.noindex/*
echo "🧹  Xcode caches purged."
