import SwiftUI

/// Adds adaptive horizontal padding depending on horizontalSizeClass.
struct LayoutAware: ViewModifier {
    @Environment(\.horizontalSizeClass) private var hSize

    func body(content: Content) -> some View {
        if hSize == .compact {
            content.padding(.horizontal, Spacing.s2)
        } else {
            content.padding(.horizontal, Spacing.s4)
        }
    }
}

extension View {
    /// Apply responsive horizontal padding that adapts to size-class changes (e.g. split-view on iPad).
    func layoutAware() -> some View { modifier(LayoutAware()) }
}
