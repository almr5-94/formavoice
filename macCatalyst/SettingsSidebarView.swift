#if targetEnvironment(macCatalyst)
import SwiftUI

struct SettingsSidebarView: View {
    enum Section: String, CaseIterable, Identifiable {
        case general = "General"
        case privacy = "Privacy"
        case advanced = "Advanced"

        var id: String { rawValue }
    }

    @SceneStorage("selectedSetting") private var selection: Section = .general

    var body: some View {
        NavigationSplitView {
            List(Section.allCases, selection: $selection) { item in
                Label(item.rawValue, systemImage: icon(for: item))
            }
            .navigationTitle("Settings")
            .listStyle(.sidebar)
        } detail: {
            switch selection {
            case .general:  GeneralSettingsView()
            case .privacy:  PrivacySettingsView()
            case .advanced: AdvancedSettingsView()
            }
        }
        .if(isCatalyst) { $0.toolbarBackground(.visible, for: .navigationBar) }
    }

    private var isCatalyst: Bool { ProcessInfo.processInfo.isMacCatalystApp }

    private func icon(for section: Section) -> String {
        switch section {
        case .general:  return "gearshape"
        case .privacy:  return "lock.shield"
        case .advanced: return "hammer"
        }
    }
}

// Placeholder detail views – replace with real implementations when ready.
private struct GeneralSettingsView: View { var body: some View { Text("General settings coming soon") } }
private struct PrivacySettingsView: View { var body: some View { Text("Privacy settings coming soon") } }
private struct AdvancedSettingsView: View { var body: some View { Text("Advanced settings coming soon") } }

private extension View {
    /// Applies the given transform when `condition` is true, otherwise returns `self`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
#endif
