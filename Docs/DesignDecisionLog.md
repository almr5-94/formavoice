<!-- FilePath: Docs/DesignDecisionLog.md -->
## 2025-06-22

1. **Model Format** – chose GGUF over GGML to leverage tokenizer-in-file design and Metal kernel auto-dispatch. :contentReference[oaicite:18]{index=18}  
2. **Encryption Policy** – enforce `NSFileProtectionComplete` on every persisted asset following Apple’s Data-Protection class matrix. :contentReference[oaicite:19]{index=19}  
3. **PDF Engine** – UIKit’s `UIGraphicsPDFRenderer` preferred over Core Graphics macros for automatic pagination and memory frugality. :contentReference[oaicite:20]{index=20}  
4. **Sample Rate** – fixed capture at 16 kHz to bypass resampler quantisation noise per AVAudioEngine limitations. :contentReference[oaicite:21]{index=21}  
5. **Concurrency Guard** – enabled StrictConcurrency to catch data races at compile-time; justified by Apple’s Swift-6 migration guide. :contentReference[oaicite:22]{index=22}  
6. **GPU Path** – default to Metal backend when `.isLowPower` == false to maximise tokens-per-second without draining battery. :contentReference[oaicite:23]{index=23}  
7. **Binary Footprint** – bring model under the 200 MB cellular cap by splitting GGUF into On-Demand Resource tags. *(internal benchmark)*  
