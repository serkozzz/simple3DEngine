//
//  ContentView.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import SwiftUI

struct Scene3DView: View {
    @State private var object2D: Object2D?
    @State private var scene3D: Scene3D = Scene3D.quad
    
    @State private var viewportSize: CGSize?
    @State private var dragOffset: CGSize = .zero
    
    @State private var camZ: Float = 0
    
    var body: some View {
        VStack {
            Group {
                if let object2D {
                    ShapeFrom3D(object2D: object2D)
                        .stroke(.black)
                        .background(.yellow)
                }
            }
            .onGeometryChange (for: CGSize.self, of: { proxy in proxy.size}) { size in
                viewportSize = size
                renderFrame()
                
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let camera = scene3D.camera
                        withAnimation(.easeInOut(duration: 0.1)) {
                            camera.yaw -= Float(value.translation.width - dragOffset.width) * 0.01
                            camera.pitch -= Float(value.translation.height - dragOffset.height) * 0.01
                            camera.updateViewMatrix()
                            dragOffset = value.translation
                            renderFrame()
                        }
                    }
                    .onEnded { _ in
//                        dragOffset = .zero
                    }
           )
            joystick
        }
        .padding()
    }
    
    func renderFrame() {
        guard let viewportSize else  { return }
        object2D = engine3D.objects2D(from: scene3D, screenSize: CGSize(width: viewportSize.width, height: viewportSize.width)).first
        print(object2D)
    }
    
    private var joystick: some View {
        HStack {
            Button("Forward") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scene3D.camera.position.z -= 0.5
                    scene3D.camera.updateViewMatrix()
                    renderFrame()
                    
                }
            }
            Button("Backward") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scene3D.camera.position.z += 0.5
                    scene3D.camera.updateViewMatrix()
                    renderFrame()
                }
            }
            Button("Left") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scene3D.camera.position.x -= 0.5
                    scene3D.camera.updateViewMatrix()
                    renderFrame()
                }
            }
            Button("Right") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scene3D.camera.position.x += 0.5
                    scene3D.camera.updateViewMatrix()
                    renderFrame()
                }
            }
        }
    }
}

#Preview {
    Scene3DView()
}
