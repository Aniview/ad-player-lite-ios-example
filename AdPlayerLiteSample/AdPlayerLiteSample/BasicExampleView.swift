//
//  BasicExampleView.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 15.10.2024.
//

import AdPlayerLite
import SwiftUI

struct BasicExampleView: View {
    let pubId: String
    let tagId: String
    // @State private var isCollapsed = true
    @State private var controller: AdPlayerController?

    var body: some View {
        VStack {
            AdPlacementSU(
                pubId: pubId,
                tagId: tagId,
                controller: $controller
            )
                .nonObstructiveBorder(.blue, width: 2)
                .layoutPriority(1)
            Spacer()
            if let controller {
                HStack(alignment: .center) {
                    PlayerControlsView(controller: controller, height: 24)
                    Spacer()
                    PlayerTimeIndicator(controller: controller) { text in
                        Text(text)
                            .font(.callout.monospaced())
                            .foregroundColor(.blue)
                    }
                }
                PlayerLoggerView(controller: controller)
            }
        }.frame(maxWidth: .infinity)
        .padding(.horizontal)
        .toolbar {
            if let controller {
                PlayerStateView(controller: controller)
            }
        }
        .navigationTitle("Basic Example")
    }
}
