// FilePath: Sources/ViewModels/RecordingViewModel.swift
// Bridges audio capture → Whisper STT → live transcript stream.  
// Resampler inserted per AVAudioEngine mic-format limitation. :contentReference[oaicite:1]{index=1}  
// Whisper compiled with GGML_QK_K 4-bit to hit on-device memory budget. :contentReference[oaicite:2]{index=2}

import Foundation
import Combine

@MainActor
final class RecordingViewModel: ObservableObject {
    @Published var transcript: String = ""
    
    private let audio = AudioProcessor()
    private let whisper: WhisperBridge = {
        if let path = Bundle.main.path(forResource: "ggml-base.en-q4_k", ofType: "bin") {
            return WhisperBridge(modelAt: path)
        } else {
            // Stubbing: pass empty string when model missing (WHISPER_STUB active)
            return WhisperBridge(modelAt: "")
        }
    }()
    private var bag = Set<AnyCancellable>()
    
    func start() throws {
        try audio.start()
        
        audio.pcmPublisher
            .collect(.byTime(RunLoop.main, .seconds(2)))
            .sink { [weak self] chunk in
                guard let self else { return }
                self.handle(chunks: chunk.flatMap { $0 })
            }
            .store(in: &bag)
    }
    
    func stop() {
        audio.stop()
        bag.removeAll()
    }
    
    private func handle(chunks: [Float]) {
        whisper.transcribePCM(chunks, length: Int32(chunks.count), language: "en") { [weak self] partial in
            self?.transcript.append(partial)
        } completion: { _ in }
    }
}
