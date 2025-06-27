// FilePath: Sources/Views/SettingsView.swift
// Provides toggles for Low-Memory Mode and Live-Token display.  Persists
// using AppStorage.  Includes link to embedded Privacy Whitepaper. :contentReference[oaicite:4]{index=4}

import SwiftUI

struct SettingsView: View {
    @AppStorage("lowMemoryMode") private var lowMemory = false
    @AppStorage("liveTokens") private var liveTokens = true
    
    var body: some View {
        Form {
            Toggle("Low-Memory Mode", isOn: $lowMemory)
            Toggle("Display Live Tokens", isOn: $liveTokens)
            NavigationLink("Privacy Whitepaper") {
                VStack(alignment: .leading) {
                    if let url = Bundle.main.url(forResource: "PrivacyWhitepaper", withExtension: "md"),
                       let md = try? String(contentsOf: url) {
                        Text(.init(md))
                    } else {
                        Text("Privacy whitepaper not found in app bundle.")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationTitle("Settings")
    }
}
