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
    
    init(rotationYXZ angles: SIMD3<Float>) {
            let (x, y, z) = (angles.x, angles.y, angles.z)
            let cosX = cos(x), sinX = sin(x)
            let cosY = cos(y), sinY = sin(y)
            let cosZ = cos(z), sinZ = sin(z)
            
            let rotY = float4x4(columns: (
                SIMD4(cosY, 0, sinY, 0),
                SIMD4(0, 1, 0, 0),
                SIMD4(-sinY, 0, cosY, 0),
                SIMD4(0, 0, 0, 1)
            ))
            let rotX = float4x4(columns: (
                SIMD4(1, 0, 0, 0),
                SIMD4(0, cosX, -sinX, 0),
                SIMD4(0, sinX, cosX, 0),
                SIMD4(0, 0, 0, 1)
            ))
            let rotZ = float4x4(columns: (
                SIMD4(cosZ, -sinZ, 0, 0),
                SIMD4(sinZ, cosZ, 0, 0),
                SIMD4(0, 0, 1, 0),
                SIMD4(0, 0, 0, 1)
            ))
            self = rotY * rotX * rotZ
        }
}
