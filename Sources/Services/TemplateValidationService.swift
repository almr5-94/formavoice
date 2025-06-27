// FilePath: Sources/Services/TemplateValidationService.swift
// Guards against duplicate keys and overly long field names (>80 chars).  
// Helps prevent PDF overflow before reaching UIGraphicsPDFRenderer. :contentReference[oaicite:4]{index=4}

import Foundation

enum TemplateValidationError: Error {
    case duplicateField(String)
    case fieldTooLong(String)
}

struct TemplateValidationService {
    static func validate(_ template: FormTemplate) throws {
        var set = Set<String>()
        for field in template.fields {
            if field.count > 80 { throw TemplateValidationError.fieldTooLong(field) }
            if !set.insert(field).inserted { throw TemplateValidationError.duplicateField(field) }
        }
    }
}
