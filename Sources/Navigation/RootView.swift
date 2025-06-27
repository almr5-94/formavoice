// FilePath: Sources/Navigation/RootView.swift
import SwiftUI

public struct RootView: View {
    @StateObject private var router = Router()
    @AppStorage("didFinishOnboarding") private var finished = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            if finished { DashboardView() }
            else { EnhancedOnboardingView() }
        }
        .environmentObject(router)
    }
}
