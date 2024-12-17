//
//  NonObstructiveBorderModifier.swift
//
//  Created by Pavel Yevtukhov on 17.09.2024.
//

import SwiftUI

extension View {
    /* This is an alternative to the standard SwiftUI ".border"
        which makes an obstruction for Open Measurment framework
     */
    func nonObstructiveBorder(_ color: Color, width: CGFloat) -> some View {
        modifier(NonObstructiveBorderModifier(borderWidth: width, color: color))
    }
}

private struct NonObstructiveBorderModifier: ViewModifier {
    let borderWidth: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .background(.white, ignoresSafeAreaEdges: [])
            .padding(.all, borderWidth)
            .background(color, ignoresSafeAreaEdges: [])
    }
}
