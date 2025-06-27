// FilePath: Sources/Utilities/AppSizeCheck.swift
// Enforces cellular-friendly install size by deferring large models as
// On-Demand Resources when device free space <1 GB.  References 200 MB policy. :contentReference[oaicite:6]{index=6}

import Foundation
import StoreKit

enum AppSizeCheck {
    static func shouldDeferLLM() -> Bool {
        // Rough heuristic: check availableCapacityForImportantUsage.
        if let cap = try? URL(fileURLWithPath: NSHomeDirectory())
            .resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            .volumeAvailableCapacityForImportantUsage,
           cap < 1_000_000_000 { return true }
        return false
    }
}
