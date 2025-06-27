<!-- FilePath: README.md -->
# FormaVoice – Offline Voice-to-PDF for Professionals

* Speech-to-text uses whisper.cpp with GGML_QK_K 4-bit quantization, keeping the binary under 300 MB while preserving high accuracy. :contentReference[oaicite:9]{index=9}  
* Reasoning & field-filling rely on phi-3-mini.gguf executed by llama.cpp with Metal GPU acceleration for near-real-time latency. :contentReference[oaicite:10]{index=10}  
* Audio pipeline records 16-kHz mono Float32 PCM via AVAudioEngine, matching Whisper’s native sample rate to avoid resample artefacts. :contentReference[oaicite:11]{index=11}  
* Strict SwiftData async transactions (@Model + ModelContext.write) guard against race conditions in a multithreaded environment. :contentReference[oaicite:12]{index=12}  
* Built with Swift 6’s strict concurrency checking and parallel build system for deterministic thread safety. :contentReference[oaicite:13]{index=13}  
* Optimised for iPhone 15 Pro’s A17 Pro chipset, whose 17-TOPS Neural Engine and 20 % faster GPU slash LLM inference time. :contentReference[oaicite:14]{index=14}  
* PDFs are rendered via UIGraphicsPDFRenderer and CoreText for pixel-perfect typography on both A4 and Letter. :contentReference[oaicite:15]{index=15}  
* All data at rest is encrypted with NSFileProtectionComplete to meet HIPAA-grade confidentiality. :contentReference[oaicite:16]{index=16}  
* Neural Engine scheduling is future-proofed using Apple’s low-level APIs as they become publicly available. :contentReference[oaicite:17]{index=17}  
* No telemetry, networking, or third-party analytics—your voice never leaves the device. ✔️
