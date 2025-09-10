//
//  ContentView.swift
//  sandbox2
//
//  Created by Sergey Kozlov on 10.09.2025.
//

import SwiftUI


struct AnimatableEmitter<Value: VectorArithmetic>: View, @preconcurrency Animatable {
    var value: Value
    var onValueChange: (Value) -> Void

    var animatableData: Value {
        get { value }
        set {
            DispatchQueue.main.async { [self] in
                onValueChange(newValue)
            }
        }
    }

    var body: some View {
        Color.clear.frame(width: 0, height: 0)
    }
}



struct AnimatableEmitterSample: View {
    @State private var current: Float = 0
    @State private var target: Float = 100

    var body: some View {
        VStack(spacing: 20) {
            Text("Current: \(current, specifier: "%.2f")")
            Button("Animate") {
                withAnimation(.easeInOut(duration: 2)) {
                    target = 10
                }
            }
        }
        .overlay(
            AnimatableEmitter(value: target) { newValue in
                    current = newValue
                }
        )
    }
}

#Preview {
    AnimatableEmitterSample()
}
