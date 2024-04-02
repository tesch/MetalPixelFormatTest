//
// RenderTestKernel.metal
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

#include <metal_stdlib>
using namespace metal;

kernel void renderTest(const texture2d<float, access::write> texture [[ texture(0) ]],
                       constant const float4& color [[ buffer(1) ]],
                       const uint2 index [[ thread_position_in_grid ]])
{
    texture.write(color, index);
}
