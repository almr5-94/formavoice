import SwiftUI

/// macOS-style menu bar commands available when the app runs under Catalyst.
struct MenuBarCommands: Commands {
    var body: some Commands {
        // Insert after the default Save item in the File ▸ menu.
        CommandGroup(after: .saveItem) {
            Button("Export dSYM…") {
                NotificationCenter.default.post(name: .exportDSYM, object: nil)
            }
            .keyboardShortcut("E", modifiers: [.command, .shift])
        }

        // Custom top-level menu for template actions.
        CommandMenu("Templates") {
            Button("New Template") {
                NotificationCenter.default.post(name: .newTemplate, object: nil)
            }
            .keyboardShortcut("N", modifiers: [.command, .option])
        }
    }
}

extension Scene {
    /// Attach Catalyst-specific commands inside a WindowGroup.
    func installMenuCommands() -> some Scene {
#if targetEnvironment(macCatalyst)
        self.commands { MenuBarCommands() }
#else
        self
#endif
    }
}

extension Notification.Name {
    static let exportDSYM  = Notification.Name("ai.formavoice.exportDSYM")
    static let newTemplate = Notification.Name("ai.formavoice.newTemplate")
}
