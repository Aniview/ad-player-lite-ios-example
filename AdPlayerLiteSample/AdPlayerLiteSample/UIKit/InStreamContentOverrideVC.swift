//
//  InStreamContentOverrideVC.swift
//  AdPlayerLightQA
//
//  Created by Pavel Yevtukhov on 24.09.2024.
//

import AdPlayerLite
import Combine
import UIKit

final class InStreamContentOverrideVC: UIViewController {
    private let pubId = "565c56d3181f46bd608b459a"
    private let tagId = "69009fdf2afa02d6e00f8136"
    private var lastReportedHeight: CGFloat = 0
    private var bag: Set<AnyCancellable> = []
    private var placement = AdPlacementView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        let showVideoButton = UIButton(type: .system)
        showVideoButton.setTitle("Show default video", for: .normal)
        stackView.addArrangedSubview(showVideoButton)
        showVideoButton.addTarget(self, action: #selector(onShowDefaultVideo), for: .touchUpInside)

        let showCustomVideoButton = UIButton(type: .system)
        showCustomVideoButton.setTitle("Show custom CMS video", for: .normal)
        stackView.addArrangedSubview(showCustomVideoButton)
        showCustomVideoButton.addTarget(self, action: #selector(onShowCustomVideo), for: .touchUpInside)

        let showCustomURLVideoButton = UIButton(type: .system)
        showCustomURLVideoButton.setTitle("Show direct URL video", for: .normal)
        stackView.addArrangedSubview(showCustomURLVideoButton)
        showCustomURLVideoButton.addTarget(self, action: #selector(onShowDirectURLVideo), for: .touchUpInside)
    }

    @objc
    private func onShowDefaultVideo() {
        showAdPlayer(nil)
    }

    @objc
    private func onShowCustomVideo() {
        showAdPlayer(.cmsId("6915845312387b243304e745"))
    }

    @objc
    private func onShowDirectURLVideo() {
        showAdPlayer(.directUrls(["https://getsamplefiles.com/download/mp4/sample-5.mp4"]))
    }

    private func showAdPlayer(_ contentOverride: AdPlayerContentOverride?) {
        placement.removeFromSuperview()
        onResize(height: 0)
        let controller = AdPlayer
            .getTag(pubId: pubId, tagId: tagId)
            .newInReadController { config in
                config.contentOverride = contentOverride
                config.disableVideoAds = true
            }

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
        bag.removeAll()
        controller.eventsPublisher.sink { event in
            print("Ad event: \(event)")
        }.store(in: &bag)

        controller.statePublisher.sink { state in
            print("Ad state: \(state)")
        }.store(in: &bag)
    }
}

extension InStreamContentOverrideVC: AdPlacementViewLayoutDelegate {
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
