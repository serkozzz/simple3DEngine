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
    
    
    nonisolated(unsafe) static let cube: Scene3D = {

        func makeFace(_ positions: [SIMD3<Float>]) -> Object3D {
            let vertexes = positions.map { Vertex3D(position: $0) }
            return Object3D(vertexes: vertexes)
        }

        let faces: [Object3D] = [
            // Задняя грань (z = -1)
            makeFace([
                SIMD3(-1, -1, -1),
                SIMD3(-1,  1, -1),
                SIMD3( 1,  1, -1),
                SIMD3( 1, -1, -1)
            ]),
            // Передняя грань (z = 1)
            makeFace([
                SIMD3(-1, -1,  1),
                SIMD3(-1,  1,  1),
                SIMD3( 1,  1,  1),
                SIMD3( 1, -1,  1)
            ]),
            // Левая грань (x = -1)
            makeFace([
                SIMD3(-1, -1, -1),
                SIMD3(-1,  1, -1),
                SIMD3(-1,  1,  1),
                SIMD3(-1, -1,  1)
            ]),
            // Правая грань (x = 1)
            makeFace([
                SIMD3( 1, -1, -1),
                SIMD3( 1,  1, -1),
                SIMD3( 1,  1,  1),
                SIMD3( 1, -1,  1)
            ]),
            // Верхняя грань (y = 1)
            makeFace([
                SIMD3(-1,  1, -1),
                SIMD3( 1,  1, -1),
                SIMD3( 1,  1,  1),
                SIMD3(-1,  1,  1)
            ]),
            // Нижняя грань (y = -1)
            makeFace([
                SIMD3(-1, -1, -1),
                SIMD3( 1, -1, -1),
                SIMD3( 1, -1,  1),
                SIMD3(-1, -1,  1)
            ])
        ]

        // Каждую грань заворачиваем в свой SceneNode3D
        let nodes = faces.map { SceneNode3D(object3D: $0) }

        return Scene3D(nodes: nodes, camera: .default)
    }()

}
