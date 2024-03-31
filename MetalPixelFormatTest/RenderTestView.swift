//
// RenderTestView.swift
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

import SwiftUI

struct RenderTestView: View {

    let colorSpaceIdentifier: ColorSpaceIdentifier
    let pixelFormat: MTLPixelFormat

    var body: some View {
        RenderTestRepresentable(colorSpaceIdentifier: colorSpaceIdentifier, pixelFormat: pixelFormat)
    }

}

private struct RenderTestRepresentable: NSViewRepresentable {

    typealias Coordinator = RenderTestCoordinator?
    typealias NSViewType = MetalView

    let colorSpaceIdentifier: ColorSpaceIdentifier
    let pixelFormat: MTLPixelFormat

    func makeCoordinator() -> Coordinator {
        RenderTestCoordinator()
    }

    func makeNSView(context: Context) -> NSViewType {
        let metalView = MetalView()

        metalView.delegate = context.coordinator

        return metalView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        context.coordinator?.colorSpace = colorSpaceIdentifier.colorSpace
        context.coordinator?.pixelFormat = pixelFormat

        nsView.needsDisplay = true
    }

}

private final class RenderTestCoordinator: MetalViewDelegate {

    var colorSpace: CGColorSpace? = nil
    var pixelFormat: MTLPixelFormat = .bgra8Unorm

    let device: MTLDevice
    let library: MTLLibrary
    let function: MTLFunction
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLComputePipelineState

    init?() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let library = device.makeDefaultLibrary(),
              let function = library.makeFunction(name: "renderTest"),
              let commandQueue = device.makeCommandQueue() else { return nil }

        self.device = device
        self.library = library
        self.function = function
        self.commandQueue = commandQueue

        let descriptor = MTLComputePipelineDescriptor()

        descriptor.computeFunction = function
        descriptor.threadGroupSizeIsMultipleOfThreadExecutionWidth = true

        guard let pipelineState = try? device.makeComputePipelineState(descriptor: descriptor, options: [], reflection: nil) else { return nil }

        self.pipelineState = pipelineState
    }

    func makeCommandBuffer(drawable: CAMetalDrawable) -> MTLCommandBuffer? {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeComputeCommandEncoder() else { return nil }

        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setTexture(drawable.texture, index: 0)

        let workGroupWidth = pipelineState.threadExecutionWidth
        let workGroupHeight = pipelineState.maxTotalThreadsPerThreadgroup / workGroupWidth

        let threadsPerGrid = MTLSizeMake(drawable.texture.width, drawable.texture.height, 1)
        let threadsPerGroup = MTLSizeMake(workGroupWidth, workGroupHeight, 1)

        commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerGroup)
        commandEncoder.endEncoding()

        return commandBuffer
    }

}
