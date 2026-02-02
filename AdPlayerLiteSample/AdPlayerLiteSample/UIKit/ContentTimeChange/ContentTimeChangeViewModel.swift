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
    let buttonListViewModel: ButtonListViewModel
    
    init(
        controller: AdPlayerController,
        items: [RowButton]
    ) {
        self.controller = controller
        self.buttonListViewModel = ButtonListViewModel(items: items)
        let currentTimePublisher = controller.contentProgressPublisher
            .map(\.currentTime)
            .eraseToAnyPublisher()
        
        let durationPublisher = controller.contentProgressPublisher
            .map(\.duration)
            .eraseToAnyPublisher()
        
        self.videoProgressViewModel = VideoProgressViewModel(currentTime: currentTimePublisher, duration: durationPublisher)
    }
    
    func setCurrentPosition(_ position: TimeInterval) {
        self.controller.setContentCurrentTime(position)
    }
}
