#!/bin/bash
set -e
echo "→ Initialising Git sub-modules"
git submodule update --init --recursive
