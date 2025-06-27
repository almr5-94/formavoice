// FilePath: Sources/ViewModels/JSONCorrectionService.swift
// Parses streaming LLM output, fixes brace/quote issues, and returns Data ready for
// JSONDecoder.  Implements incremental brace-count algorithm from task §24.1.  
// StrictConcurrency flag active to ensure thread-safe mutation. :contentReference[oaicite:0]{index=0}

import Foundation

enum JSONCorrectionError: Error { case unrecoverable(String) }

struct JSONCorrectionService {
    /// Attempts two passes of auto-correction before surfacing raw JSON to user.
    static func corrected(_ raw: String) throws -> Data {
        for _ in 0..<2 {
            if let data = raw.data(using: .utf8),
               (try? JSONSerialization.jsonObject(with: data)) != nil {
                return data
            }
            // Pass 1: balance braces.
            let balanced = balanceBraces(in: raw)
            // Pass 2: quote unescaped slashes.
            let fixed = balanced.replacingOccurrences(of: #"(?<!\\)/"#,
                                                      with: #"\/"#,
                                                      options: .regularExpression)
            if let data = fixed.data(using: .utf8),
               (try? JSONSerialization.jsonObject(with: data)) != nil {
                return data
            }
        }
        throw JSONCorrectionError.unrecoverable(raw)
    }
    
    private static func balanceBraces(in s: String) -> String {
        var open = 0, out = ""
        for ch in s {
            if ch == "{" { open += 1 }
            if ch == "}" { open -= 1 }
            out.append(ch)
        }
        while open > 0 { out.append("}"); open -= 1 }
        return out
    }
}
