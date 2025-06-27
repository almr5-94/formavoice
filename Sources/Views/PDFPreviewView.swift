// FilePath: Sources/Views/PDFPreviewView.swift
// Embeds PDFKit PDFView for zoomable preview and provides ShareLink
// conforming to Apple's PDF workflow patterns. :contentReference[oaicite:3]{index=3}

#if canImport(UIKit)
import SwiftUI
import PDFKit
import CoreTransferable

struct PDFPreviewView: View {
    let data: Data
    
    var body: some View {
        VStack {
            PDFKitView(data: data)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ShareLink(item: TempFile(data: data, ext: "pdf").url) {
                Label("Share PDF", systemImage: "square.and.arrow.up")
            }
            .padding()
        }
        .navigationTitle("Preview")
    }
}

/// Helper to bridge Data → ShareLink temporary file.
private struct TempFile: Transferable {
    let url: URL
    init(data: Data, ext: String) {
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString).appendingPathExtension(ext)
        try? data.write(to: tmp)
        self.url = tmp
    }
    init(url: URL) { self.url = url }
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .pdf) { file in
            SentTransferredFile(file.url)
        } importing: { received in
            Self(url: received.file)
        }
    }
}

private struct PDFKitView: UIViewRepresentable {
    let data: Data
    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument(data: data)
        view.autoScales = true
        return view
    }
    func updateUIView(_ uiView: PDFView, context: Context) {}
}
#endif
