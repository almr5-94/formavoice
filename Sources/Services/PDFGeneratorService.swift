// FilePath: Sources/Services/PDFGeneratorService.swift
// Generates A4/Letter PDFs via UIGraphicsPDFRenderer following Apple's official guidance.

#if canImport(UIKit)
import UIKit

struct PDFGeneratorService {
    static func generate(fields: [String: String], template: FormTemplate) throws -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            String(kCGPDFContextCreator): "FormaVoice",
            String(kCGPDFContextTitle): template.title
        ]
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792),
                                             format: format) // Letter size 72 dpi.
        return renderer.pdfData { ctx in
            ctx.beginPage()
            var y: CGFloat = 36
            let leftMargin: CGFloat = 48
            let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
            let bodyFont  = UIFont.systemFont(ofSize: 12)
            
            for (key, value) in fields.sorted(by: { $0.key < $1.key }) {
                let title = "\(key):"
                title.draw(at: CGPoint(x: leftMargin, y: y), withAttributes: [.font: titleFont])
                
                let valueOrigin = CGPoint(x: leftMargin + 180, y: y)
                value.draw(at: valueOrigin, withAttributes: [.font: bodyFont])
                y += 22
            }
        }
    }
}
#else
import Foundation
struct PDFGeneratorService {
    static func generate(fields: [String: String], template: FormTemplate) throws -> Data {
        throw NSError(domain: "PDFGeneratorService", code: 0, userInfo: [NSLocalizedDescriptionKey: "PDF generation is only available on platforms that support UIKit."])
    }
}
#endif
