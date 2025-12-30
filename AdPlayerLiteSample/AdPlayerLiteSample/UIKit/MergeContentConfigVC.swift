//
//  SimpleExampleVC.swift
//  AdPlayerLightQA
//
//  Created by Pavel Yevtukhov on 24.09.2024.
//

import AdPlayerLite
import UIKit

struct InstreamPlayerUIConfig: Encodable {
    struct Config: Encodable {
        var enable: Bool
    }
    var timeline: Config = .init(enable: true)
    var fullscreenButton: Config = .init(enable: true)
    var duration: Config = .init(enable: true)

    /// Possible Configs
//    "primaryPlayButton",
//       "primaryPauseButton",
//       "primaryReplayButton",
//       "primaryPrevButton",
//       "primaryNextButton",
//       "primaryFastForwardButton",
//       "primaryFastBackwardButton",
//       "secondaryPlayButton",
//       "secondaryPauseButton",
//       "secondaryReplayButton",
//       "secondaryPrevButton",
//       "secondaryNextButton",
//       "secondaryFastForwardButton",
//       "secondaryFastBackwardButton",
//       "closeButton",
//       "closeFullscreenButton",
//       "playlistButton",
//       "readMoreButton",
//       "fullscreenButton",
//       "volumeButton",
//       "stayButton",
//       "autoSkip",
//       "nextPreview",
//       "timeline",
//       "duration",
}

// Only works with in-stream tags
final class MergeContentConfigVC: UIViewController {
    private let pubId = "565c56d3181f46bd608b459a"
    private let tagId = "64b4da00ce6021de5b026d24"

    private var uiConfig = InstreamPlayerUIConfig()

    private lazy var controller: AdPlayerInReadController = {
        AdPlayer.getTag(pubId: pubId, tagId: tagId)
            .newInReadController {
                $0.disableVideoAds = true
            }
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayerPlacement()
        setupButton()
    }

    private func setupPlayerPlacement() {
        let placement = AdPlacementView()
        placement.layer.borderColor = UIColor.blue.cgColor
        placement.layer.borderWidth = 2
        placement.attachController(controller)

        view.addSubview(placement)

        placement.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placement.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            placement.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            placement.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            placement.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor)
        ])
    }

    private func setupButton() {
        let label = UILabel()
        label.text = "Note: works only with in-stream player"
        label.textColor = .red
        view.addSubview(label)
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])

        let button = UIButton(type: .custom)
        button.configuration = .filled()
        button.setTitle("Merge Content Config", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50)
        ])


        button.addTarget(self, action: #selector(didButtonTap), for: .touchUpInside)
    }

    @objc private func didButtonTap() {
        uiConfig.timeline.enable.toggle()
        uiConfig.fullscreenButton.enable.toggle()
        uiConfig.duration.enable.toggle()

        controller.mergeContentConfig(uiConfig)
    }
}
