// FilePath: Sources/Models/FormTemplate.swift
// Defines the @Model used by SwiftData to persist user-imported templates.  
// SwiftData models behave like regular value-type structs while gaining automatic change
// tracking and disk persistence through ModelContext. :contentReference[oaicite:0]{index=0}

import SwiftData
import Foundation

@Model
public final class FormTemplate: Identifiable {
    public var title: String
    public var rawText: String        // Entire source text (header + field list).

    // Store fields as Data to avoid CoreData class-mapping issues
    @Attribute(.externalStorage) private var fieldsJSON: Data?

    public var createdAt: Date

    // Computed accessors so the rest of the app can keep using `[String]`
    public var fields: [String] {
        get {
            guard let data = fieldsJSON else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            fieldsJSON = try? JSONEncoder().encode(newValue)
        }
    }

    public init(title: String, rawText: String, fields: [String]) {
        self.title = title
        self.rawText = rawText
        self.fieldsJSON = try? JSONEncoder().encode(fields)
        self.createdAt = .now
    }

    /// JSON representation consumed by the LLM prompt.
    public var fieldsAsJSONString: String {
        if let data = fieldsJSON { return String(data: data, encoding: .utf8) ?? "[]" }
        return "[]"
    }
}
