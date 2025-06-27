import SwiftUI
import SwiftData

struct DashboardView: View {
    var body: some View {
        List {
            // Users must first choose a template before recording.
            NavigationLink("Record", destination: TemplatePickerView())
            #if canImport(UIKit)
            NavigationLink("Export All", destination: ExportAllView())
            #endif
            NavigationLink("Settings", destination: SettingsView())
        }
        .navigationTitle("Dashboard")
    }
}

#Preview {
    DashboardView()
} 