//
//  StubAdPlayerController.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 21.11.2024.
//

import AdPlayerLite
import Combine
import Foundation

final class StubAdPlayerController: AdPlayerController {
    var contentPublisher: AnyPublisher<AdPlayerContent?, Never> = Empty<AdPlayerContent?, Never>().eraseToAnyPublisher()
    var content: AdPlayerContent?
    var playlistPublisher = Empty<[AdPlayerContent], Never>().eraseToAnyPublisher()
    var playlist: [AdPlayerContent] = []
    var state = AdPlayerLite.AdPlayerState.ready
    lazy var statePublisher = CurrentValueSubject<AdPlayerLite.AdPlayerState, Never>(state).eraseToAnyPublisher()
    var eventsPublisher = Empty<AdPlayerLite.AdPlayerEvent, Never>().eraseToAnyPublisher()
    func pause() {}
    func resume() {}
    func skipAd() {}
    func getReadyAdsCount() async -> Int { 0 }
    func getAdPosition() async -> TimeInterval { 2.5 }
    func getAdDuration() async -> TimeInterval { 10 }
    func getContentPosition() async -> TimeInterval { 0 }
    func getContentDuration() async -> TimeInterval { 0 }
    func toggleFullscreen() {}
    func playNextContent() {}
    func playPrevContent() {}
    func playContentByIndex(_ index: Int) {}

    init(state: AdPlayerState = AdPlayerLite.AdPlayerState.ready) {
        self.state = state
    }
}
