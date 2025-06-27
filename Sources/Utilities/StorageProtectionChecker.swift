// FilePath: Sources/Utilities/StorageProtectionChecker.swift
// Confirms every file written via FileManager uses .complete protection,
// complying with HIPAA mobile-security guidance.:contentReference[oaicite:4]{index=4}

import Foundation

enum StorageProtectionChecker {
    static func assertCompleteProtection(at url: URL) {
        guard let values = try? url.resourceValues(forKeys: [.fileProtectionKey]),
              values.fileProtection == .complete else {
            assertionFailure("File at \(url.lastPathComponent) not protected by NSFileProtectionComplete")
            return
        }
    }
}
