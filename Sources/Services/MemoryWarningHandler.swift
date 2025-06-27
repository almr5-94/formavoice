// FilePath: Sources/Services/MemoryWarningHandler.swift
// Observes system memory warnings and unloads heavy AI models.

import Combine
import SwiftUI

#if canImport(UIKit)
import UIKit

@MainActor
final class MemoryWarningHandler {
    static let shared = MemoryWarningHandler()
    private var cancellable: AnyCancellable?
    private var lowMemoryModeEnabled = false
    
    private init() {
        cancellable = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in
                self?.unloadHeavyModels()
            }
    }
    
    private func unloadHeavyModels() {
        guard !lowMemoryModeEnabled else { return }
        LLMBridge.shared?.unload()
        lowMemoryModeEnabled = true
        DispatchQueue.main.async {
            // Present alert in foreground window.
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                let alert = UIAlertController(title: NSLocalizedString("alert_memory_warning", comment: ""),
                                              message: nil,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                window.rootViewController?.present(alert, animated: true)
            }
        }
    }
}
#else
// Placeholder implementation for macOS and other platforms where UIKit is unavailable.
struct MemoryWarningHandler {
    static let shared = MemoryWarningHandler()
    private init() {}
}
#endif
