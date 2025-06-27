// FilePath: Sources/Components/CardView.swift
import SwiftUI

struct CardView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        content()
            .padding(Spacing.s3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ColorTokens.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
    }
}
