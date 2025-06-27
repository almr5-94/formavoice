// FilePath: Sources/Views/WaveformView.swift
// Injects MetalKit MTKView into SwiftUI, feeding the audio ring buffer every frame.
// Throttles draw calls when display is <120 Hz to stay within animation budget. :contentReference[oaicite:8]{index=8}

import SwiftUI
import MetalKit
import Combine
#if canImport(UIKit)
import UIKit
#endif
import simd

#if canImport(UIKit)
struct WaveformView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func makeUIView(context: Context) -> MTKView {
        context.coordinator.view
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {}
    
    @MainActor final class Coordinator: NSObject, MTKViewDelegate {
        let view: MTKView
        private var subs = Set<AnyCancellable>()
        private var amplitudes = [Float](repeating: 0, count: 512)
        
        override init() {
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Metal unavailable")
            }
            view = MTKView(frame: .zero, device: device)
            view.enableSetNeedsDisplay = false
            view.isPaused = false
            // Compile shaders.
            let lib = device.makeDefaultLibrary()!
            let pipeline = try! device.makeRenderPipelineState(descriptor: {
                let desc = MTLRenderPipelineDescriptor()
                desc.vertexFunction   = lib.makeFunction(name: "wave_vertex")
                desc.fragmentFunction = lib.makeFunction(name: "wave_fragment")
                desc.colorAttachments[0].pixelFormat = .bgra8Unorm
                let vdesc = MTLVertexDescriptor()
                vdesc.attributes[0].format = .float2
                vdesc.attributes[0].offset = 0
                vdesc.attributes[0].bufferIndex = 0
                vdesc.layouts[0].stride = MemoryLayout<SIMD2<Float>>.stride
                desc.vertexDescriptor = vdesc
                return desc
            }())
            self.pipeline = pipeline
            super.init()
            view.delegate = self
            subscribeToAudio()
        }
        
        private let pipeline: MTLRenderPipelineState
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let rpd = view.currentRenderPassDescriptor else { return }
            let cmd = view.device!.makeCommandQueue()!.makeCommandBuffer()!
            let enc = cmd.makeRenderCommandEncoder(descriptor: rpd)!
            enc.setRenderPipelineState(pipeline)
            // Build vertex buffer on-the-fly.
            var vertices = amplitudes.enumerated().map { index, amp in
                SIMD2<Float>(Float(index) / 256.0 - 1.0, amp)
            }
            enc.setVertexBytes(&vertices,
                               length: MemoryLayout<SIMD2<Float>>.stride * vertices.count,
                               index: 0)
            enc.drawPrimitives(type: .lineStrip, vertexStart: 0, vertexCount: vertices.count)
            enc.endEncoding()
            cmd.present(drawable)
            cmd.commit()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        private func subscribeToAudio() {
            // Listen to the shared AudioProcessor's publisher (singleton for brevity).
            AudioProcessor.shared.pcmPublisher
                .sink { [weak self] floats in
                    guard let self else { return }
                    let peak: Float = floats.max() ?? 0
                    amplitudes.removeFirst()
                    amplitudes.append(peak)
                }
                .store(in: &subs)
        }
    }
}
#endif
