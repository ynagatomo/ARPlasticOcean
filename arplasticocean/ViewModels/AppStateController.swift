//
//  AppStateController.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import Foundation
import SwiftUI

struct CleanupMedal {
    let level: Int      // [1, 2, 3, 4]
    let count: Int      // [10, 20, 30, 100]
    let imageName: String
}

// @MainActor
class AppStateController: ObservableObject {
    @AppStorage("savedCleanupCount") private var savedCleanupCount = 0
    @AppStorage("lastAppReviewCleanupCount") private var lastAppReviewCleanupCount = 0
    @AppStorage("soundEnable") var soundEnable = true {
        didSet {
            soundManager.enable = soundEnable
        }
    }
    @Published private(set) var cleanupCount = 0
//    @Published var isSoundEnable = true {
//        didSet {
//                soundManager.enable = isSoundEnable
//        }
//    }

    var stageIndex: Int {     // index of the next stage which will be cleaned
        cleanupCount % SceneConstant.stageCount
    }
    let assetManager: AssetManager = AssetManager()
    let soundManager: SoundManager = SoundManager()

    var cleanupMedal: CleanupMedal? {
        var medal: CleanupMedal?
        if cleanupCount >= 100 {
            medal = CleanupMedal(level: 4, count: 100, imageName: "medal100")
        } else if cleanupCount >= 30 {
            medal = CleanupMedal(level: 3, count: 30, imageName: "medal30")
        } else if cleanupCount >= 20 {
            medal = CleanupMedal(level: 2, count: 20, imageName: "medal20")
        } else if cleanupCount >= 10 {
            medal = CleanupMedal(level: 1, count: 10, imageName: "medal10")
        }
        return medal
    }

//    var nextStageIndex: Int {
//        stageIndex == SceneConstant.stageCount - 1 ? 0 : stageIndex + 1
//    }

    init() {
        cleanupCount = savedCleanupCount
        soundManager.enable = soundEnable
    }

    /// Set the stage cleaned and move to the next stage
    func setCleaned() {
        // cleanup count ++
        setCleanupCount(cleanupCount + 1)
//        // move to the next stage
//        stageIndex = nextStageIndex
    }

    /// Set the cleanup count.
    /// - Parameter count: clean up count [0...]
    ///
    /// The new cleanup count will be stored into the UserDefaults.
    func setCleanupCount(_ count: Int) {
        assert(count >= 0)
        if count != cleanupCount {
            debugLog("cleanupCount will be changed from \(cleanupCount) to \(count).")
            cleanupCount = count
            savedCleanupCount = count // Save it into the UserDefaults.
        } else {
            // swiftlint:disable line_length
            debugLog("setCleanupCount(\(count)) was called but the value is same as the current value. So it was just ignored.")
        }
    }

    func isShowingAppReview() -> Bool {
        var isShowing = false
        if cleanupCount % AppConstant.appReviewInterval == 0
            && lastAppReviewCleanupCount != cleanupCount {
            lastAppReviewCleanupCount = cleanupCount
            isShowing = true
        }
        return isShowing
    }
}

//    extension AppStateController {
//        func play(soundID: SoundManager.SoundID) {
//            soundManager.play(soundID: soundID, enable: soundEnable)
//        }
//
//        func stop(soundID: SoundManager.SoundID) {
//            soundManager.stop(soundID: soundID)
//        }
//    }
