//
//  ShapeFrom3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 07.09.2025.
//

import SwiftUI

struct ShapeFrom3D: Shape {
    var objects2D: [Object2D]
    func path(in rect: CGRect) -> Path {
        var resultPath = Path()
        
        for object2D in objects2D {
            var path = Path()
            path.move(to: object2D.points.first!)
            for point in object2D.points {
                path.addLine(to: point)
            }
            path.addLine(to: object2D.points.first!)
            resultPath.addPath(path)
        }
        
        return resultPath
    }
}

#Preview {

    let obj2D = engine3D.objects2D(from: Scene3D.quad,
                                   screenSize: CGSize(width: 400, height: 400)).first!

    ShapeFrom3D(objects2D: [obj2D])
}
