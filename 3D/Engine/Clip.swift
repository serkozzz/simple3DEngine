//
//  Clip.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 11.09.2025.
//

import simd

/// Отсечение в clip-space (после PV*M, до деления на w)
final class Clip {

    /// Плоскость фрустума: a*x + b*y + c*z + d*w >= 0  (внутри)
    private struct Plane {
        let a: Float, b: Float, c: Float, d: Float
    }

    /// OpenGL-совместимые 6 плоскостей: -w ≤ x,y,z ≤ w
    private static let planes: [Plane] = [
        Plane(a:  1, b:  0, c:  0, d: 1), // w + x >= 0 (left)
        Plane(a: -1, b:  0, c:  0, d: 1), // w - x >= 0 (right)
        Plane(a:  0, b:  1, c:  0, d: 1), // w + y >= 0 (bottom)
        Plane(a:  0, b: -1, c:  0, d: 1), // w - y >= 0 (top)
        Plane(a:  0, b:  0, c:  1, d: 1), // w + z >= 0 (near)
        Plane(a:  0, b:  0, c: -1, d: 1)  // w - z >= 0 (far)
    ]

    @inline(__always) private static func f(_ p: SIMD4<Float>, _ pl: Plane) -> Float {
        pl.a*p.x + pl.b*p.y + pl.c*p.z + pl.d*p.w
    }

    @inline(__always) private static func lerp(_ a: SIMD4<Float>, _ b: SIMD4<Float>, _ t: Float) -> SIMD4<Float> {
        a + t * (b - a)
    }

    /// Отсечь отрезок AB по шести плоскостям фрустума в clip-space.
    /// - Returns: пара точек (A', B') в clip-space или nil, если целиком вне.
    static func clipLine(_ A: SIMD4<Float>, _ B: SIMD4<Float>) -> (SIMD4<Float>, SIMD4<Float>)? {
        var a = A, b = B
        for pl in planes {
            let fa = f(a, pl)
            let fb = f(b, pl)

            if fa < 0, fb < 0 {
                return nil // оба вне — выкидываем
            }
            if fa >= 0, fb >= 0 {
                continue // оба внутри — ничего не делаем
            }
            // Один внутри, другой вне — пересекаем с плоскостью
            // Ищем t: fa + t*(fb - fa) = 0  →  t = fa / (fa - fb)
            let t = fa / (fa - fb)
            let m = lerp(a, b, t)
            if fa < 0 { a = m } else { b = m }
        }
        return (a, b)
    }

    /// Утилита: клиппинг списка отрезков, заданного парами индексов.
    /// points — вершины в clip-space, edges — пары индексов (i,j)
    static func clipEdges(points: [SIMD4<Float>], edges: [(Int, Int)]) -> [(SIMD4<Float>, SIMD4<Float>)] {
        var out: [(SIMD4<Float>, SIMD4<Float>)] = []
        out.reserveCapacity(edges.count)
        for (i, j) in edges {
            guard i >= 0, j >= 0, i < points.count, j < points.count else { continue }
            if let seg = clipLine(points[i], points[j]) {
                out.append(seg)
            }
        }
        return out
    }
}
