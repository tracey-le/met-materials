///// Copyright (c) 2025 Kodeco Inc.

// swiftlint:disable colon

import MetalKit

struct Vertex {
  var x: Float
  var y: Float
  var z: Float
}

struct Triangle {
  var vertices: [Vertex] = [
    Vertex(x: -0.7, y:  0.8, z: 0),
    Vertex(x: -0.7, y: -0.5, z: 0),
    Vertex(x:  0.4, y:  0.1, z: 0)
  ]

  var indices: [UInt16] = [
    0, 1, 2
  ]

  let vertexBuffer: MTLBuffer
  let indexBuffer: MTLBuffer

  init(device: MTLDevice, scale: Float = 1) {
    vertices = vertices.map {
      Vertex(x: $0.x * scale, y: $0.y * scale, z: $0.z * scale)
    }
    guard let vertexBuffer = device.makeBuffer(
      bytes: &vertices,
      length: MemoryLayout<Vertex>.stride * vertices.count,
      options: []) else {
      fatalError("Unable to create vertex buffer")
    }
    self.vertexBuffer = vertexBuffer

    guard let indexBuffer = device.makeBuffer(
      bytes: &indices,
      length: MemoryLayout<UInt16>.stride * indices.count,
      options: []) else {
      fatalError("Unable to create index buffer")
    }
    self.indexBuffer = indexBuffer
  }
}

// swiftlint:enable colon
