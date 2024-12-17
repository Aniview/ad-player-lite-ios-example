//
//  PlayerEventsViewModel.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 22.11.2024.
//

import AdPlayerLite
import Combine
import SwiftUI

struct PlayerLoggerView: View {
    @StateObject private var viewModel: PlayerLoggerViewModel

    init(controller: AdPlayerController) {
        self._viewModel = StateObject(wrappedValue: PlayerLoggerViewModel(controller: controller))
    }

    var body: some View {
        LogView(viewModel: viewModel.logViewModel)
    }
}

private final class PlayerLoggerViewModel: ObservableObject {
    private var controller: AdPlayerController
    private var cancellable: AnyCancellable?
    let logViewModel = LogViewModel()

    init(controller: AdPlayerController) {
        self.controller = controller
        cancellable = controller.eventsPublisher.sink { [unowned self] in
            logViewModel.log("\($0)", context: assumeContext($0))
        }
    }

    private func assumeContext(_ event: AdPlayerEvent) -> LogViewModel.Context {
        switch event {
        case .allAdsFinished:
            return .highlight
        case .adError:
            return .error
        case .adImpression:
            return .highlight
        case .adSkipped:
            return .warning
        default:
            return .debug
        }
    }
}
