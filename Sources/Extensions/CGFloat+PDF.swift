// FilePath: Sources/Extensions/CGFloat+PDF.swift
// Utility for converting millimetres → points; useful for A4 page layout.

import CoreGraphics

extension CGFloat {
    /// Converts millimetres to PDF points (1 point = 1/72 inch).
    static func mm(_ value: CGFloat) -> CGFloat {
        value * 72.0 / 25.4
    }
}
