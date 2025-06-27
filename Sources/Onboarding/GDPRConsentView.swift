import SwiftUI

/// One-time privacy notice shown on first launch for GDPR compliance.
struct GDPRConsentView: View {
    @AppStorage("gdprAccepted") private var accepted = false
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hand.raised.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text("Your Privacy")
                .font(.title2).bold()
                .accessibilityAddTraits(.isHeader)

            Text("""
FormaVoice performs every operation **offline**. No voice, text, or document ever leaves this device. By tapping **Agree**, you confirm that you have read and understood this notice.
""")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Agree") {
                accepted = true
                onContinue()
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Agree and continue")
        }
        .padding()
        .frame(maxWidth: 450)
        .accessibilityElement(children: .contain)
    }
}
