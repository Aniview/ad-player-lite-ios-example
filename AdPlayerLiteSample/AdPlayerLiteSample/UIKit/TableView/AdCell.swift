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
//        AdPlayer.getTag(pubId: pubId, tagId: tagId) {
//            $0.closeFullscreenButton = false
//        }
        let placement = AdPlacementView(pubId: pubId, tagId: tagId)
        placement.translatesAutoresizingMaskIntoConstraints = false

        let decorated = placement.withNonObstructiveBorder(color: .blue, width: 1)
        contentView.addSubview(decorated)
        decorated.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decorated.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            decorated.topAnchor.constraint(equalTo: contentView.topAnchor),
            decorated.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            decorated.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        self.adPlacement = placement
        placement.delegate = self
        controllerCreated(placement.playerController)
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
