// FilePath: Sources/Utilities/Dispatch+MainSafe.swift
// Tiny helper that executes closures on the main actor if not already there.

import Foundation

@inlinable
func mainSafe(_ work: @escaping @Sendable () -> Void) {
    if Thread.isMainThread { work() }
    else { Task { @MainActor in work() } }
}
