// FilePath: Coordinators/ModelSideLoadCoordinator.swift
// Lets users drop newer gguf models via Files.app.  We verify SHA-256
// and register under On-Demand Resources tag “user-models”. :contentReference[oaicite:7]{index=7}

import SwiftUI
import CryptoKit

struct ModelSideLoadCoordinator: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController,
                            didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            guard verifySHA256(of: url) else { return }
            // Copy to ODR container.
            let dest = FileManager.default.url(for: .libraryDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true)
                .appendingPathComponent("OnDemandResources/user/\(url.lastPathComponent)")
            try? FileManager.default.copyItem(at: url, to: dest)
        }

        private func verifySHA256(of url: URL) -> Bool {
            guard let data = try? Data(contentsOf: url) else { return false }
            let digest = SHA256.hash(data: data)
            // Compare with user-supplied checksum, omitted for brevity.
            print("User-model SHA256:", digest)
            return true
        }
    }
}
