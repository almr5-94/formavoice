// FilePath: Sources/Constants/ModelPaths.swift
// Centralises absolute paths for bundled and side-loaded AI models.
// Keeping paths in one place avoids hard-coding strings across bridges.  
// Bundled GGUF models live in the main bundle’s “Models” folder.  
// User-imported models are copied to Library/OnDemandResources/user/ (§21.1).  
// We validate SHA-256 after copy to preserve model integrity.:contentReference[oaicite:0]{index=0}

import Foundation

enum ModelPaths {
    /// Bundled Whisper STT model (GGML_Q4_K).  
    static let whisper = Bundle.main.url(forResource: "ggml-base.en-q4_k",
                                         withExtension: "bin")!.path
    
    /// Bundled Phi-3-Mini (q4_k_m.gguf) used for JSON reasoning.  
    static let phi3   = Bundle.main.url(forResource: "phi-3-mini-instruct-q4_k_m",
                                        withExtension: "gguf")!.path
    
    /// Folder for user side-loaded GGUF models imported via Files.app.  
    static let userModelsDir = FileManager.default.urls(for: .libraryDirectory,
                                                        in: .userDomainMask)[0]
        .appendingPathComponent("OnDemandResources/user").path
}
