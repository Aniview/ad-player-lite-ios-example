//
//  TableViewDataSource.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import UIKit
import AdPlayerLite

struct AdSlot: Equatable {
    let publisherId: String
    let tagId: String
}

enum TableRow {
    case text(_ text: String)
    case adPlacement(pubId: String, tagId: String, controllerCreated: (AdPlayerController) -> Void)
}

final class TableViewDataSource: NSObject {
    init(tableView: UITableView) {
        tableView.register(TextInfoCell.self)
        tableView.register(AdCell.self)
    }

    private var rows: [TableRow] = []

    func setData(rows: [TableRow]) {
        self.rows = rows
    }
}

extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .text(let text):
            let cell: TextInfoCell = tableView.dequeue()
            cell.configure(
                ArticleViewModel(
                    title: "Content row \(indexPath.row)",
                    text: text
                )
            )
            return cell
        case .adPlacement(let pubId, let tagId, let created):
            let cell: AdCell = tableView.dequeue()

            cell.configure(pubId: pubId, tagId: tagId, tableView: tableView, controllerCreated: created)
            cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) // hide separator
            cell.selectionStyle = .none
            return cell
        }
    }
}
