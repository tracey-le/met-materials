///// Copyright (c) 2025 Kodeco Inc.

// swiftlint:disable implicitly_unwrapped_optional

import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!

    lazy var quad: Quad = {
        Quad(device: Self.device, scale: 0.8)
    }()
    
    var timer: Float = 0

    init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
    Self.device = device
    Self.commandQueue = commandQueue
    metalView.device = device

    // create the shader function library
    let library = device.makeDefaultLibrary()
    Self.library = library
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction =
      library?.makeFunction(name: "fragment_main")

    // create the pipeline state object
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
    pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout

    do {
      pipelineState =
        try device.makeRenderPipelineState(
          descriptor: pipelineDescriptor)
    } catch {
        fatalError(error.localizedDescription)
    }
    super.init()
    metalView.clearColor = MTLClearColor(
      red: 1.0,
      green: 0.6,
      blue: 0.8,
      alpha: 1.0)
    metalView.delegate = self
  }
}

extension Renderer: MTKViewDelegate {
    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {
        
    }

    func draw(in view: MTKView) {
        guard
          let commandBuffer = Self.commandQueue.makeCommandBuffer(),
          let descriptor = view.currentRenderPassDescriptor,
          let renderEncoder =
            commandBuffer.makeRenderCommandEncoder(
              descriptor: descriptor) else {
            return
        }

        timer += 0.05
        var currentTime = sin(timer)
        renderEncoder.setVertexBytes(
            &currentTime,
            length: MemoryLayout<Float>.stride,
            index: 11)

        renderEncoder.setRenderPipelineState(pipelineState)

        // do drawing here
        renderEncoder.setVertexBuffer(
            quad.vertexBuffer,
            offset: 0,
            index: 0)
        
        renderEncoder.setVertexBuffer(
            quad.colorBuffer,
            offset: 0,
            index: 1)

        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: quad.indices.count,
            indexType: .uint16,
            indexBuffer: quad.indexBuffer,
            indexBufferOffset: 0)

        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
          return
        }
        commandBuffer.present(drawable)
            commandBuffer.commit()
    }
}

// swiftlint:enable implicitly_unwrapped_optional
