//
//  SimpleExampleVC.swift
//  AdPlayerLightQA
//
//  Created by Pavel Yevtukhov on 24.09.2024.
//

import AdPlayerLite
import UIKit

final class SimpleExampleVC: UIViewController {
    private let pubId: String
    private let tagId: String
    private var lastReportedHeight: CGFloat = 0

    init(pubId: String, tagId: String) {
        self.pubId = pubId
        self.tagId = tagId

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let placement = AdPlacementView(pubId: pubId, tagId: tagId)
        placement.delegate = self

        let decorated = placement.withNonObstructiveBorder(color: .green, width: 2)

        view.addSubview(decorated)

        decorated.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decorated.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            decorated.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            decorated.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            decorated.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor)
        ])
    }
}

extension SimpleExampleVC: AdPlacementViewLayoutDelegate {
    func onResize(height: CGFloat) {
        guard lastReportedHeight != height else {
            return
        }
        lastReportedHeight = height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
