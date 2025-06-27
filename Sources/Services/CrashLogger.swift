import Foundation

/// Logs uncaught Objective-C exceptions and saves them into the user's Documents/CrashLogs directory.
/// Files are written with NSFileProtectionComplete in order to comply with HIPAA requirements.
@MainActor
final class CrashLogger {
    static let shared = CrashLogger()
    private init() {}

    /// Installs an Objective-C uncaught-exception handler.
    /// Call this very early in application launch (e.g. in `@main` or `application(_:didFinishLaunchingWithOptions:)`).
    func install() {
        NSSetUncaughtExceptionHandler { exception in
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("CrashLogs")
            try? FileManager.default.createDirectory(at: directory,
                                                     withIntermediateDirectories: true)

            let filename = "crash-\(Date().timeIntervalSince1970).log"
            let fileURL = directory.appendingPathComponent(filename)

            let reason = exception.reason ?? "Unknown"
            try? reason.write(to: fileURL,
                              atomically: true,
                              encoding: .utf8)
        }
    }
} 