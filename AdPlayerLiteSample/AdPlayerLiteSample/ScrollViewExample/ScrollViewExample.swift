//
//  ScrollViewExample.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 30.09.2024.
//

import AdPlayerLite
import SwiftUI

struct ScrollViewExample: View {
    let pubId: String
    let tagId: String
    @State private var controller: AdPlayerController?

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    MockTextsView(count: 1)
                    AdPlacementSU(pubId: pubId, tagId: tagId, controller: $controller)
                        .nonObstructiveBorder(.green, width: 2)
                    MockTextsView(count: 10)
                }
                .padding(.horizontal)
            }
        }
        .toolbar {
            if let controller {
                PlayerStateView(controller: controller)
            }
        }
        .navigationTitle("Scroll View")
    }
}

struct MockTextsView: View {
    let items: [Item]

    struct Item: Identifiable {
        let id = UUID()
        let text: String
    }

    init(count: Int) {
        items = (0..<count).map { Item(text: Mock.texts[$0 % Mock.texts.count]) }
    }

    var body: some View {
        ForEach(items) { item in
            Text(item.text)
        }
    }
}
