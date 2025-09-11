//
//  Clip.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 11.09.2025.
//
import simd
struct Clipper {
    private struct Plane { let a: Float, b: Float, c: Float, d: Float }
    private static let planes: [Plane] = [
        Plane(a:  1, b:  0, c:  0, d: 1), // x >= -w
        Plane(a: -1, b:  0, c:  0, d: 1), // x <=  w
        Plane(a:  0, b:  1, c:  0, d: 1), // y >= -w (bottom)
        Plane(a:  0, b: -1, c:  0, d: 1), // y <=  w (top)
        Plane(a:  0, b:  0, c:  1, d: 1), // z >= -w (near)
        Plane(a:  0, b:  0, c: -1, d: 1), // z <=  w (far)
    ]
    private static let eps: Float = 1e-5

    @inline(__always) private static func eval(_ p: SIMD4<Float>, _ pl: Plane) -> Float {
        pl.a*p.x + pl.b*p.y + pl.c*p.z + pl.d*p.w
    }
    @inline(__always) private static func lerp(_ a: SIMD4<Float>, _ b: SIMD4<Float>, _ t: Float) -> SIMD4<Float> {
        a + t*(b - a)
    }

    private static func clipPolygonAgainstPlane(_ polygon: [SIMD4<Float>], plane: Plane, debugName: String? = nil) -> [SIMD4<Float>] {
        var output: [SIMD4<Float>] = []
        guard !polygon.isEmpty else { return output }

        let n = polygon.count
        for i in 0..<n {
            let S = polygon[i], E = polygon[(i+1) % n]
            let fS = eval(S, plane), fE = eval(E, plane)
            let Sinside = fS >= -eps
            let Einside = fE >= -eps

            if Sinside && Einside {
                output.append(E)
            } else if Sinside && !Einside {
                let t = fS / (fS - fE)
                output.append(lerp(S, E, t))
            } else if !Sinside && Einside {
                let t = fS / (fS - fE)
                output.append(lerp(S, E, t))
                output.append(E)
            }
        }
        return output
    }

    static func clipPolygon(_ polygon: [SIMD4<Float>]) -> [SIMD4<Float>] {
        var poly = polygon
        for (idx, pl) in planes.enumerated() {
            poly = clipPolygonAgainstPlane(poly, plane: pl, debugName: "\(idx)")
            if poly.isEmpty { break }
        }
        return poly
    }
}
