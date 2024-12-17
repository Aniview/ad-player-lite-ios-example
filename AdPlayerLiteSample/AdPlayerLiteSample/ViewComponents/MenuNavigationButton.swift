//
//  MenuNavigationButton.swift
//  AdPlayerQA-SwiftUI
//
//  Created by Pavel Yevtukhov on 15.12.2023.
//

import SwiftUI

struct MenuNavigationButton<Destination: View>: View {
    let title: String
    @ViewBuilder var destination: () -> Destination

    init(
        _ title: String,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.title = title
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct UIViewControllerAdapter: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {
        viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
