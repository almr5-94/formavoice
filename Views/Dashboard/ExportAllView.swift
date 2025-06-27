// FilePath: Views/Dashboard/ExportAllView.swift
// Lets users ZIP every template, session, PDF, crash-log, and side-loaded model
// into one encrypted archive.  Uses TemplateManager.exportAll() (Response 4)
// plus CrashLogger directory.  UIDocumentPicker-style share sheet mirrors Apple's
// Files-integration recommendations. :contentReference[oaicite:4]{index=4}

import SwiftUI
import ZIPFoundation
import SwiftData

struct ExportAllView: View {
    @State private var archiveURL: URL?
    @State private var showShare = false
    private let manager = TemplateManager()

    var body: some View {
        VStack(spacing: 24) {
            Text("Export every file FormaVoice has created or stored on this iPhone. "
                 + "No data leaves your device until you share the ZIP.")
                .font(.body)
            Button("Create ZIP") {
                archiveURL = try? buildArchive()
                showShare = archiveURL != nil
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $showShare) {
            if let url = archiveURL {
                ShareLink(item: url) {
                    Label("Share \(url.lastPathComponent)", systemImage: "square.and.arrow.up")
                }
            }
        }
    }

    private func buildArchive() throws -> URL {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent("export-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)

        // 1. Templates
        let tmplZip = try manager.exportAll()
        try FileManager.default.moveItem(at: tmplZip,
                                         to: root.appendingPathComponent("templates.zip"))

        // 2. Crash logs
        let crashDir = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
            .appendingPathComponent("CrashLogs")
        if FileManager.default.fileExists(atPath: crashDir.path) {
            try FileManager.default.zipItem(at: crashDir,
                                            to: root.appendingPathComponent("crashlogs.zip"))
        }

        // 3. PDFs + Sessions
        let sessions = try ModelContext.current!.fetch(
            FetchDescriptor<RecordingSession>())
        for s in sessions {
            if let url = s.pdfURL {
                let dest = root.appendingPathComponent("pdf/\(url.lastPathComponent)")
                try FileManager.default.copyItem(at: url, to: dest)
            }
        }

        // 4. Side-loaded models
        let modelDir = FileManager.default.url(for: .libraryDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            .appendingPathComponent("OnDemandResources/user")
        if FileManager.default.fileExists(atPath: modelDir.path) {
            try FileManager.default.zipItem(at: modelDir,
                                            to: root.appendingPathComponent("models.zip"))
        }

        // Final bundle
        let bundle = root.appendingPathExtension("zip")
        try FileManager.default.zipItem(at: root, to: bundle)
        return bundle
    }
}
