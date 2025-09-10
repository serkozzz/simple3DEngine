//
//  Scene3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//
import SwiftUI

class Scene3D {
    var nodes: [SceneNode3D]
    var camera: Camera3D
    init(nodes: [SceneNode3D], camera: Camera3D) {
        self.nodes = nodes
        self.camera = camera
    }
}


extension Scene3D {
    
    nonisolated(unsafe) static let quad = {
        let vertexes = [
            Vertex3D(position: SIMD3(-1, -1, 0)),
            Vertex3D(position: SIMD3(-1, 1, 0)),
            Vertex3D(position: SIMD3(1, 1, 0)),
            Vertex3D(position: SIMD3(1, -1, 0))
        ]
        let object3D = Object3D(vertexes: vertexes)
        let sceneNode = SceneNode3D(object3D: object3D)
        return Scene3D(nodes: [sceneNode], camera: .default)
    }()
}
