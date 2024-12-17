import AdPlayerLite
import SwiftUI
import UIKit

struct AdPlacementUIViewRepresentable: UIViewRepresentable {
    typealias UIViewType = CollapsibleWrapperView

    private let pubId: String
    private let tagId: String
    private let availableSize: CGSize
    private let intrinsicHeight: Binding<CGFloat>
    private let isCollapsed: Binding<Bool>
    private let controller: Binding<AdPlayerController?>

    init(
        pubId: String,
        tagId: String,
        availableSize: CGSize,
        intrinsicHeight: Binding<CGFloat>,
        isCollapsed: Binding<Bool>,
        controller: Binding<AdPlayerController?>
    ) {
        self.pubId = pubId
        self.tagId = tagId
        self.isCollapsed = isCollapsed
        self.availableSize = availableSize
        self.intrinsicHeight = intrinsicHeight
        self.controller = controller
    }

    func makeUIView(context: Context) -> UIViewType {
        let placement = AdPlacementView(pubId: pubId, tagId: tagId)
        placement.delegate = context.coordinator
        let uiView = CollapsibleWrapperView(content: placement)
        context.coordinator.view = uiView
        DispatchQueue.main.async {
            self.controller.wrappedValue = placement.playerController
        }
        return uiView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if isCollapsed.wrappedValue != uiView.content.isCollapsed {
            DispatchQueue.main.async {
                uiView.content.isCollapsed = isCollapsed.wrappedValue
            }
        }
        context.coordinator.updateIntrinsicHeight(availableSize: availableSize)
    }

    func makeCoordinator() -> AdPlacementSViewCoordinator {
        .init(intrinsicHeight: intrinsicHeight, isCollapsed: isCollapsed)
    }
}

final class AdPlacementSViewCoordinator {
    weak var view: CollapsibleWrapperView?

    private let intrinsicHeight: Binding<CGFloat>
    private let isCollapsed: Binding<Bool>
    private var lastReportedHeight: CGFloat?

    init(
        intrinsicHeight: Binding<CGFloat>,
        isCollapsed: Binding<Bool>
    ) {
        self.intrinsicHeight = intrinsicHeight
        self.isCollapsed = isCollapsed
    }

    func updateIntrinsicHeight(availableSize: CGSize) {
        guard let view else { return }
        let content = view.content

        if availableSize.height > 0 {
            view.contentHeight = availableSize.height
        }

        let height = content.idealHeight(for: availableSize.width)

        if view.contentHeight != height {
            DispatchQueue.main.async {
                self.intrinsicHeight.wrappedValue = height
            }
        }
    }
}

final class CollapsibleWrapperView: UIView {
    let content: AdPlacementView
    private let heightConstr: NSLayoutConstraint

    var contentHeight: CGFloat = 0 {
        didSet {
            heightConstr.constant = contentHeight
        }
    }

    init(content: AdPlacementView) {
        self.content = content
        content.translatesAutoresizingMaskIntoConstraints = false
        heightConstr = content.heightAnchor.constraint(equalToConstant: contentHeight)
        super.init(frame: .zero)

        content.removeFromSuperview()
        addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor),
            content.trailingAnchor.constraint(equalTo: trailingAnchor),
            content.topAnchor.constraint(equalTo: topAnchor),
            heightConstr
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdPlacementSViewCoordinator: AdPlacementViewLayoutDelegate {
    func onResize(height: CGFloat) {
        guard lastReportedHeight != height else { return }
        lastReportedHeight = height
        self.isCollapsed.wrappedValue = height == 0
    }
}
