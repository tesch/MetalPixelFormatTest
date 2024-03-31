//
// MetalView.swift
//
// Created by Marcel Tesch on 2024-03-30.
// Think different.
//

import AppKit

protocol MetalViewDelegate: AnyObject {

    var device: MTLDevice { get }
    var colorSpace: CGColorSpace? { get }
    var pixelFormat: MTLPixelFormat { get }

    func makeCommandBuffer(drawable: CAMetalDrawable) -> MTLCommandBuffer?

}

final class MetalView: NSView {

    weak var delegate: (any MetalViewDelegate)?

    override init(frame: NSRect) {
        super.init(frame: frame)

        wantsLayer = true
        layerContentsRedrawPolicy = .duringViewResize
        layerContentsPlacement = .topLeft
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError()
    }

    override func makeBackingLayer() -> CALayer {
        let layer = CAMetalLayer()

        layer.delegate = self
        layer.displaySyncEnabled = true
        layer.needsDisplayOnBoundsChange = true
        layer.presentsWithTransaction = true
        layer.allowsNextDrawableTimeout = false
        layer.framebufferOnly = false

        return layer
    }

    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()

        resizeDrawable()
    }

    override func setFrameSize(_ size: NSSize) {
        super.setFrameSize(size)

        resizeDrawable()
    }

    override func setBoundsSize(_ size: NSSize) {
        super.setBoundsSize(size)

        resizeDrawable()
    }

}

extension MetalView: CALayerDelegate {

    func display(_ layer: CALayer) {
        guard let metalLayer, let delegate else { return }

        metalLayer.device = delegate.device
        metalLayer.colorspace = delegate.colorSpace
        metalLayer.pixelFormat = delegate.pixelFormat

        guard let drawable = metalLayer.nextDrawable(),
              let commandBuffer = delegate.makeCommandBuffer(drawable: drawable) else { return }

        commandBuffer.commit()
        commandBuffer.waitUntilScheduled()

        drawable.present()
    }

}

extension MetalView {

    private var metalLayer: CAMetalLayer? {
        layer as? CAMetalLayer
    }

    private var scaleFactor: CGFloat? {
        window?.backingScaleFactor
    }

    private var drawableSize: CGSize? {
        guard let scaleFactor else { return nil }

        let width = scaleFactor * bounds.width
        let height = scaleFactor * bounds.height

        return CGSize(width: width, height: height)
    }

    private func resizeDrawable() {
        guard let scaleFactor, let drawableSize else { return }

        metalLayer?.contentsScale = scaleFactor
        metalLayer?.drawableSize = drawableSize
    }

}
