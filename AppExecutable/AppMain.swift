// FilePath: AppExecutable/AppMain.swift
import SwiftUI
// All code now lives in the same target, so no separate module import is needed.

@main
struct FormaVoiceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppCoordinator())
        }
    }
} 