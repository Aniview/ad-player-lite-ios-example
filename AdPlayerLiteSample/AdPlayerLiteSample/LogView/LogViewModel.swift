//
//  LogViewModel.swift
//
//
//  Created by Pavel Yevtukhov on 13.09.2024.
//

import Foundation

final class LogViewModel: ObservableObject {
    enum Context {
        case debug
        case warning
        case error
        case highlight
    }

    struct LogViewItem: Identifiable {
        let id = UUID()
        let text: String
        let context: Context
    }

    @Published private(set) var items: [LogViewItem] = []

    func log(_ text: String, context: Context = .debug) {
        items.insert(
            .init(
                text: String(text.prefix(200)),
                context: context
            ),
            at: 0
        )
        if items.count >= 40 {
            items.remove(at: items.count - 1)
        }
    }

    func clear() {
        items = []
    }
}
