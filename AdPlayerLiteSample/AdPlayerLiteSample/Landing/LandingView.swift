//
//  LandingView.swift
//
//
//  Created by Pavel Yevtukhov on 24.09.2024.
//

import AdPlayerLite
import SwiftUI

struct LandingView: View {
    private let pubId = Constants.publisherId
    private let tagId = Constants.tagId
    @State private var topFadingMessage: String?

    var body: some View {
        NavigationStack {
            mainContent
        }
    }

    private var mainContent: some View {
        VStack {
            Text("AdPlayer Examples").font(.title)
                .fadingMessage(message: $topFadingMessage)
            Spacer()
            Text("SwiftUI")
            MenuNavigationButton("Basic") {
                BasicExampleView(pubId: pubId, tagId: tagId)
            }
            MenuNavigationButton("Scroll View") {
                ScrollViewExample(pubId: pubId, tagId: tagId)
            }
            Divider()
            Spacer().frame(height: 20)
            Text("UIKit")
            MenuNavigationButton("Basic") {
                UIViewControllerAdapter {
                    SimpleExampleVC(pubId: pubId, tagId: tagId)
                }.navigationTitle("UIView")
            }
            MenuNavigationButton("Table View") {
                UIViewControllerAdapter {
                    TableViewExampleVC(pubId: pubId, tagId: tagId)
                }.navigationTitle("UITableView")
            }
            Divider()
            AppButton("Interstitial", backgroundColor: .gray) {
                let config = InterstitialConfiguration(
                    stalledVideoTimeout: 2.0,
                    showCloseButtonAfterAdDuration: true
                )
                AdPlayer.showInterstitial(pubId: pubId, tagId: tagId, configuration: config) {
                    topFadingMessage = "Interstitial Closed"
                }
            }
            Spacer()
            Text("SDK v.\(AdPlayerLite.sdkVersionName)")
        }.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
        .padding(.horizontal)
    }
}
