// FilePath: Sources/Coordinators/AppCoordinator.swift
// Drives MVVM-C navigation without exposing NavigationStack directly to views.
// StrictConcurrency enabled to guarantee main-thread UI mutations. :contentReference[oaicite:0]{index=0}

import SwiftUI
import Combine

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published var path: [Route] = []
    
    public enum Route: Hashable {
        case templatePicker
        case recorder(FormTemplate)
        case review(RecordingSession)
        case pdf(Data)
    }
    
    func showTemplatePicker() {
        path = [.templatePicker]
    }
    
    func startRecording(for template: FormTemplate) {
        path.append(.recorder(template))
    }
    
    func showReview(for session: RecordingSession) {
        path.append(.review(session))
    }
    
    func presentPDF(_ data: Data) {
        path.append(.pdf(data))
    }
}
