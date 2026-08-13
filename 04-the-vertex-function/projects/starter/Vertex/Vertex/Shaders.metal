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
    constant uint &count [[buffer(0)]],
    constant float &timer [[buffer(11)]],
    uint vertexID [[vertex_id]])
{
    float radius = 0.8;
    float current = float(vertexID) / float(count);
    float2 position;
    position.x = radius * cos(2 * M_PI_F * (current + timer));
    position.y = radius * sin(2 * M_PI_F * (current + timer));

    VertexOut out {
        .position = float4(position, 0, 1),
        .color = float4(1, 0.3, current, 1),
        .pointSize = 20
    };
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
       
