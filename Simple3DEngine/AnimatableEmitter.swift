//
//  ContentView.swift
//  sandbox2
//
//  Created by Sergey Kozlov on 10.09.2025.
//

import SwiftUI

struct AnimatableEmitter: View, Animatable {
    var value: Double // конечное значение (куда хотим прийти)
    var onValueChange: (Double) -> Void

    // это "живое" анимируемое значение
    nonisolated var animatableData: Double {
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
    @State private var current: Double = 0
    @State private var target: Double = 100

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
