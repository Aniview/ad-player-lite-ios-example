//
//  PlayerControlsView.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 20.11.2024.
//

import AdPlayerLite
import SwiftUI
import Combine

final class PlayerControlsViewModel: ObservableObject {
    private let controller: AdPlayerController
    @Published var isPlaying = false
    @Published var isDisabled = false
    private var cancellable: AnyCancellable?

    init(controller: AdPlayerController) {
        self.controller = controller
        cancellable = controller.statePublisher.sink { [unowned self] state in
            isPlaying = state == .playingAd || state == .playingContent
            isDisabled = state == .preparing || state == .display
        }
    }

    func onPlayToggleTap() {
        if isPlaying {
            controller.pause()
        } else {
            controller.resume()
        }
    }

    func onSkipAdTap() {
        controller.skipAd()
    }
}

struct PlayerControlsView: View {
    private let height: CGFloat
    private let buttonsPadding: CGFloat
    @StateObject private var viewModel: PlayerControlsViewModel

    init(controller: AdPlayerController, height: CGFloat = 30, buttonsPadding: CGFloat = 2) {
        self.height = height
        self.buttonsPadding = buttonsPadding
        _viewModel = StateObject(wrappedValue: PlayerControlsViewModel(controller: controller))
    }

    var body: some View {
        HStack(spacing: 10) {
            Button { [unowned viewModel] in
                viewModel.onPlayToggleTap()
            } label: {
                decorateImage(
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                )
            }
            Button { [unowned viewModel] in
                viewModel.onSkipAdTap()
            } label: {
                decorateImage(
                    Image(systemName: "forward.end.fill")
                )
            }
        }
        .disabled(viewModel.isDisabled)
        .frame(height: height)
    }

    private func decorateImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .tint(.blue)
            .padding(.all, buttonsPadding)
    }
}

#Preview {
    PlayerControlsView(controller: StubAdPlayerController(state: .playingAd))
}
