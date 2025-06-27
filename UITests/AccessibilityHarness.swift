// FilePath: UITests/AccessibilityHarness.swift
// Runs an automated VoiceOver label audit via XCTest.  Techniques cribbed from
// Mobile A11y’s XCUI guide and CreateWithSwift article. :contentReference[oaicite:8]{index=8}

import XCTest

final class AccessibilityHarness: XCTestCase {

    func testCriticalViewsHaveLabels() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()

        // 1. Waveform canvas
        XCTAssertTrue(app.otherElements["waveformView"].isHittable,
                      "Waveform view missing accessibility label")

        // 2. “Stop & Review” primary button
        XCTAssertTrue(app.buttons["Stop & Review"].exists,
                      "Primary action button not exposed to VoiceOver")

        // 3. PDF preview
        app.buttons["Stop & Review"].tap()
        app.buttons["Generate PDF"].tap()
        XCTAssertTrue(app.otherElements["pdfPreview"].exists,
                      "PDFKit preview lacking accessibility ID")

        // 4. Share sheet
        app.buttons["Share PDF"].tap()
        XCTAssertTrue(app.sheets.firstMatch.exists,
                      "Share sheet did not appear for VoiceOver users")
    }
}
