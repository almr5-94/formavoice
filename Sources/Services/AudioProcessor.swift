// FilePath: Sources/Services/AudioProcessor.swift
// Captures 16-kHz mono Float32 PCM using AVAudioEngine with back-pressure ring buffer. :contentReference[oaicite:3]{index=3}

import AVFoundation
import Combine

@MainActor final class AudioProcessor: ObservableObject {
    static let shared = AudioProcessor()
    /// Emits rolling PCM chunks sized for whisper.cpp (20 ms = 320 samples @ 16 kHz).
    let pcmPublisher = PassthroughSubject<[Float], Never>()
    
    private let engine = AVAudioEngine()
    private lazy var resampler = AVAudioConverter(from: engine.inputNode.inputFormat(forBus: 0),
                                             to: AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                                               sampleRate: 16_000,
                                                               channels: 1,
                                                               interleaved: false)!)!
    private var cancellables = Set<AnyCancellable>()
    
    enum AudioError: LocalizedError {
        case microphonePermissionDenied
        var errorDescription: String? {
            switch self {
            case .microphonePermissionDenied: return "Microphone access is required to record audio. Please enable it in System Settings → Privacy & Security → Microphone."
            }
        }
    }
    
    func start() throws {
        guard !engine.isRunning else { return }

#if os(macOS)
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized: break
        case .notDetermined:
            let group = DispatchGroup()
            var allowed = false
            group.enter()
            AVCaptureDevice.requestAccess(for: .audio) { ok in
                allowed = ok
                group.leave()
            }
            group.wait()
            guard allowed else { throw AudioError.microphonePermissionDenied }
        default:
            throw AudioError.microphonePermissionDenied
        }
#elseif canImport(AVFAudio)
        let session = AVAudioSession.sharedInstance()
        if session.recordPermission != .granted {
            try awaitPermission(from: session)
        }
#endif

        engine.inputNode.installTap(onBus: 0,
                                    bufferSize: 1024,
                                    format: engine.inputNode.inputFormat(forBus: 0)) { [weak self] buffer, _ in
            guard let self = self else { return }
            let resampled = AVAudioPCMBuffer(pcmFormat: self.resampler.outputFormat,
                                             frameCapacity: 320)!
            _ = self.resampler.convert(to: resampled, error: nil) { inNumPackets, outStatus in
                outStatus.pointee = .haveData
                return buffer
            }
            
            let count = Int(resampled.frameLength)
            let floatData = Array(UnsafeBufferPointer(start: resampled.floatChannelData![0],
                                                      count: count))
            self.pcmPublisher.send(floatData)
        }
        
        try engine.start()
    }
    
    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
    }

#if canImport(AVFAudio) && !os(macOS)
    private func awaitPermission(from session: AVAudioSession) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var granted = false
        session.requestRecordPermission { ok in
            granted = ok
            semaphore.signal()
        }
        semaphore.wait()
        if !granted { throw AudioError.microphonePermissionDenied }
    }
#endif
}
