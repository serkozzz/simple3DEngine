//
//  CameraMover3D.swift
//  Simple3DEngine
//
//  Created by Sergey Kozlov on 12.09.2025.
//

import SwiftUI
import Combine
import simd


class CameraMover3D  {
    
    let maxSpeed: Float = 0.05 // m/s
    let camera: Camera3D
    let onCameraMoved: (() -> Void)?
    
    private var joystickState: JoystickState?
    private var isMoving = false
    
    private var lastTickTime: Date?
    private var cancelables = Set<AnyCancellable>()
    
    init(camera: Camera3D, onCameraMoved: (() -> Void)? = nil) {
        self.camera = camera
        self.onCameraMoved = onCameraMoved
        
        Timer.publish(every: 0.05, on: .main, in: .common)
             .autoconnect()
             .sink { _ in
                 print("Timer fired!")
                 withAnimation(.linear(duration: 0.1)) { [self] in
                     timerTick()
                 }
             }.store(in: &cancelables)
    }
    
    
    private func moveCamera(distance: Float, direction2D: SIMD2<Float>) {
        
        let yAxis2D = SIMD2<Float>(0,1)
        let angle = acos(simd_dot(yAxis2D, direction2D))
        let directionSign: Float = abs(angle) > .pi / 2 ? -1 : 1
        
        let inversedMatrix = camera.viewMatrix.inverse
        
        let movementVectorCameraSpace = SIMD4(direction2D.x, 0, -direction2D.y, 0) // x&z should be both with - because of cam direction is -z
        //but also when trnasform xy 2D plane to xyz we should revert x. In result we have +x, -y
        
        let movementVectorWorldSpace = simd_normalize(inversedMatrix * movementVectorCameraSpace)
        let d = movementVectorWorldSpace * distance
//        let forward = directionSign * (-1) * simd_normalize(SIMD3(inversedMatrix.columns.2.x,
//                                                  inversedMatrix.columns.2.y,
//                                                  inversedMatrix.columns.2.z))
//        let d = forward * distance
        camera.position.x += d.x
        camera.position.y += d.y
        camera.position.z += d.z
    }
    
    func timerTick() {
        guard var lastTickTime else {
            lastTickTime = Date.now
            return
        }
        let t = Date.now.timeIntervalSince(lastTickTime)
        lastTickTime = Date.now
        if isMoving, let joystickState {
            if let intencity = joystickState.movementIntencity,
               let direction2D = joystickState.movementDirection
            {
                moveCamera(distance: intencity * maxSpeed * Float(t), direction2D: direction2D)
                onCameraMoved?()
            }
        }
    }
}


//MARK: JOystickDelegate

extension CameraMover3D : JoystickDelegate {
    func dragBegan() {
        isMoving = true
        print(#function)
    }
    func dragChanged(state: JoystickState) {
        joystickState = state
        

       // print(#function + "\(state)")
    }

    func dragEnded() {
        isMoving = false
        joystickState = nil
        print(#function)
    }
}
