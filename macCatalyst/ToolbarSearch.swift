#if targetEnvironment(macCatalyst)
import UIKit
import AppKit

/// Adds a native NSSearchField to the macOS title-bar toolbar when running under Catalyst.
final class ToolbarCoordinator: NSObject, NSToolbarDelegate, UISearchBarDelegate {
    private weak var windowScene: UIWindowScene?
    private let searchBar = UISearchBar()
    private let toolbarID = "ai.formavoice.toolbar"

    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
        super.init()
        installToolbar()
    }

    private func installToolbar() {
        guard let titlebar = windowScene?.titlebar else { return }
        let toolbar = NSToolbar(identifier: NSToolbar.Identifier(toolbarID))
        toolbar.delegate = self
        titlebar.toolbar = toolbar
    }

    // MARK: - NSToolbarDelegate
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.toggleSidebar, .flexibleSpace, .search]
    }

    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier id: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard id == .search else { return nil }
        let item = NSToolbarItem(itemIdentifier: id)
        searchBar.delegate = self
        item.view = searchBar
        return item
    }

    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ bar: UISearchBar) {
        NotificationCenter.default.post(name: .searchTemplates,
                                        object: bar.text ?? "")
    }
}

extension Notification.Name {
    static let searchTemplates = Notification.Name("ai.formavoice.searchTemplates")
}
#endif
