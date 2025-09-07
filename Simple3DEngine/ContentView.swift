//
//  ContentView.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var object2D: Object2D?
    
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
                object2D = engine3D.objects2D(from: Scene3D.quad, screenSize: CGSize(width: size.width, height: size.width)).first
                print(object2D)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
