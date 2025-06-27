// FilePath: Sources/Extensions/URL+SecureWrite.swift
// Convenience helper to write Data using .complete protection without repeating
// options flags everywhere.

import Foundation

extension URL {
    /// Writes data with `NSFileProtectionComplete`; throws on failure.
    func secureWrite(_ data: Data) throws {
        try data.write(to: self, options: [.atomic, .completeFileProtection])
    }
}
