#if targetEnvironment(macCatalyst)
import UIKit

extension AppDelegate {
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)

        // Custom 'Templates' menu containing an Export dSYM command.
        let exportAction = UIAction(title: "Export dSYM…") { _ in
            NotificationCenter.default.post(name: .exportDSYM, object: nil)
        }

        let templateMenu = UIMenu(title: "Templates", options: .displayInline, children: [exportAction])
        // Place new menu after standard File menu.
        builder.insertSibling(templateMenu, afterMenu: .file)
    }
}
#endif
