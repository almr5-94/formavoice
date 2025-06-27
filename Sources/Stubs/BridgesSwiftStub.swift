import Foundation
import Combine
import AVFoundation

// Temporary Swift stubs for Objective-C++ bridges so the Swift package can compile under SwiftPM.
// When the real Objective-C++ targets get hooked up, remove these placeholders.

@MainActor
public class LLMBridge: NSObject {
    public static var shared: LLMBridge?
    private let path: String
    public init(modelAt path: String) {
        self.path = path
        super.init()
        LLMBridge.shared = self
    }
    public func runPrompt(_ prompt: String,
                          tokenCallback: @escaping (String) -> Void,
                          completion: @escaping (String) -> Void) {
        // Placeholder – immediately invoke completion.
        tokenCallback("}")
        completion("}")
    }
    public func unload() {
        // no-op for stub
    }
}

@MainActor
public class WhisperBridge: NSObject {
    public init(modelAt path: String) {
        super.init()
    }
    public func transcribePCM(_ pcm: [Float],
                              length: Int32,
                              language: String,
                              progressBlock: @escaping (String) -> Void,
                              completion: @escaping (String) -> Void) {
        // Placeholder – return empty immediately.
        completion("")
    }
} 