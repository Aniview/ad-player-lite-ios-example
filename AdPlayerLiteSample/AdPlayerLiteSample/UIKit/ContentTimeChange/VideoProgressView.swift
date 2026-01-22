//
//  ContentProgressViewControl.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 20.01.2026.
//

import UIKit
import Combine

final class VideoProgressView: UIView {
    private let trackView = UIView()
    private let progressView = UIView()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var progress: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        trackView.backgroundColor = .systemGray4
        progressView.backgroundColor = .systemBlue
        
        addSubview(trackView)
        addSubview(progressView)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackView.frame = CGRect(
            x: 0,
            y: bounds.midY - 2,
            width: bounds.width,
            height: 4
        )
        
        progressView.frame = CGRect(
            x: 0,
            y: trackView.frame.minY,
            width: bounds.width * progress,
            height: 4
        )
    }
    
    func bind(to viewModel: VideoProgressViewModel) {
        cancellables.removeAll()
        viewModel.progress
            .receive(on: RunLoop.main)
            .sink { [weak self] progress in
                self?.progress = min(max(progress, 0), 1)
            }
            .store(in: &cancellables)
    }
}
