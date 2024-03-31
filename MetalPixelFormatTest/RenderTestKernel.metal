//
// RenderTestKernel.metal
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

#include <metal_stdlib>
using namespace metal;

kernel void renderTest(const texture2d<float, access::write> texture [[ texture(0) ]],
                       const uint2 index [[ thread_position_in_grid ]])
{
    const float4 color = float4(0.5f, 0.5f, 0.5f, 1.0f);

    texture.write(color, index);
}
