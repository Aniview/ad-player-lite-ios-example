//
//  SimpleExampleVC.swift
//  AdPlayerLightQA
//
//  Created by Pavel Yevtukhov on 24.09.2024.
//

import AdPlayerLite
import Combine
import UIKit

final class SimpleExampleVC: UIViewController {
    private let pubId: String
    private let tagId: String
    private var lastReportedHeight: CGFloat = 0
    private var bag: Set<AnyCancellable> = []

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

        let controller = AdPlayer
            .getTag(pubId: pubId, tagId: tagId)
            .newInReadController()
        let placement = AdPlacementView()
        placement.attachController(controller)

        #if DEBUG
        placement.layer.borderColor = UIColor.blue.cgColor
        placement.layer.borderWidth = 2
        #endif
        placement.delegate = self

        view.addSubview(placement)
        placement.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placement.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            placement.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            placement.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            placement.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor)
        ])

        observeEventsAndStates(controller: controller)
    }

    private func observeEventsAndStates(controller: AdPlayerController) {
        controller.eventsPublisher.sink { event in
            print("Ad event: \(event)")
        }.store(in: &bag)

        controller.statePublisher.sink { state in
            print("Ad state: \(state)")
        }.store(in: &bag)
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

import AdPlayerLite
import Combine
import UIKit

class YourViewController: UIViewController {
    private var bag: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = AdPlayer
            .getTag(pubId: "<your pubId>", tagId: "<your tagId>")
            .newInReadController()

        let placement = AdPlacementView()
        placement.attachController(controller)
        placement.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placement)
        NSLayoutConstraint.activate([
            placement.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placement.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placement.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])

        controller.eventsPublisher.sink { event in
            print("Ad event: \(event)")
        }.store(in: &bag)

        controller.statePublisher.sink { state in
            print("Ad state: \(state)")
        }.store(in: &bag)
    }
}
