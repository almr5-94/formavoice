import SwiftData
import Foundation

extension ModelContext {
    /// Singleton ModelContext for non-UI utility calls (tests, background managers).
    /// UI Views should prefer `@Environment(\.modelContext)` but legacy code expects
    /// `ModelContext.current` so we expose both.
    @MainActor
    public static let shared: ModelContext = {
        // Lazily create a container including all @Model types.
        let schema = Schema([
            FormTemplate.self,
            RecordingSession.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: schema, configurations: [config])
        return ModelContext(container)
    }()

    @MainActor public static var current: ModelContext? { shared }
} 