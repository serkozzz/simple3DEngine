//
//  ContentView.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import SwiftUI

struct Scene3DView: View {
    @State private var objects2D: [Object2D]?
    @State private var scene3D: Scene3D = Scene3D.cube
    
    @State private var viewportSize: CGSize?

    
    var body: some View {
        ZStack {
            Group {
                if let objects2D = objects2D {
                    ShapeFrom3D(objects2D: objects2D)
                        .stroke(.black)
                        .background(.yellow)
                }
            }
        }
        .padding()
        .onGeometryChange (for: CGSize.self, of: { proxy in proxy.size}) { size in
            viewportSize = size
            renderFrame()
        }
        .camera3DController(scene3D.camera) {
            renderFrame()
        }
        
    }
    

    func renderFrame() {
        guard let viewportSize else  { return }
        let res = engine3D.objects2D(from: scene3D, screenSize: CGSize(width: viewportSize.width, height: viewportSize.width))
        objects2D = res
    }

}

#Preview {
    Scene3DView()
}
