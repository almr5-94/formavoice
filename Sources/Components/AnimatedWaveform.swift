// FilePath: Sources/Components/AnimatedWaveform.swift
import SwiftUI
import MetalKit

struct AnimatedWaveform: View {
    @State private var phase: Double = 0
    let amplitudes: [Float]
    
    var body: some View {
        Canvas { ctx, size in
            ctx.translateBy(x: 0, y: size.height / 2)
            var path = Path()
            for (x, amp) in amplitudes.enumerated() {
                let dx = CGFloat(x) / CGFloat(amplitudes.count) * size.width
                let dy = CGFloat(amp) * size.height / 2
                path.addLine(to: CGPoint(x: dx, y: -dy))
            }
            ctx.stroke(path, with: .color(ColorTokens.accent), lineWidth: 2)
        }
        .frame(height: 120)
        .accessibilityLabel("Live audio waveform")
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}
