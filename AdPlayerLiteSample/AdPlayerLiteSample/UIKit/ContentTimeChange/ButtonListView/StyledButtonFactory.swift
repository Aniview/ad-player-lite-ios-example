//
//  StyledButtonFactory.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 02.02.2026.
//

import UIKit

enum StyledButtonFactory {
    static func make(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = title
            config.baseForegroundColor = .systemBlue
            config.background.backgroundColor = .white
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 14,
                bottom: 8,
                trailing: 14
            )
            button.configuration = config
        } else {
            // iOS 14 and below
            button.setTitle(title, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = UIColor.white
            button.contentEdgeInsets = UIEdgeInsets(
                top: 8,
                left: 14,
                bottom: 8,
                right: 14
            )
        }

        // Shared layer styling (all iOS versions)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemPurple.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        return button
    }
}
