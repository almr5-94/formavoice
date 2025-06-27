// FilePath: Scripts/aggregate-licenses.swift
// Crawls /Vendor and SwiftPM checkouts, collects every LICENSE/LICENCE file,
// and writes a bundled Markdown acknowledgement ready for Settings → “Open-Source”.  
// Inspired by common build-phase scripts seen in OSS-compliance blogs. :contentReference[oaicite:8]{index=8}

import Foundation

let projectDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let output = projectDir.appendingPathComponent("Resources/acknowledgements.md")

let fm = FileManager.default
fm.createFile(atPath: output.path, contents: nil)
let handle = try FileHandle(forWritingTo: output)

func scan(_ dir: URL) {
    guard let iter = fm.enumerator(at: dir,
                                   includingPropertiesForKeys: [.isRegularFileKey],
                                   options: [.skipsHiddenFiles]) else { return }
    for case let url as URL in iter {
        if url.lastPathComponent.lowercased().hasPrefix("licen") {
            if let data = try? Data(contentsOf: url) {
                handle.write("\n\n---\n### \(url.deletingPathExtension().lastPathComponent)\n".data(using: .utf8)!)
                handle.write(data)
            }
        }
    }
}

scan(projectDir.appendingPathComponent("Vendor"))
scan(projectDir.appendingPathComponent(".packages")) // SwiftPM checkouts
try handle.close()
print("✅ Licenses aggregated at \(output.path)")
