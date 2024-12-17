//
//  PlayerTimeIndicator.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 21.11.2024.
//

import AdPlayerLite
import SwiftUI
import Combine

final class PlayerTimeIndicatorViewModel: ObservableObject {
    @Published var text: String = defaultText

    private static let defaultText = "00:00 / 00:00"
    private let controller: AdPlayerController
    private var cancellables = Set<AnyCancellable>()
    private var updateTimer: Timer?
    private var cachedDuration: TimeInterval?
    private var isContent = false

    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    init(controller: AdPlayerController) {
        self.controller = controller
        controller.statePublisher.sink { [unowned self] state in
            switch state {
            case .playingAd:
                isContent = false
                startUpdating()
            case .playingContent:
                isContent = true
                startUpdating()
            default:
                cachedDuration = nil
            }
        }.store(in: &cancellables)
        controller.eventsPublisher.sink { [unowned self] event in
            cachedDuration = nil
            switch event {
            case .allAdsFinished, .closed, .adVideoCompleted, .contentVideoCompleted:
                text = Self.defaultText
            default:
                break
            }
        }.store(in: &cancellables)
    }

    private func startUpdating() {
        updateTimer?.invalidate()
        cachedDuration = nil
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [unowned self] _ in
            update()
        }
    }

    private func update() {
        Task { @MainActor in
            let duration = await getDuration(isContent: isContent)
            let position = isContent ? await controller.getContentPosition() : await controller.getAdPosition()
            text = formatted(position: position, duration: duration)
        }
    }

    private func getDuration(isContent: Bool) async -> TimeInterval {
        if let cachedDuration, cachedDuration > 0 {
            return cachedDuration
        }
        let duration = isContent ? await controller.getContentDuration() : await controller.getAdDuration()
        cachedDuration = duration
        return duration
    }

    private func formatted(position: TimeInterval, duration: TimeInterval) -> String {
        "\(formatted(position)) / \(formatted(duration))"
    }

    private func formatted(_ interval: TimeInterval) -> String {
        formatter.string(from: interval) ?? "00:00"
    }

    deinit {
        updateTimer?.invalidate()
    }
}

struct PlayerTimeIndicator<Label: View>: View {
    @StateObject private var viewModel: PlayerTimeIndicatorViewModel
    @ViewBuilder private var label: (String) -> Label

    init(
        controller: AdPlayerController,
        @ViewBuilder label: @escaping (String) -> Label = {
            Text($0).font(.caption.monospaced())
        }
    ) {
        _viewModel = StateObject(wrappedValue: .init(controller: controller))
        self.label = label
    }

    var body: some View {
        label(viewModel.text)
    }
}

#Preview {
    PlayerTimeIndicator(controller: StubAdPlayerController(state: .ready))
}
