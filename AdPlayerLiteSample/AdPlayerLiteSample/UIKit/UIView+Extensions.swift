//
//  UIView+Extensions.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import UIKit

extension UIView {
    func withNonObstructiveBorder(color: UIColor, width: CGFloat) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        border.addSubview(self)
        bindConstraintsToContainer(insets: .init(top: width, left: width, bottom: width, right: width))
        return border
    }

    func bindConstraintsToContainerMargines() {
        guard let superview = superview else { return }
        let parent = superview.layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }

    func bindConstraintsToContainer(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
    }
}
