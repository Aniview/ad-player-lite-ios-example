//
//  ContentTimeChangeViewController.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 20.01.2026.
//

import UIKit
import Combine
import AdPlayerLite

final class ContentTimeChangeViewController: UIViewController {
    private let pubId: String
    private let tagId: String
    
    // MARK: - UI
    private let progressView = VideoProgressView()
    private let controller: AdPlayerInReadController
    
    private let items = [
        RowButton(buttonTitle: "10 sec"),
        RowButton(buttonTitle: "30 sec")
    ]
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - ViewModel
    private let viewModel: ContentTimeChangeViewModel
    
    init(pubId: String, tagId: String) {
        self.pubId = pubId
        self.tagId = tagId
        self.controller = AdPlayer.getTag(pubId: pubId, tagId: tagId)
            .newInReadController {
                $0.isContentTimeTrackingEnabled = true
            }
        self.viewModel = ContentTimeChangeViewModel(controller: controller, items: items)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        titleLabel.text = "To enable progress updates pass 'true' to 'isContentTimeTrackingEnabled'"
        setupTitleLabel()
        setupButtonListView()
        setupProgressView()
        setupVideoContentView()
        
        // button tapped updates
        viewModel.buttonListViewModel.buttonTapped = { [weak self] index in
            switch index {
            case 0:
                self?.viewModel.setCurrentPosition(10)
            default:
                self?.viewModel.setCurrentPosition(30)
            }
        }
        
        // combine helpers
        bind()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 12
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
    }
    // MARK: - UI Setup
    private func setupVideoContentView() {
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
    }
    
    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupButtonListView() {
        let listView = ButtonListView(viewModel: viewModel.buttonListViewModel)
        listView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(listView)
        
        NSLayoutConstraint.activate([
            listView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Video Progress"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func bind() {
        progressView.bind(to: viewModel.videoProgressViewModel)
    }
}
