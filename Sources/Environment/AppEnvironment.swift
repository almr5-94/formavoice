// FilePath: Sources/Environment/AppEnvironment.swift
// Compile-time flags enable lightweight stubbing for UI-testing,
// TestFlight, or local debug builds.  Adapted from Apple sample code
// on environment variables and XCUIApplication launch arguments.:contentReference[oaicite:1]{index=1}

import Foundation

enum AppEnvironment {
    static let isUITest      = ProcessInfo.processInfo.arguments.contains("--ui-testing")
    static let isDebug       = _isDebugAssertConfiguration()
    static let isTestFlight  = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
}
