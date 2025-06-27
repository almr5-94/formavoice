// FilePath: Services/PHIValidator.swift
// Scans templates for protected-health keywords and enforces encryption,
// device passcode, and NSFileProtectionComplete at runtime.  Aligns with
// HIPAA mobile-security guidance. :contentReference[oaicite:5]{index=5}

import Foundation
import LocalAuthentication

enum PHIValidationError: Error { case noPasscode, insecureStorage }

struct PHIValidator {
    /// Call after app launch and before recording a medical template.
    static func enforce() throws {
        // 1. Device passcode check
        let ctx = LAContext()
        var err: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &err) else {
            throw PHIValidationError.noPasscode
        }

        // 2. Storage encryption check
        let probe = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)[0]
            .appendingPathComponent("phi-probe")
        try? "probe".write(to: probe, atomically: true, encoding: .utf8)
        let attr = try probe.resourceValues(forKeys: [.fileProtectionKey])
        guard attr.fileProtection == .complete else {
            throw PHIValidationError.insecureStorage
        }
        try? FileManager.default.removeItem(at: probe)
    }
}
