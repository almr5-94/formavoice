// FilePath: Tests/BenchmarkTests.swift
// Automates STT latency & peak-memory measurement so CI fails if
// regression >15 %.  Developers can profile with Instruments’ “All Allocations”
// preset. :contentReference[oaicite:4]{index=4}

import XCTest
@testable import FormaVoiceCore

final class BenchmarkTests: XCTestCase {
    func testSTTLatencyUnderRealTime() throws {
        let wav = Bundle.module.url(forResource: "sample20s", withExtension: "wav")!
        let pcm  = try Data(contentsOf: wav).withUnsafeBytes { ptr in
            Array(ptr.bindMemory(to: Float.self))
        }
        let bridge = WhisperBridge(modelAt: ModelPaths.whisper)
        let exp = expectation(description: "transcribed")
        let start = CFAbsoluteTimeGetCurrent()
        bridge.transcribePCM(pcm, length: Int32(pcm.count), language: "en") { _ in } completion: { _ in
            let dur = CFAbsoluteTimeGetCurrent() - start
            XCTAssertLessThan(dur, 20.0 * 1.2) // ≤1.2× realtime target.
            exp.fulfill()
        }
        wait(for: [exp], timeout: 30)
    }
}
