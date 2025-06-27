// FilePath: Sources/Diagnostics/Log.swift
// Shorthand function for structured logging.

import Foundation
import os.log

@inlinable
func Log(_ log: OSLog, _ msg: StaticString, _ args: CVarArg...) {
    if args.isEmpty {
        os_log(msg, log: log, type: .default)
    } else {
        let formatted = String(format: String(describing: msg), arguments: args)
        os_log("%{public}@", log: log, type: .default, formatted)
    }
}
