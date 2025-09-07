//
//  SceneNode3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//
import simd

class SceneNode3D {
    var object3D: Object3D
    var transformationMatrix = matrix_identity_float4x4
    
    init(object3D: Object3D, transformationMatrix: float4x4 = matrix_identity_float4x4) {
        self.object3D = object3D
        self.transformationMatrix = transformationMatrix
    }
}
