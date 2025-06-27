#if targetEnvironment(macCatalyst)
import AppKit

/// Minimal Touch Bar interface providing Record / Stop segmented control.
final class TouchBarProvider: NSObject, NSTouchBarDelegate {
    private lazy var touchBar: NSTouchBar = {
        let bar = NSTouchBar()
        bar.delegate = self
        bar.defaultItemIdentifiers = [.recordSegment]
        return bar
    }()

    func makeTouchBar() -> NSTouchBar? { touchBar }

    // MARK: - NSTouchBarDelegate
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier id: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard id == .recordSegment else { return nil }
        let item = NSCustomTouchBarItem(identifier: id)
        let control = NSSegmentedControl(labels: ["Rec", "Stop"], trackingMode: .selectOne, target: self, action: #selector(segAction(_:)))
        item.view = control
        return item
    }

    @objc private func segAction(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            NotificationCenter.default.post(name: .startRecording, object: nil)
        } else {
            NotificationCenter.default.post(name: .stopRecording, object: nil)
        }
    }
}

extension NSTouchBarItem.Identifier {
    static let recordSegment = NSTouchBarItem.Identifier("ai.formavoice.recordSegment")
}
#endif
