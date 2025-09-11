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
    
    /// Стандартный lookAt (right-handed, column-major)
    init(lookFrom eye: SIMD3<Float>, to center: SIMD3<Float>, up worldUp: SIMD3<Float>) {
        let f = simd_normalize(center - eye)          // forward
        let s = simd_normalize(simd_cross(f, worldUp))// right
        let u = simd_cross(s, f)                      // recalculated up

        self = float4x4(
            SIMD4<Float>( s.x,  u.x, -f.x, 0),
            SIMD4<Float>( s.y,  u.y, -f.y, 0),
            SIMD4<Float>( s.z,  u.z, -f.z, 0),
            SIMD4<Float>(-simd_dot(s, eye),
                        -simd_dot(u, eye),
                         simd_dot(f, eye), 1)
        )
    }
}
