// FilePath: Sources/Navigation/Router.swift
import SwiftUI

@MainActor
public final class Router: ObservableObject {
    @Published var path: [Route] = []
    
    enum Route: Hashable {
        case onboarding
        case dashboard
        case record(FormTemplate)
        case review(RecordingSession)
        case preview(Data)
        case settings
    }
    
    public init() {}
    
    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }
    func reset() { path.removeAll() }
}
