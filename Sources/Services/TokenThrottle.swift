// FilePath: Sources/Services/TokenThrottle.swift
// Ensures llama.cpp never floods the Combine stream faster than UI can render.
// Provides a back-pressure gate of 60 tokens/s (approximate read-speed for
// average users).  Thread-safe using actor isolation (Swift 6 strict concurrency). 

import Foundation
import Combine

actor TokenThrottle {
    private var lastEmit: TimeInterval = 0
    private let minInterval: TimeInterval = 1.0 / 60.0   // 60 tps
    
    func gate(_ token: String, send: @Sendable (String) -> Void) async {
        let now = ProcessInfo.processInfo.systemUptime
        let delta = now - lastEmit
        if delta < minInterval {
            try? await Task.sleep(nanoseconds: UInt64((minInterval - delta) * 1_000_000_000))
        }
        lastEmit = ProcessInfo.processInfo.systemUptime
        send(token)
    }
}
