//
//  AnyButtonViewModel.swift
//  AdPlayerLiteSample
//
//  Created by Zhanna Moskaliuk on 01.02.2026.
//

import Foundation

final class ButtonListViewModel: ObservableObject {
    let items: [RowButton]
    var buttonTapped: ((Int) -> (Void))?
    
    init(items: [RowButton]) {
        self.items = items
    }
}
