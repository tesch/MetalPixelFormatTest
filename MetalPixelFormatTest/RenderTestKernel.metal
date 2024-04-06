//
// RenderTestKernel.metal
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

#include <metal_stdlib>
using namespace metal;

kernel void renderTest(const texture2d<int, access::write> texture [[ texture(0) ]],
                       const uint2 index [[ thread_position_in_grid ]])
{
    int4 color = int4(127, 127, 127, 255);

    texture.write(color, index);
}
