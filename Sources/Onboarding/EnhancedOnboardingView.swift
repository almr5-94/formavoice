// FilePath: Sources/Onboarding/EnhancedOnboardingView.swift
import SwiftUI
import AVFoundation

struct EnhancedOnboardingView: View {
    @EnvironmentObject private var router: Router
    @AppStorage("didFinishOnboarding") private var finished = false
    @State private var page = 0
    private let generator = UIImpactFeedbackGenerator(style: .rigid)
    
    private let content: [(String,String,String)] = [
        ("lock.shield", "Private & Offline",
         "FormaVoice never sends your voice to the cloud."),
        ("waveform", "Fast Dictation",
         "Speech-to-text works in real-time, even in Airplane Mode."),
        ("doc.richtext", "Instant PDF",
         "Review the fields and export a signed PDF in seconds.")
    ]
    
    var body: some View {
        TabView(selection: $page) {
            ForEach(0..<content.count, id: \.self) { idx in
                VStack(spacing: Spacing.s3) {
                    Image(systemName: content[idx].0)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .padding(.top, Spacing.s4)
                        .accessibilityHidden(true)
                    
                    Text(content[idx].1)
                        .font(FontTokens.title)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(content[idx].2)
                        .multilineTextAlignment(.center)
                        .font(FontTokens.body)
                        .padding(.horizontal, Spacing.s3)
                    
                    if idx == content.count - 1 {
                        FilledButton(label: "Get Started") {
                            generator.impactOccurred()
                            finished = true
                        }
                        .accessibilityIdentifier("onboardingStartButton")
                    }
                }
                .tag(idx)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorTokens.background)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onChange(of: page) { oldValue, newValue in
            if oldValue != newValue { generator.impactOccurred() }
        }
        .accessibilityElement(children: .contain)
    }
}

