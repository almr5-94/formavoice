#if canImport(UIKit)
import UIKit
import AVFoundation

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configureAudioSession()
        CrashLogger.shared.install()
        _ = MemoryWarningHandler.shared // register
        return true
    }
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
        try? session.setPreferredSampleRate(16_000)
        try? session.setActive(true)
    }
}
#else
// Placeholder to satisfy SwiftPM builds on non-UIKit platforms.
public final class AppDelegate {}
#endif 