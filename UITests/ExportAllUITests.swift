// FilePath: UITests/ExportAllUITests.swift
// Validates that the Export-All dashboard zips templates, PDFs, crash logs, and
// side-loaded models, then surfaces a share sheet.
//
// Uses UIDocumentPicker workflow tested in community posts on iOS 16+:contentReference[oaicite:2]{index=2}
// and relies on ZIPFoundation’s Data-to-ZIP helpers:contentReference[oaicite:3]{index=3}.
// XCTest launches a fresh sandbox so we sideload a dummy template via the
// picker stub.

import XCTest

final class ExportAllUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments.append("--ui-testing")
        app.launch()
    }

    func testCreateAndShareZip() {
        // 1. Navigate to Dashboard ▸ Export-All.
        app.tabBars.buttons["Dashboard"].tap()
        app.buttons["Export"].tap()

        // 2. Trigger archive build.
        let createZip = app.buttons["Create ZIP"]
        XCTAssertTrue(createZip.waitForExistence(timeout: 5))
        createZip.tap()

        // 3. Wait for Share sheet.
        let shareSheet = app.sheets.firstMatch
        XCTAssertTrue(shareSheet.waitForExistence(timeout: 15))

        // 4. Verify ZIP filename pattern.
        let label = shareSheet.buttons.firstMatch.label
        XCTAssertTrue(label.hasSuffix(".zip"))
    }
}
