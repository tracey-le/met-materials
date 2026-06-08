///// Copyright (c) 2025 Kodeco Inc.

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(
    constant packed_float3 *vertices [[buffer(0)]],
    constant ushort *indices [[buffer(1)]],
    constant float &timer [[buffer(11)]],
    uint vertexID [[vertex_id]])
{
    ushort index = indices[vertexID];
    float4 position = float4(vertices[index], 1);
    position.y += timer;
    return position;
}

fragment float4 fragment_main() {
    return float4(0.9, 0.4, 0.7, 1);
}
