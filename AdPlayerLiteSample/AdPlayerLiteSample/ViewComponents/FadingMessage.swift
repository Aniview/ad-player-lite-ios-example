//
//  FadingMessage.swift
//  AdPlayerQA
//
//  Created by Pavel Yevtukhov on 23.01.2024.
//

import SwiftUI

private struct FadingMessage: ViewModifier {
    @Binding var message: String?

    @State private var opacity: Double = 0.0
    @State private var scale: Double = 1
    @State private var displayedMessage = ""

    func body(content: Content) -> some View {
        ZStack {
            content
            Text(displayedMessage)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(5)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onChange(of: message) { newValue in
            guard let newValue = newValue else { return }
            displayedMessage = newValue
            message = nil
            let fadeDuration = 0.3
            let fullyVisible = 0.5
            withAnimation(.easeOut(duration: fadeDuration)) {
                opacity = 1
                scale = 1.3
            }
            withAnimation(.easeInOut(duration: fadeDuration).delay(fadeDuration + fullyVisible)) {
                opacity = 0
                scale = 1
            }
        }
    }
}

extension View {
    func fadingMessage(message: Binding<String?>) -> some View {
        modifier(FadingMessage(message: message))
    }
}
