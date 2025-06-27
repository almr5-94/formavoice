# FilePath: Scripts/run-swift-format.sh
# Runs Apple’s swift-format (0.50800+) with project-wide defaults
# before each commit (hooked via pre-commit.sh in Response 2).  
# swift-format CLI docs: developer.apple.com/swift (search result).:contentReference[oaicite:2]{index=2}

#!/usr/bin/env bash
swift-format --in-place --recursive Sources Tests
