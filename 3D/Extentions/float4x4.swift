//
//  float4x4.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//
import simd

extension float4x4 {
    init(perspectiveProjection fovy: Float, aspect: Float, near: Float, far: Float) {
        let y = 1 / tan(fovy / 2)
        let x = y / aspect
        let z = far / (far - near)
        let w = -z * near
        self = float4x4(
            columns: (
                SIMD4(x, 0, 0, 0),
                SIMD4(0, y, 0, 0),
                SIMD4(0, 0, z, 1),
                SIMD4(0, 0, w, 0)
            )
        )
    }
    
    init(translation: SIMD3<Float>) {
        self = float4x4(
            columns: (
                SIMD4(1, 0, 0, 0),
                SIMD4(0, 1, 0, 0),
                SIMD4(0, 0, 1, 0),
                SIMD4(translation.x, translation.y, translation.z, 1)
            )
        )
    }
}
