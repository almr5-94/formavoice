// FilePath: Sources/Metal/WaveVertex.metal
// Vertex shader creates a scrolling horizontal line strip from normalized
// audio amplitudes. Metal provides low-power 60 FPS rendering.  
// Apple encourages simple single-buffer reuse for dynamic geometry. :contentReference[oaicite:6]{index=6}

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut wave_vertex(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = float4(in.position, 0.0, 1.0);
    return out;
}
