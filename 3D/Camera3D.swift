//
//  Camera3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import simd

class Camera3D {
    var viewMatrix = matrix_identity_float4x4
    var perspectiveMatrix = matrix_identity_float4x4
    
    init(viewMatrix: simd_float4x4, perspectiveMatrix: simd_float4x4) {
        self.viewMatrix = viewMatrix
        self.perspectiveMatrix = perspectiveMatrix
    }
    
    static let `default`: Camera3D = {
        var projectionMatrix = float4x4(perspectiveProjection: Float.pi / 4, aspect: 1, near: 0.1, far: 100)
        var viewMatrix = float4x4(translation: [0, 0, -5])
        return Camera3D(viewMatrix: viewMatrix, perspectiveMatrix: projectionMatrix)
    }()
}
