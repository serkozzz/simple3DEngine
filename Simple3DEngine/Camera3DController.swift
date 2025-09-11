//
//  CameraController.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 11.09.2025.
//

import SwiftUI

struct Camera3DController: ViewModifier {
    
    let camera: Camera3D
    let onCameraChanged: (() -> Void)?
    @State private var dragOffset: CGSize = .zero
    @State private var camXZ: AnimatablePair<Float, Float>
    
    init(camera: Camera3D, onCameraChanged: (() -> Void)?) {
        self.camera = camera
        self.onCameraChanged = onCameraChanged
        _camXZ = State(initialValue: AnimatablePair(camera.position.x, camera.position.z))
    }
    
    func body(content: Content) -> some View {
        
        VStack {
            content
                .gesture(
                    dragGesture
               )
            AnimatableEmitter(value: camXZ) { newValue in
                camera.position.x = newValue.first
                camera.position.z = newValue.second
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
        withAnimation(.easeInOut(duration: 1)) {
            camXZ = AnimatablePair(camXZ.first + dx, camXZ.second + dz)
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.easeInOut(duration: 0.1)) {
                    camera.yaw += Float(value.translation.width - dragOffset.width) * 0.01
                    camera.pitch += Float(value.translation.height - dragOffset.height) * 0.01
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
