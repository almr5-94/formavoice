# FilePath: Scripts/pre-commit.sh
# Runs SwiftFormat + SwiftLint before allowing commit to proceed.

#!/usr/bin/env bash
swiftformat .
swiftlint --strict
result=$?
if [ $result -ne 0 ]; then
  echo "Lint errors — commit aborted."
  exit 1
fi
