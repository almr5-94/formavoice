#!/usr/bin/env bash

# fetch_models.sh – Fetch optional AI model weights and C++ backends.
# Run once after cloning the repo. Usage:  bash Scripts/fetch_models.sh
# Downloads ~2 GB total. Ensure you have sufficient disk space and bandwidth.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MODELS_DIR="$ROOT_DIR/Resources/Models"
VENDOR_DIR="$ROOT_DIR/Vendor"

mkdir -p "$MODELS_DIR" "$VENDOR_DIR"

# 1. Download Whisper base.en (GGML Q4_K)
WHISPER_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en-q4_k.bin"
WHISPER_DEST="$MODELS_DIR/ggml-base.en-q4_k.bin"
if [[ ! -f "$WHISPER_DEST" ]]; then
  echo "Downloading Whisper model …"
  curl -L "$WHISPER_URL" -o "$WHISPER_DEST"
else
  echo "Whisper model already present – skipping download."
fi

# 2. Download Phi-3-Mini Instruct (Q4_K_M GGUF)
PHI_URL="https://huggingface.co/TheBloke/phi-3-mini-4k-instruct-GGUF/resolve/main/phi-3-mini-4k-instruct-q4_k_m.gguf"
PHI_DEST="$MODELS_DIR/phi-3-mini-instruct-q4_k_m.gguf"
if [[ ! -f "$PHI_DEST" ]]; then
  echo "Downloading Phi-3 model … (≈1.5 GB)"
  curl -L "$PHI_URL" -o "$PHI_DEST"
else
  echo "Phi-3 model already present – skipping download."
fi

# 3. Clone llama.cpp and whisper.cpp backends if missing
if [[ ! -d "$VENDOR_DIR/llama.cpp" ]]; then
  echo "Cloning llama.cpp backend …"
  git clone --depth 1 https://github.com/ggerganov/llama.cpp.git "$VENDOR_DIR/llama.cpp"
fi

if [[ ! -d "$VENDOR_DIR/whisper.cpp" ]]; then
  echo "Cloning whisper.cpp backend …"
  git clone --depth 1 https://github.com/ggerganov/whisper.cpp.git "$VENDOR_DIR/whisper.cpp"
fi

echo "All assets fetched successfully. Remember to run Xcode → Product → Clean Build Folder afterwards so the new resources are picked up." 