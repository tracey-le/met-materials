///// Copyright (c) 2025 Kodeco Inc.

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float pointSize [[point_size]];
};

vertex VertexOut vertex_main(
    VertexIn in [[stage_in]],
    constant float &timer [[buffer(11)]])
{
    VertexOut out {
        .position = in.position,
        .color = in.color,
        .pointSize = 30
    };
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
