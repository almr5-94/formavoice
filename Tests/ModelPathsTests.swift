// FilePath: Tests/ModelPathsTests.swift
// Ensures bundled models exist and user-model directory is created.
// Uses SwiftData ModelContext path constants.:contentReference[oaicite:5]{index=5}

import XCTest
@testable import FormaVoiceCore

final class ModelPathsTests: XCTestCase {
    func testModelFilesExist() {
        XCTAssertTrue(FileManager.default.fileExists(atPath: ModelPaths.whisper))
        XCTAssertTrue(FileManager.default.fileExists(atPath: ModelPaths.phi3))
    }
    
    func testUserModelsDir() {
        XCTAssertTrue(FileManager.default.fileExists(atPath: ModelPaths.userModelsDir))
    }
}
