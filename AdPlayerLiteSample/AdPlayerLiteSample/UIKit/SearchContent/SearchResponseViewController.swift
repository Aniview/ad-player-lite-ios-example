//
//  SearchResponseViewController.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 09.02.2026.
//

import AdPlayerLite
import UIKit

final class SearchResponseViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let pubId: String
    private let tagId: String
    
    private let viewModel = SearchResponseViewModel()
    
    // MARK: - Lifecycle
    
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
        view.backgroundColor = .systemBackground
        setupSpinner()
        bind()
        viewModel.load()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cancel()
    }
    
    // MARK: - UI
    
    private func setupSpinner() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }
    
    private func showContent(_ json: [String: Any]) {
        guard let jsonArray = JSONObject.init(json) else { return }
            let controller = AdPlayer.getTag(pubId: pubId, tagId: tagId).newInReadController {
                $0.contentOverride = .searchContent(jsonArray)
            }
        let placement = AdPlacementView()
        placement.attachController(controller)
        
        view.addSubview(placement)
        
        placement.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placement.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            placement.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            placement.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            placement.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor)
        ])
        
        controller.showSoundButton = true
        controller.showPlayButton = true
        controller.showFullscreenButton = false
        controller.showSkipButton = false
    }
    
    private func showError(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = view.bounds
        view.addSubview(label)
    }
    
    // MARK: - ViewModel
    private func bind() {
        viewModel.onSuccess = { [weak self] json in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            self.showContent(json)
        }

        viewModel.onError = { [weak self] message in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            self.showError(message)
        }
    }
}
