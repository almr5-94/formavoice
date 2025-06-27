// FilePath: Sources/Views/RecordingView.swift
// Shows live waveform via Metal draw-loop (WaveformView) and displays progressive
// STT chunks every two seconds. :contentReference[oaicite:3]{index=3}

import SwiftUI
import SwiftData

@MainActor
struct RecordingView: View {
    @StateObject private var vm = RecordingViewModel()
    @EnvironmentObject private var coordinator: AppCoordinator
    let template: FormTemplate
    
    var body: some View {
        VStack(spacing: 24) {
            WaveformView()               // 60 FPS Metal-based oscilloscope.
                .frame(height: 160)
            
            ScrollView {
                Text(vm.transcript)
                    .font(.body)        // Responds to Dynamic Type. :contentReference[oaicite:4]{index=4}
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(.secondary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button(role: .destructive) {
                vm.stop()
                coordinator.showReview(for: saveSession())
            } label: {
                Label("Stop & Review", systemImage: "stop.circle")
                    .font(.title2)
            }
            .padding(.top, 16)
        }
        .padding()
        .navigationTitle("Recording")
        .onAppear { try? vm.start() }
        .onDisappear { vm.stop() }
    }
    
    private func saveSession() -> RecordingSession {
        let session = RecordingSession(transcript: vm.transcript,
                                       json: "",
                                       pdfURL: nil,
                                       template: template)
        ModelContext.shared.insert(session)
        return session
    }
}
