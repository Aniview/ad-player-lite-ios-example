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
    private let contentTimeUpdatesPubId = Constants.contentTimeChangeEventPubId
    private let contentTimeUpdatesTagId = Constants.contentTimeChangeEventTagId
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
            Spacer().frame(height: 20)
            Text("UIKit")
            MenuNavigationButton("Basic") {
                UIViewControllerAdapter {
                    SimpleExampleVC(pubId: pubId, tagId: tagId)
                }.navigationTitle("Basic")
            }
            MenuNavigationButton("Table View") {
                UIViewControllerAdapter {
                    TableViewExampleVC(pubId: pubId, tagId: tagId)
                }.navigationTitle("UITableView")
            }
            MenuNavigationButton("InStream Content Override") {
                UIViewControllerAdapter {
                    InStreamContentOverrideVC()
                }.navigationTitle("InStream")
            }
            MenuNavigationButton("InStream: Merge Config") {
                UIViewControllerAdapter {
                    MergeContentConfigVC()
                }.navigationTitle("InStream: Merge Config")
            }
            MenuNavigationButton("ContentTimeChange") {
                UIViewControllerAdapter {
                    ContentTimeChangeViewController(pubId: contentTimeUpdatesPubId, tagId: contentTimeUpdatesTagId)
                }.navigationTitle("Content Time Change")
            }
            
//            MenuNavigationButton("ContentSearch") {
//                UIViewControllerAdapter {
//                    SearchResponseViewController(pubId: pubId, tagId: tagId)
//                }.navigationTitle("Search Response")
//            }
            AppButton("Interstitial", backgroundColor: .gray) {
                let config = AdPlayerInterstitialConfiguration(
                    stalledVideoTimeout: 2.0,
                    showCloseButtonAfterAdDuration: true
                )
                AdPlayer.showInterstitial(pubId: pubId, tagId: tagId, configuration: config) {
                    topFadingMessage = "Interstitial Closed"
                }
            }
            Divider()
            Text("SwiftUI")
            MenuNavigationButton("Basic") {
                BasicExampleView(pubId: pubId, tagId: tagId)
            }
            MenuNavigationButton("Scroll View") {
                ScrollViewExample(pubId: pubId, tagId: tagId)
            }
            Spacer()
            Text("SDK v.\(AdPlayerLite.sdkVersionName)")
        }.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
        .padding(.horizontal)
    }
}
