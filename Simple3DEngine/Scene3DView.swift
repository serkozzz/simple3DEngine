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
            AnimatableEmitter(value: camZ) { newValue in
                scene3D.camera.position.z = newValue
                print("newValue: \(newValue)")
                renderFrame()
            }
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
                dragGesture
           )
            joystick
        }
        .padding()
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
        camZ = scene3D.camera.position.z
        withAnimation(.easeInOut(duration: 1)) {
            camZ += dz
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let camera = scene3D.camera
                withAnimation(.easeInOut(duration: 0.1)) {
                    camera.yaw -= Float(value.translation.width - dragOffset.width) * 0.01
                    camera.pitch -= Float(value.translation.height - dragOffset.height) * 0.01
                    dragOffset = value.translation
                    renderFrame()
                }
            }
            .onEnded { _ in
                dragOffset = .zero
            }
    }
    
    func renderFrame() {
        guard let viewportSize else  { return }
        let res = engine3D.objects2D(from: scene3D, screenSize: CGSize(width: viewportSize.width, height: viewportSize.width)).first
        print(res)
        object2D = res
        print(object2D)
    }

}

#Preview {
    Scene3DView()
}
