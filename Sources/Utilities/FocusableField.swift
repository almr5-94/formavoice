import SwiftUI

// FocusableField helps manage keyboard focus across multiple dynamic fields.
enum FocusableField: Hashable {
    case key(String)     // Field identifier, typically the field label or key
}

/// ViewModifier that cycles focus through a collection of focusable fields using the keyboard toolbar.
struct FocusFieldModifier<S: Hashable>: ViewModifier {
    @FocusState private var focus: S?
    let fields: [S]

    func body(content: Content) -> some View {
        content
            .onAppear { focus = fields.first }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Prev")  { move(-1) }
                        .disabled(isFirst)
                    Button("Next")  { move(+1) }
                        .disabled(isLast)
                    Spacer()
                    Button("Done")  { focus = nil }
                        .bold()
                }
            }
            .focused($focus, equals: focus)
    }

    private var index: Int { fields.firstIndex(of: focus ?? fields.first!) ?? 0 }
    private var isFirst: Bool { index == 0 }
    private var isLast:  Bool { index == fields.endIndex - 1 }
    private func move(_ delta: Int) {
        if let next = fields[safe: index + delta] {
            focus = next
        }
    }
}

// Safe collection subscript to avoid out-of-range crashes.
private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
