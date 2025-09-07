//
//  Camera3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import simd

class Camera3D {
    
    var position: SIMD3<Float>
    var yaw: Float = 0 // Вращение вокруг Y (горизонт)
    var pitch: Float = 0 // Вращение вокруг X (вертикаль)
    var fovy: Float

    
    init(position: SIMD3<Float>, fovy: Float, aspect: Float, near: Float, far: Float) {
        self.position = position
        self.fovy = fovy
        self.viewMatrix = matrix_identity_float4x4
        self.perspectiveMatrix = float4x4(perspectiveProjection: fovy, aspect: aspect, near: near, far: far)
        updateViewMatrix()
    }
    
    func updateViewMatrix() {
        let rotation = float4x4(rotationYXZ: SIMD3(-pitch, -yaw, 0))
        let translation = float4x4(translation: -position)
        self.viewMatrix = rotation * translation
    }
    
    
    private(set) var viewMatrix = matrix_identity_float4x4
    private(set) var perspectiveMatrix = matrix_identity_float4x4
    
    
    static let `default`: Camera3D = {
        return Camera3D(position: [0,0,-5], fovy: Float.pi / 4, aspect: 1, near: 0.1, far: 100)
    }()
}
