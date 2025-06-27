// FilePath: Sources/DesignSystem/AppTheme.swift
import SwiftUI

struct AppTheme: ViewModifier {
    @Environment(\.colorScheme) private var _colorScheme
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(nil)
            .tint(ColorTokens.accent)
            .background(ColorTokens.background.ignoresSafeArea())
    }
}
