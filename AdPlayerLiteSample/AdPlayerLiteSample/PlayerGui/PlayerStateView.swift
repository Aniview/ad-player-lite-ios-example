//
//  PlayerStateView.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 22.11.2024.
//

import AdPlayerLite
import Combine
import SwiftUI

struct PlayerStateView: View {
    @StateObject private var viewModel: PlayerStateViewModel

    init(controller: AdPlayerController) {
        self._viewModel = StateObject(wrappedValue: .init(controller: controller))
    }

    var body: some View {
        Text(viewModel.text)
            .foregroundColor(viewModel.color)
    }
}

private final class PlayerStateViewModel: ObservableObject {
    @Published var text = ""
    @Published var color: Color = .gray
    private var controller: AdPlayerController
    private var cancellable: AnyCancellable?
    let logViewModel = LogViewModel()

    init(controller: AdPlayerController) {
        self.controller = controller
        cancellable = controller.statePublisher.sink { [unowned self] in
            text = "\($0)"
            color = getColor(state: $0)
        }
    }

    private func getColor(state: AdPlayerState) -> Color {
        switch state {
        case .preparing:
            return .gray
        case .ready:
            return .yellow
        case .playingAd:
            return .blue
        case .playingContent:
            return .green
        case .notPlaying:
            return .black
        case .display:
            return .orange
        }
    }
}
