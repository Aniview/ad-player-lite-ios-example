//
//  PlayerStateIndicator.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 25.11.2024.
//

import UIKit
import AdPlayerLite
import Combine

final class PlayerStateIndicator: UIView {
    private let controller: AdPlayerController
    private var cancellable: AnyCancellable?
    private var label: UILabel

    init(controller: AdPlayerController) {
        self.controller = controller
        self.label = UILabel()
        super.init(frame: .zero)

        addSubview(label)
        label.bindConstraintsToContainer()

        cancellable = controller.statePublisher.sink { [unowned self] in
            label.text = "\($0)"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
