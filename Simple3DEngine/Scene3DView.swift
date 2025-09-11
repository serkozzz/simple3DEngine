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

        }
        .padding()
        .camera3DController(scene3D.camera) {
            renderFrame()
        }
    }
    

    func renderFrame() {
        guard let viewportSize else  { return }
        let res = engine3D.objects2D(from: scene3D, screenSize: CGSize(width: viewportSize.width, height: viewportSize.width)).first
        object2D = res
    }

}

#Preview {
    Scene3DView()
}
