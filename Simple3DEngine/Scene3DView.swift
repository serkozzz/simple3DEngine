//
//  ContentView.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import SwiftUI


struct Scene3DViewWithCamera: View {
    
    @State private var scene3D: Scene3D
    
    @State private var dragOffset: CGSize = .zero
    @State private var cameraX: Float
    @State private var cameraZ: Float
    
    init() {
        let scene3D = Scene3D.quad
        _scene3D = State(initialValue: scene3D)
        _cameraX = State(initialValue: scene3D.camera.position.x)
        _cameraZ = State(initialValue: scene3D.camera.position.z)
    }
    
    var body: some View {
        Scene3DView(scene3D: scene3D, cameraX: cameraX, cameraZ: cameraZ)
            .gesture(
                dragGesture
            )
        joystick
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
        
        cameraX = scene3D.camera.position.x
        cameraZ = scene3D.camera.position.z
        withAnimation(.easeInOut(duration: 1)) {
            cameraX += dx
            cameraZ += dz
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
                    //renderFrame()
                }
            }
            .onEnded { _ in
                dragOffset = .zero
            }
    }
}


struct Scene3DView: Animatable, View {
    
    var scene3D: Scene3D
    
    @State private var object2D: Object2D?
    @State private var viewportSize: CGSize = CGSize(width: 400, height: 400)
    
    @State var cameraX: Float
    @State var cameraZ: Float
    
    var animatableData: AnimatablePair<Float, Float>  {
        get { AnimatablePair(cameraX, cameraZ) }
        set {
            DispatchQueue.main.async { [self] in
                cameraX = newValue.first
                cameraZ = newValue.second
                scene3D.camera.position.x = newValue.first
                scene3D.camera.position.z = newValue.second
                renderFrame()
                print("animatableData set \(scene3D.camera.position.x), \(scene3D.camera.position.z) ")
            }
        }
    }
    
    
    var body: some View {
        print("body")
        
        return VStack {
            Group {
                if let object2D {
                    let a = log("ShapeFrom3D")
                    ShapeFrom3D(object2D: object2D)
                        .stroke(.black)
                        .background(.yellow)
                        .clipped()
                }
            }

            
        }
        .padding()
        .onGeometryChange (for: CGSize.self, of: { proxy in proxy.size}) { size in
           //viewportSize = size
            renderFrame()
        }
        .onAppear {
            print("View appeared:")
        }
        
        
    }
    
    func renderFrame() {
            //guard let viewportSize else  { return }
            print("self:", Unmanaged.passUnretained(self as AnyObject).toOpaque())
            let result = engine3D.objects2D(from: scene3D, viewport: viewportSize).first
            print(result)
            object2D = result
            print("self:", Unmanaged.passUnretained(self as AnyObject).toOpaque())
            print(object2D)
    }
    
    
}

#Preview {
    Scene3DViewWithCamera()
}


func log(_ str: String) -> Int {
    print(str)
    return 0
}
