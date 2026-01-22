//
//  ContentTimeChangeViewModel.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 20.01.2026.
//

import Foundation
import Combine
import AdPlayerLite

// MARK: - Screen view model for 'ContentTimeChangeViewController'
final class ContentTimeChangeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let controller: AdPlayerController
    
    // MARK: - Screen Controls ViewModels
    let videoProgressViewModel: VideoProgressViewModel
    
    init(controller: AdPlayerController) {
        self.controller = controller
        let currentTimePublisher = controller.contentProgressPublisher
            .map(\.currentTime)
            .eraseToAnyPublisher()
        
        let durationPublisher = controller.contentProgressPublisher
            .map(\.duration)
            .eraseToAnyPublisher()
        
        self.videoProgressViewModel = VideoProgressViewModel(currentTime: currentTimePublisher, duration: durationPublisher)
    }
}
