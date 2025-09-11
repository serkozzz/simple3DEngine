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
    
    
    nonisolated(unsafe) static let pyramid: Scene3D = {
        // удобная функция для Object3D
        func makeFace(_ positions: [SIMD3<Float>]) -> Object3D {
            let vertexes = positions.map { Vertex3D(position: $0) }
            return Object3D(vertexes: vertexes)
        }

        let apex = SIMD3<Float>(0, 1, 0) // вершина пирамиды (вверх)
        
        // Основание (квадрат на y = -1)
        let base = makeFace([
            SIMD3(-1, -1, -1),
            SIMD3( 1, -1, -1),
            SIMD3( 1, -1,  1),
            SIMD3(-1, -1,  1)
        ])

        // 4 боковые треугольные грани
        let front = makeFace([
            SIMD3(-1, -1,  1),
            SIMD3( 1, -1,  1),
            apex
        ])
        
        let back = makeFace([
            SIMD3(-1, -1, -1),
            SIMD3( 1, -1, -1),
            apex
        ])
        
        let left = makeFace([
            SIMD3(-1, -1, -1),
            SIMD3(-1, -1,  1),
            apex
        ])
        
        let right = makeFace([
            SIMD3( 1, -1, -1),
            SIMD3( 1, -1,  1),
            apex
        ])
        
        let nodes = [
            SceneNode3D(object3D: base),
            SceneNode3D(object3D: front),
            SceneNode3D(object3D: back),
            SceneNode3D(object3D: left),
            SceneNode3D(object3D: right)
        ]
        
        return Scene3D(nodes: nodes, camera: .default)
    }()


}
