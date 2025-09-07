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
            let transformationMatrix = node.transformationMatrix
            let viewMatrix = camera.viewMatrix
            let perspectiveMatrix = camera.perspectiveMatrix
            let object3D = node.object3D
            
            var resultPoints: [CGPoint] = []
            
            for vertex in object3D.vertexes {
                let position4 = SIMD4<Float>(vertex.position, 1)
                let transformedPosition = transformationMatrix * position4
                let positionInViewSpace = viewMatrix * transformedPosition
                let projected = perspectiveMatrix * positionInViewSpace
                let normalized = projected / projected.w
    
                let resultPoint: CGPoint = CGPoint(
                    x: CGFloat((normalized.x + 1) * 0.5 * Float(screenSize.width)),
                    y: CGFloat((1 - normalized.y) * 0.5 * Float(screenSize.height))
                )
                
                resultPoints.append(resultPoint)
            }
            result.append(Object2D(points: resultPoints))
        }
        return result
    }
}


let engine3D = Engine3D()
