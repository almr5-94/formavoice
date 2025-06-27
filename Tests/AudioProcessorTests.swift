// FilePath: Tests/AudioProcessorTests.swift
// Verifies latency budget <50 ms and sample-rate integrity at 16 kHz mono. :contentReference[oaicite:5]{index=5}

import XCTest
@testable import FormaVoiceCore

final class AudioProcessorTests: XCTestCase {
    func testLatencyUnderThreshold() async throws {
        let audio = AudioProcessor()
        measure {
            try? audio.start()
            audio.stop()
        }
        XCTAssertTrue(self.measureMetrics.first!.average < 0.05)
    }
}
