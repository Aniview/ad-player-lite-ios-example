//
//  TableViewExampleVC.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import AdPlayerLite
import UIKit

final class TableViewExampleVC: UIViewController {
    private let pubId: String
    private let tagId: String
    private var dataSource: TableViewDataSource?
    private var stateIndicator: UIView?
    // private var visibleIndexPath: IndexPath?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    init(pubId: String, tagId: String) {
        self.pubId = pubId
        self.tagId = tagId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(stackView)
        stackView.bindConstraintsToContainerMargines()
        stackView.addArrangedSubview(tableView)
        fillDataSource()
    }

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        visibleIndexPath = tableView.indexPathsForVisibleRows?.first
//
//        coordinator.animate(alongsideTransition: nil) { _ in
//            if let indexPath = self.visibleIndexPath {
//               // self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//            }
//            self.visibleIndexPath = nil
//        }
//
//        super.viewWillTransition(to: size, with: coordinator)
//    }

    private func fillDataSource() {
        let dataSource = TableViewDataSource(tableView: tableView)

        let topTextRows: [TableRow] = (0...1).map {
            let text = Mock.texts[$0 % Mock.texts.count]
            return .text(text)
        }

        let bottomTextRows: [TableRow] = (4...20).map {
            let text = Mock.texts[$0 % Mock.texts.count]
            return .text(text)
        }
        var rows: [TableRow] = []
        rows.append(contentsOf: topTextRows)
        rows.append(.adPlacement(pubId: pubId, tagId: tagId) { [unowned self] controller in
            let stateIndicator = PlayerStateIndicator(controller: controller)
            self.stateIndicator?.removeFromSuperview()
            self.stateIndicator = stateIndicator
            stackView.insertArrangedSubview(stateIndicator, at: 0)
        })
        rows.append(contentsOf: bottomTextRows)

        dataSource.setData(rows: rows)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }

}
