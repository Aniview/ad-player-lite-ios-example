//
//  AdPlayerLiteSampleApp.swift
//  AdPlayerLightQA
//
//  Created by Pavel Yevtukhov on 24.09.2024.
//

import SwiftUI
import AppTrackingTransparency

@main
struct AdPlayerLiteSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LandingView()
                .onAppear {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        print("Tracking: authorized:", status == .authorized)
                    }
                }
        }
    }
}
