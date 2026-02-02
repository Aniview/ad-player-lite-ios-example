//
//  AnyButtonView.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 01.02.2026.
//

import Combine
import UIKit

final class RowButtonView: UIView {
    
    // MARK: - UI elements
    
    private let item: RowButton
    private let button: UIButton
    private let label = UILabel()
    
    var onButtonTapped: ((RowButton) -> Void)?
    
    init(item: RowButton) {
        self.item = item
        self.button = StyledButtonFactory.make(title: item.buttonTitle)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        button.setTitle(item.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Tap handler
    @objc private func tapped() {
        onButtonTapped?(item)
    }
}
