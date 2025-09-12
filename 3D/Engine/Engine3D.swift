//
//  Engine3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//
import simd
import Foundation

class Engine3D {
    
    //result in [-1:1]
    func objects2D(from scene: Scene3D, screenSize: CGSize) -> [Object2D] {
        var result: [Object2D] = []
        let camera = scene.camera

        for node in scene.nodes {
            let M = node.transformationMatrix
            let V = camera.viewMatrix
            let P = camera.perspectiveMatrix
            let obj = node.object3D

            // Исходный многоугольник (вершины в clip space)
            let notClippedVerts = obj.vertexes.map { v -> SIMD4<Float> in
                let pos = SIMD4<Float>(v.position, 1)
                let clip = P * (V * (M * pos))
                //print("y/w =", clip.y / clip.w)
                return clip
            }

            // Клиппинг всего многоугольника
            let clipped = Clipper.clipPolygon(notClippedVerts)
            guard !clipped.isEmpty else { continue }

            // Деление на w и проекция в экран
            let screenPoints = clipped.map { v -> CGPoint in
                let ndc = v / v.w
                return CGPoint(
                    x: CGFloat((ndc.x * 0.5 + 0.5) * Float(screenSize.width)),
                    y: CGFloat(((ndc.y) * 0.5 + 0.5) * Float(screenSize.height)) // y инвертирован
                )
            }
            result.append(Object2D(points: screenPoints))
        }

        return result
    }

}


@MainActor let engine3D = Engine3D()


