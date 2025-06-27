// FilePath: Sources/Diagnostics/Logger.swift
// Wrapper around os_log with privacy-sensitive redaction preset.

import os.log

enum Logger {
    private static let subsystem = "ai.formavoice.app"
    
    static let ui     = OSLog(subsystem: subsystem, category: "UI")
    static let stt    = OSLog(subsystem: subsystem, category: "STT")
    static let llm    = OSLog(subsystem: subsystem, category: "LLM")
}
