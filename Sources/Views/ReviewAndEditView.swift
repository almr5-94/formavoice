// FilePath: Sources/Views/ReviewAndEditView.swift
// Dynamically generates SwiftUI Form rows from decoded JSON, enabling
// last-mile corrections before PDF generation.  Supports Dynamic Type for
// accessibility compliance. :contentReference[oaicite:1]{index=1}

import SwiftUI

struct ReviewAndEditView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.modelContext) private var context
    @State private var dict: [String:String]
    @State private var showAlert = false
    let session: RecordingSession
    let template: FormTemplate
    
    init(session: RecordingSession, template: FormTemplate) {
        self.session = session
        self.template = template
        _dict = State(initialValue: [:])
    }
    
    var body: some View {
        Form {
            ForEach(template.fields, id:\.self) { key in
                TextField(key, text: Binding(
                    get: { dict[key] ?? "" },
                    set: { dict[key] = $0 }))
            }
        }
        .navigationTitle("Review")
        .toolbar {
            Button("Generate PDF") {
                do {
                    let data = try PDFGeneratorService.generate(fields: dict,
                                                                template: template)
                    try save(data)
                    coordinator.presentPDF(data)
                } catch { showAlert = true }
            }
        }
        .alert("Generation Error", isPresented: $showAlert) {
            Text("Unable to create PDF.")
        }
        .task {
            if let data = try? JSONCorrectionService.corrected(session.json),
               let obj = try? JSONSerialization.jsonObject(with: data) as? [String:String] {
                dict = obj
            }
        }
    }
    
    private func save(_ pdf: Data) throws {
        let url = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask)[0]
            .appendingPathComponent("Generated/\(UUID().uuidString).pdf")
        try pdf.write(to: url, options: .completeFileProtection) // NSFileProtectionComplete. :contentReference[oaicite:2]{index=2}
        session.pdfURL = url
        try context.save()
    }
}
