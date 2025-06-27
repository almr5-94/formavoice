// FilePath: Tests/TemplateValidationTests.swift
// Covers duplicate-field and over-length error branches for TemplateValidationService.

import XCTest
@testable import FormaVoiceCore

final class TemplateValidationTests: XCTestCase {
    func testDuplicateFieldThrows() {
        let tmpl = FormTemplate(title: "dup",
                                rawText: "A:\nA:",
                                fields: ["A", "A"])
        XCTAssertThrowsError(try TemplateValidationService.validate(tmpl))
    }
    
    func testLongFieldThrows() {
        let long = String(repeating: "x", count: 81)
        let tmpl = FormTemplate(title: "long",
                                rawText: "\(long):",
                                fields: [long])
        XCTAssertThrowsError(try TemplateValidationService.validate(tmpl))
    }
}
