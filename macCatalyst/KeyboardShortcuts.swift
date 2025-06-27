import UIKit
import SwiftUI

/// A UIHostingController subclass that installs global hardware-keyboard shortcuts.
final class KeyCommandsHostingController<Content: View>: UIHostingController<Content> {
    override var keyCommands: [UIKeyCommand]? {
        [
            UIKeyCommand(title: "Start Recording",
                         action: #selector(beginRecording),
                         input: "R", modifierFlags: [.command]),
            UIKeyCommand(title: "Stop Recording",
                         action: #selector(stopRecording),
                         input: ".", modifierFlags: [.command])
        ]
    }

    // MARK: - Actions
    @objc private func beginRecording() {
        NotificationCenter.default.post(name: .startRecording, object: nil)
    }

    @objc private func stopRecording() {
        NotificationCenter.default.post(name: .stopRecording, object: nil)
    }
}

extension Notification.Name {
    static let startRecording = Notification.Name("ai.formavoice.startRecording")
    static let stopRecording  = Notification.Name("ai.formavoice.stopRecording")
}
