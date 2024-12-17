//
//  AppButton.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 06.11.2024.
//

import SwiftUI

struct AppButton: View {
    let text: String
    let textColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void

    init(
        _ text: String,
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity) // Make it fill the width, remove if not needed
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}
