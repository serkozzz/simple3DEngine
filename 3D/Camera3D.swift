//
//  Camera3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import simd

final class Camera3D {
    var position: SIMD3<Float> { didSet { updateViewMatrix() } }
    var yaw: Float = 0   { didSet { updateViewMatrix() } } // вращение вокруг Y (горизонт)
    var pitch: Float = 0 { didSet { updateViewMatrix() } } // вращение вокруг локального right

    private var fovy: Float
    private var aspect: Float
    private var near: Float
    private var far: Float

    private(set) var viewMatrix = matrix_identity_float4x4
    private(set) var perspectiveMatrix = matrix_identity_float4x4

    init(position: SIMD3<Float>, fovy: Float, aspect: Float, near: Float, far: Float) {
        self.position = position
        self.fovy = fovy
        self.aspect = aspect
        self.near = near
        self.far = far
        updateViewMatrix()
        updatePerspectiveMatrix()
    }

    func setAspect(aspect: Float) {
        self.aspect = aspect
        updatePerspectiveMatrix()
    }

    private func updateViewMatrix() {
        // ограничим pitch, чтобы не «перекувыркнуться»
        let lim: Float = .pi/2 - 0.001
        if pitch >  lim { pitch =  lim }
        if pitch < -lim { pitch = -lim }

        let cp = cos(pitch), sp = sin(pitch)
        let cy = cos(yaw),   sy = sin(yaw)

        // Теперь "вперёд" = −Z при yaw=0, pitch=0
        let front = simd_normalize(SIMD3<Float>( sy*cp, sp, -cy*cp ))
        let up    = SIMD3<Float>(0, 1, 0)

        viewMatrix = float4x4(lookFrom: position, to: position + front, up: up)
    }

    private func updatePerspectiveMatrix() {
        perspectiveMatrix = float4x4(
            perspectiveProjection: fovy,
            aspect: aspect,
            near: near,
            far: far
        )
    }

    nonisolated(unsafe) static let `default`: Camera3D = {
        Camera3D(position: [0, 0, 5], fovy: .pi/6, aspect: 1, near: 0.5, far: 100)
    }()
}

