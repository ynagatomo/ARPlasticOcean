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

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appStateController)
        }
    }
}

#if DEBUG
var devConfiguration = DevConfiguration()
#endif
