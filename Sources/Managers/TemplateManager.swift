// FilePath: Sources/Managers/TemplateManager.swift
// Centralises CRUD on FormTemplate, supports duplicate-and-export operations
// described in task §22.2.  Uses SwiftData batch deletes for efficiency.  
// ModelContext API reference. :contentReference[oaicite:5]{index=5}

import Foundation
import SwiftData
import ZIPFoundation

@MainActor
struct TemplateManager {
    private let ctx: ModelContext
    init(ctx: ModelContext? = nil) {
        self.ctx = ctx ?? ModelContext.shared
    }
    
    func duplicate(_ tmpl: FormTemplate) {
        let copy = FormTemplate(title: tmpl.title + " copy",
                                rawText: tmpl.rawText,
                                fields: tmpl.fields)
        ctx.insert(copy)
    }
    
    func exportAll() throws -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        for t in try ctx.fetch(FetchDescriptor<FormTemplate>()) {
            let file = dir.appendingPathComponent(t.title).appendingPathExtension("txt")
            try t.rawText.write(to: file, atomically: true, encoding: .utf8)
        }
        let zipURL = dir.appendingPathExtension("zip")
        try FileManager.default.zipItem(at: dir, to: zipURL)
        return zipURL
    }
    
    func delete(_ tmpl: FormTemplate) throws {
        ctx.delete(tmpl)
        try ctx.save()
    }
}
