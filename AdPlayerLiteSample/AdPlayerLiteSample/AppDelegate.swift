//
//  AppDelegate.swift
//  AdPlayerLiteSample
//
//  Created by Pavel Yevtukhov on 14.11.2024.
//

import AdPlayerLite
import UIKit

enum Constants {
    static let publisherId = "565c56d3181f46bd608b459a" // replace with yor data
    static let tagId = "646a0773ea9d79fc1d0d45b4" // replace with yor data
    static let contentTimeChangeEventPubId = "565c56d3181f46bd608b459a" // replace with yor data
    static let contentTimeChangeEventTagId = "64b4da00ce6021de5b026d24" // replace with yor data
    static let storeURL = "https://apps.apple.com/us/app/adplayer-sample/id1234567" // replace with yor data
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let demoStoreURL = URL(string: Constants.storeURL)!
        AdPlayer.initSDK(storeUrl: demoStoreURL)
        return true
    }
}
