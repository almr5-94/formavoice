
// FilePath: Sources/Components/FilledButton.swift
import SwiftUI

struct FilledButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(FontTokens.body.weight(.semibold))
                .padding(.vertical, Spacing.s2)
                .frame(maxWidth: .infinity)
                .background(ColorTokens.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}