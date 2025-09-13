//
//  CameraController.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 11.09.2025.
//

import SwiftUI
import simd

struct Camera3DController: ViewModifier {
    
    let camera: Camera3D
    let onCameraChanged: (() -> Void)?
    @State private var dragOffset: CGSize = .zero
    @State private var camXYZ: AnimatablePair<Float, AnimatablePair<Float, Float>>
    @State private var cameraMover: CameraMover3D
    
    init(camera: Camera3D, onCameraChanged: (() -> Void)?) {
        self.camera = camera
        self.onCameraChanged = onCameraChanged
        self._cameraMover = State(wrappedValue: CameraMover3D(camera: camera, onCameraMoved: onCameraChanged))
        
        _camXYZ = State(initialValue: AnimatablePair(camera.position.x, AnimatablePair(camera.position.y, camera.position.z)))
    }
    
    func body(content: Content) -> some View {
        print("Camera3DController.body")
        return VStack {
            ZStack(alignment: .bottomTrailing) {
                content
                    .contentShape(Rectangle())
                    .gesture(
                        dragGesture
                    )
                Joystick(delegate: cameraMover)
                    .frame(width: 100, height: 100)
            }
            .background(.yellow)
            AnimatableEmitter(value: camXYZ) { newValue in
                camera.position.x = newValue.first
                camera.position.y = newValue.second.first
                camera.position.z = newValue.second.second
                print("newValue: \(newValue)")
                onCameraChanged?()
            }
         
            joystick
        }
    }
    
    
    private var joystick: some View {
        HStack {
            Button("Forward") {
                moveCamera(dz: 0.5)
            }
            Button("Backward") {
                moveCamera(dz: -0.5)
            }
            Button("Left") {
                moveCamera(dx: -0.5)
            }
            Button("Right") {
                moveCamera(dx: 0.5)
            }
        }
    }
    
    func moveCamera(dx: Float = 0, dz: Float = 0) {
        let inversedMatrix = camera.viewMatrix.inverse

        
        let forward = (-1) * simd_normalize(SIMD3(inversedMatrix.columns.2.x,
                                           inversedMatrix.columns.2.y,
                                           inversedMatrix.columns.2.z))
        let up = SIMD3<Float>(0, 1, 0)
        let right = simd_normalize(simd_cross(forward, up))

        let d = right * dx + forward * dz
        
        withAnimation(.easeInOut(duration: 1)) {
            camXYZ = AnimatablePair(camXYZ.first + d.x, AnimatablePair(camXYZ.second.first + d.y, camXYZ.second.second + d.z))
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.easeInOut(duration: 0.1)) {
                    camera.yaw += Float(value.translation.width - dragOffset.width) * 0.01
                    camera.pitch -= Float(value.translation.height - dragOffset.height) * 0.01
                    dragOffset = value.translation
                    onCameraChanged?()
                }
            }
            .onEnded { _ in
                dragOffset = .zero
            }
    }
}

extension View {
    func camera3DController(_ camera: Camera3D, onCameraChanged: (() -> Void)? = nil) -> some View {
        self.modifier(Camera3DController(camera: camera, onCameraChanged: onCameraChanged))
    }
}

#Preview {
    Scene3DView()
}
