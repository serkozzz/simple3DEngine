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
    @State private var cameraMover: CameraMover3D
    
    init(camera: Camera3D, onCameraChanged: (() -> Void)?) {
        self.camera = camera
        self.onCameraChanged = onCameraChanged
        self._cameraMover = State(wrappedValue: CameraMover3D(camera: camera, onCameraMoved: onCameraChanged))
        
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
