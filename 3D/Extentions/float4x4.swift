//
//  float4x4.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//
import simd

extension float4x4 {
    init(perspectiveGL fovy: Float, aspect: Float, near: Float, far: Float) {
        let yScale = 1 / tan(fovy * 0.5)
        let xScale = yScale / aspect
        let zRange = near - far

        let zz = (far + near) / zRange      // = (f+n)/(n−f)
        let zw = (2 * far * near) / zRange  // = (2fn)/(n−f)

        self = float4x4(
            columns: (
                SIMD4(xScale, 0,      0,   0),
                SIMD4(0,      yScale, 0,   0),
                SIMD4(0,      0,      zz, -1),
                SIMD4(0,      0,      zw,  0)
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
        let r = simd_normalize(simd_cross(f, worldUp))// right
        let u = simd_normalize(simd_cross(r, f))                   // recalculated up
        
        self = float4x4(
            columns: (
                SIMD4( r.x,  u.x, -f.x, 0),
                SIMD4( r.y,  u.y, -f.y, 0),
                SIMD4( r.z,  u.z, -f.z, 0),
                SIMD4(-simd_dot(r, eye),
                                -simd_dot(u, eye),
                                    simd_dot(f, eye), 1)
            )
        )
        
        //        let transformMatrix = float4x4(
        //            columns: (
        //                SIMD4( r.x,  r.y, r.z, 0),
        //                SIMD4( u.x,  u.y, u.z, 0),
        //                SIMD4( -f.x, -f.y, -f.z, 0),
        //                SIMD4(eye.x, eye.y, eye.z, 1)
        //            )
        //        )
        //
        //        self = transformMatrix.inverse
    }
}
