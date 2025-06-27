// FilePath: Tests/LLMFormFillerServiceTests.swift
// Uses mock bridge to ensure JSON stop-sequence compliance "}" :contentReference[oaicite:6]{index=6}

import XCTest
import Combine
@testable import FormaVoiceCore

final class LLMFormFillerServiceTests: XCTestCase {
    @MainActor
    func testStopSequence() throws {
        let tmpl = FormTemplate(title: "Demo", rawText: "Name, DOB", fields: ["Name","DOB"])
        let svc = LLMFormFillerService()
        let exp = expectation(description: "LLM finished")
        var output = ""
        let cancellable = svc.fill(template: tmpl, transcript: "Name John; DOB 1/1/90")
            .sink(receiveCompletion: { _ in exp.fulfill() },
                  receiveValue: { output.append($0) })
        wait(for: [exp], timeout: 1)
        XCTAssertTrue(output.hasSuffix("}"), "JSON did not terminate correctly")
        _ = cancellable
    }
}
