// FilePath: Sources/Views/TemplatePickerView.swift
// Presents UIDocumentPicker for plain-text template import and validates with
// TemplateValidationService before persisting.  
// Dynamic Type support ensures accessibility compliance. :contentReference[oaicite:2]{index=2}

import SwiftUI
import UniformTypeIdentifiers
import SwiftData
import PDFKit

struct TemplatePickerView: View {
    @Environment(\.modelContext) private var context
    @State private var isImporterPresented = false
    @State private var alertMessage: String?
    
    var body: some View {
        List {
            ForEach(queryTemplates()) { tmpl in
                NavigationLink(destination: RecordingView(template: tmpl)) {
                    Text(tmpl.title)
                }
            }
        }
        .navigationTitle("Templates")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Import") { isImporterPresented = true }
            }
        }
        .fileImporter(isPresented: $isImporterPresented,
                      allowedContentTypes: [.plainText, .pdf, .image]) { result in
            switch result {
            case .success(let url):
                importTemplate(from: url)
            case .failure(let err):
                alertMessage = err.localizedDescription
            }
        }
        .alert("Import Error", isPresented: Binding(
            get: { alertMessage != nil },
            set: { _ in alertMessage = nil })) {
                Text(alertMessage ?? "")
            }
    }
    
    private func queryTemplates() -> [FormTemplate] {
        return (try? context.fetch(FetchDescriptor<FormTemplate>())) ?? []
    }
    
    private func importTemplate(from url: URL) {
        // Ensure sandboxed access for files outside the app container (iOS/macOS file importer).
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer { if didStartAccessing { url.stopAccessingSecurityScopedResource() } }

        let raw: String
        switch url.pathExtension.lowercased() {
        case "txt":
            guard let txt = try? String(contentsOf: url) else {
                alertMessage = "Failed to read text file."; return }
            raw = txt
        case "pdf":
            guard let doc = PDFDocument(url: url) else {
                alertMessage = "Unable to open PDF."; return }
            var collected = ""
            for i in 0..<doc.pageCount {
                if let page = doc.page(at: i), let s = page.string {
                    collected += s + "\n"
                }
            }
            raw = collected
        default:
            alertMessage = "Only .txt or .pdf templates are supported."
            return
        }
        let lines = raw.split(separator: "\n").map(String.init)
        let fields = lines.filter { $0.hasSuffix(":") }
                           .map { String($0.dropLast()) }
        let tmpl = FormTemplate(title: url.deletingPathExtension().lastPathComponent,
                                rawText: raw,
                                fields: fields)
        do {
            try TemplateValidationService.validate(tmpl)
            context.insert(tmpl)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
