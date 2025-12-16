//
//  AdPlayerCell.swift
//  AdPlayerSample
//
//  Created by Pavel Yevtukhov on 16.02.2024.
//

import AdPlayerLite
import UIKit

final class AdCell: UITableViewCell {
    private weak var adPlacement: UIView?
    private weak var tableView: UITableView?

    private var lastReportedHeight: CGFloat?
    private var controllerCreated: (AdPlayerController) -> Void = { _ in }

    func configure(
        pubId: String, tagId: String,
        tableView: UITableView,
        controllerCreated: @escaping (AdPlayerController) -> Void
    ) {
        self.tableView = tableView
        self.controllerCreated = controllerCreated
        clipsToBounds = true
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addAdPlacement(pubId: pubId, tagId: tagId)
    }

    private func addAdPlacement(pubId: String, tagId: String) {
        guard adPlacement == nil else {
            return
        }

        removeAdPlayer()

        let tag = AdPlayer.getTag(pubId: pubId, tagId: tagId)
        let controller = tag.newInReadController()
        let placement = AdPlacementView()
        placement.attachController(controller)
        #if DEBUG
        placement.layer.borderColor = UIColor.blue.cgColor
        placement.layer.borderWidth = 2
        #endif

        contentView.addSubview(placement)
        placement.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placement.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            placement.topAnchor.constraint(equalTo: contentView.topAnchor),
            placement.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placement.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        self.adPlacement = placement
        placement.delegate = self
        controllerCreated(controller)
    }

    private func removeAdPlayer() {
        adPlacement?.removeFromSuperview()
        self.adPlacement = nil
    }
}

extension AdCell: AdPlacementViewLayoutDelegate {
    func onResize(height: CGFloat) {
        guard lastReportedHeight != height else {
            return
        }
        lastReportedHeight = height

        DispatchQueue.main.async {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
}
