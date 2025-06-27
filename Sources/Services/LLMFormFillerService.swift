// FilePath: Sources/Services/LLMFormFillerService.swift
// Streams JSON from phi-3-mini.gguf through llama.cpp Metal backend for low latency. :contentReference[oaicite:3]{index=3}

import Foundation
import Combine

@MainActor
struct LLMFormFillerService {
    private let bridge: LLMBridge
    
    init() {
        let modelPath = Bundle.main.path(forResource: "phi-3-mini-instruct-q4_k_m", ofType: "gguf")!
        bridge = LLMBridge(modelAt: modelPath)
    }
    
    func fill(template: FormTemplate, transcript: String) -> AnyPublisher<String, Never> {
        let prompt = """
        You are a JSON generation agent. Output strict JSON only — no markdown. \
        Fields: \(template.fieldsAsJSONString). \
        Transcript: \"\"\"\(transcript)\"\"\"
        """
        let subject = PassthroughSubject<String,Never>()
        bridge.runPrompt(prompt) { token in
            subject.send(token)
        } completion: { _ in
            subject.send(completion: .finished)
        }
        return subject.eraseToAnyPublisher()
    }
}
