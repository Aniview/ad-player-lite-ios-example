//
//  ContentProgressControlViewModel.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 20.01.2026.
//

import Foundation
import Combine

final class VideoProgressViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Publisher
    let progress: AnyPublisher<CGFloat, Never>
    
    init(
        currentTime: AnyPublisher<Double, Never>,
        duration: AnyPublisher<Double, Never>
    ) {
        let progressSubject = CurrentValueSubject<CGFloat, Never>(0)
        currentTime
            .combineLatest(duration)
            .map { time, duration -> CGFloat in
                guard duration > 0 else { return 0 }
                return CGFloat(time / duration)
            }
            .removeDuplicates(by: { abs($0 - $1) < 0.001 })
            .subscribe(progressSubject)
            .store(in: &cancellables)
        
        self.progress = progressSubject.eraseToAnyPublisher()
    }
}
