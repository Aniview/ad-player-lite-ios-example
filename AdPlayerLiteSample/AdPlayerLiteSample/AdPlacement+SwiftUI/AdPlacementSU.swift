import AdPlayerLite
import SwiftUI

struct AdPlacementSU: View {
    private let pubId: String
    private let tagId: String
    private let animation: Animation

    @Binding private var controller: AdPlayerController?
    @State private var isCollapsed: Bool = true
    @State private var availableSize: CGSize = .zero
    @State private var intrinsicHeight: CGFloat = 0
    @State private var isCollapsedEffective = true

    init(
        pubId: String,
        tagId: String,
        controller: Binding<AdPlayerController?> = .constant(nil),
        animation: Animation = .default
    ) {
        self.pubId = pubId
        self.tagId = tagId
        self._controller = controller
        self.animation = animation
    }

    var body: some View {
        GeometryReader { geometry in
            AdPlacementUIViewRepresentable(
                pubId: pubId,
                tagId: tagId,
                availableSize: geometry.size,
                intrinsicHeight: $intrinsicHeight,
                isCollapsed: $isCollapsed,
                controller: $controller
            )
        }
        .frame(idealHeight: intrinsicHeight)
        .frame(maxHeight: intrinsicHeight)
        .frame(height: isCollapsedEffective ? 0 : nil, alignment: .top)
        .clipped()
        .onChange(of: isCollapsed) { newValue in
            withAnimation(animation) {
                isCollapsedEffective = newValue
            }
        }
    }
}
