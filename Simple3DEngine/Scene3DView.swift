//
//  ContentView.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import SwiftUI

struct Scene3DView: View {
    @State private var objects2D: [Object2D]?
    @State private var scene3D: Scene3D = Scene3D.pyramid
    
    @State private var viewportSize: CGSize?

    @State private var trimEnd: CGFloat = 1
    @State private var isTrimEnabled = false
    
    @State private var trimAnimationID = UUID()
    
    var body: some View {
        VStack {
            Group {
                if let  objects2D, let viewportSize  {
                    ShapeFrom3D(objects2D: objects2D)
                        .trim(from: 0, to: trimEnd)
                        .stroke(.black)
                        .scaleEffect(x: 1, y: -1, anchor: .topLeading)
                        .offset(y: viewportSize.height)
                        .onAppear() {
                            if isTrimEnabled {
                                 withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                                    trimEnd = 0
                                }
                            }
                            else {
                                trimEnd = 1
                            }
                        }
                        .id(isTrimEnabled ? trimAnimationID : UUID())
                    
                }
            }
            .onGeometryChange (for: CGSize.self, of: { proxy in proxy.size}) { size in
                viewportSize = size
                scene3D.camera.setAspect(aspect: Float(size.width / size.height))
                renderFrame()
            }
            Button("trim effect") {
                isTrimEnabled.toggle()
            }

        }
        .padding()

        .camera3DController(scene3D.camera) {
            renderFrame()
        }
        
    }
    

    func renderFrame() {
        guard let viewportSize else  { return }
        let res = engine3D.objects2D(from: scene3D, screenSize: CGSize(width: viewportSize.width, height: viewportSize.height))
        objects2D = res
    }

}

#Preview {
    Scene3DView()
}
