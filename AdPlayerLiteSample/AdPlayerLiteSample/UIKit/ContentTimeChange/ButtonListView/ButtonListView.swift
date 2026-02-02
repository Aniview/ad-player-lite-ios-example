//
//  ButtonListView.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 02.02.2026.
//

import UIKit

final class ButtonListView: UIView {
    
    // MARK: - viewModel
    private let viewModel: ButtonListViewModel
    
    init(viewModel: ButtonListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        build()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func build() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.items.forEach { item in
            let row = RowButtonView(item: item)
            row.onButtonTapped = { [weak self] tappedItem in
                self?.viewModel.buttonTapped?(tappedItem)
            }
            stack.addArrangedSubview(row)
        }
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
