//
//  arplasticoceanApp.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/21.
//

import SwiftUI

@main
struct ARPlasticOceanApp: App {
    @StateObject var appStateController = AppStateController()

    @State private var showingGuide = false

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appStateController)
                .onAppear {
                    showingGuide = appStateController.willShowGuide
                }
                .sheet(isPresented: $showingGuide) {
                    WelcomeView(showingAgain: $appStateController.showingGuideAgain)
                        .onAppear {
                            appStateController.showedPreviousBuild = Bundle.main.buildNumberValue
                        }
                }
        }
    }
}

#if DEBUG
var devConfiguration = DevConfiguration()
#endif
