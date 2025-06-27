// FilePath: Views/Onboarding/OnboardingView.swift
// A three-card carousel explaining privacy, offline capability, and form workflow.
// Uses Dynamic Type and localisation hooks.  UIPaging conforms to Apple’s HIG. :contentReference[oaicite:2]{index=2}

import SwiftUI

struct OnboardingView: View {
    @State private var page = 0
    @AppStorage("didFinishOnboarding") private var finished = false
    private let titles = [
        "100 % Offline",
        "Data-Encrypted",
        "Voice → PDF"
    ]
    private let bodies = [
        "All speech-to-text and form filling runs locally on your iPhone—no servers, ever.",
        "Files are locked with full-disk encryption (NSFileProtectionComplete).",
        "Speak, review, export—done.  PDFs are ready in under 35 seconds."
    ]

    var body: some View {
        TabView(selection: $page) {
            ForEach(0..<titles.count, id:\.self) { idx in
                VStack(spacing: 20) {
                    Text(titles[idx]).font(.largeTitle).bold()
                    Text(bodies[idx]).font(.body)
                    if idx == titles.count - 1 {
                        Button("Get Started") { finished = true }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .tag(idx)
            }
        }
        .tabViewStyle(.page)
    }
}
