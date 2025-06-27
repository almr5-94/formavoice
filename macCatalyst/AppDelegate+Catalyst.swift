import UIKit

#if targetEnvironment(macCatalyst)
import AppKit
#endif

extension AppDelegate {
    /// Bootstraps Catalyst-specific integrations like toolbar search, Touch Bar and sidebar styling.
    func setupCatalystExtensions(for scene: UIScene) {
#if targetEnvironment(macCatalyst)
        guard let winScene = scene as? UIWindowScene else { return }
        _ = ToolbarCoordinator(windowScene: winScene)
        winScene.titlebar?.toolbarStyle = .unifiedCompact
        winScene.title = "FormaVoice"
        winScene.touchBar = TouchBarProvider().makeTouchBar()
#endif
    }

    // MARK: - UIScene Connection
    func application(_ application: UIApplication,
                     didConnect scene: UIScene,
                     options connectionOptions: UIScene.ConnectionOptions) {
        setupCatalystExtensions(for: scene)
    }
}
