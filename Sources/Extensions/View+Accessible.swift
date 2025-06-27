// FilePath: Sources/Extensions/View+Accessible.swift
import SwiftUI

extension View {
    /// Applies default accessibility modifiers: size-class scaling and VoiceOver focus.
    func accessible(_ identifier: String) -> some View {
        self
            .accessibilityIdentifier(identifier)
            .minimumScaleFactor(0.8)
            .dynamicTypeSize(.small ... .accessibility4)
    }
}
