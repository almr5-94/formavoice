// FilePath: Sources/Metal/WaveFragment.metal
// Simple fragment shader renders solid accent color picked from SwiftUI via
// MTLClearColor bridging.  :contentReference[oaicite:7]{index=7}

#include <metal_stdlib>
using namespace metal;

fragment float4 wave_fragment() {
    return float4(0.0, 0.6, 1.0, 1.0); // Color overridden by MTLRenderCommandEncoder.setFragmentBytes.
}
