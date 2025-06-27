#if canImport(UIKit)
import SwiftUI
import Combine
import UIKit

/// ViewModifier that shifts content upward when the system keyboard appears so fields remain visible.
public struct KeyboardAvoidance: ViewModifier {
    @State private var bottomInset: CGFloat = 0
    private let kbPublisher = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillChangeFrameNotification)

    public func body(content: Content) -> some View {
        content
            .padding(.bottom, bottomInset)
            .animation(.easeOut(duration: 0.25), value: bottomInset)
            .onReceive(kbPublisher) { note in
                guard
                    let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first
                else { return }
                let safe = window.safeAreaInsets.bottom
                // Calculate overlap between keyboard top and window bottom.
                let offset = max(0, window.frame.maxY - frame.minY - safe)
                bottomInset = offset
            }
    }
}

public extension View {
    /// Apply keyboard avoidance behaviour to any scrollable or stacked content.
    func avoidKeyboard() -> some View { modifier(KeyboardAvoidance()) }
}
#endif
