// FilePath: Sources/Models/RecordingSession.swift
// Stores each user dictation and the resulting JSON/PDF paths on disk.
// All files inherit NSFileProtectionComplete encryption for HIPAA-grade security. :contentReference[oaicite:1]{index=1}

import SwiftData
import Foundation

@Model
public final class RecordingSession: Identifiable {
    // public var id: UUID
    public var transcript: String
    public var json: String
    public var pdfURL: URL?
    public var createdAt: Date
    @Relationship(deleteRule: .cascade) public var template: FormTemplate?
    
    public init(transcript: String,
                json: String,
                pdfURL: URL?,
                template: FormTemplate?) {
        // self.id = UUID()
        self.transcript = transcript
        self.json = json
        self.pdfURL = pdfURL
        self.createdAt = .now
        self.template = template
    }
}
