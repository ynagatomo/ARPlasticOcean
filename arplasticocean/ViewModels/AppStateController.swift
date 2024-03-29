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
    #if DEBUG // not private
    @AppStorage("savedCleanupCount") var savedCleanupCount = 0
    @AppStorage("lastAppReviewCleanupCount") var lastAppReviewCleanupCount = 0
    @AppStorage("approvedMedalLevel") var approvedMedalLevel = 0 // 0: no medal
    #else // private
    @AppStorage("savedCleanupCount") private var savedCleanupCount = 0
    @AppStorage("lastAppReviewCleanupCount") private var lastAppReviewCleanupCount = 0
    @AppStorage("approvedMedalLevel") private var approvedMedalLevel = 0 // 0: no medal
    #endif

    @AppStorage("showingGuideAgain") var showingGuideAgain = true   // true: will show the guide again
    @AppStorage("showedPreviousBuild") var showedPreviousBuild: Int = 0
    var willShowGuide: Bool {
        showingGuideAgain
        || showedPreviousBuild != Bundle.main.buildNumberValue
    }

    @AppStorage("soundEnable") var soundEnable = true {
        didSet {
            soundManager.enable = soundEnable
        }
    }
    @Published private(set) var cleanupCount = 0

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

    init() {
        cleanupCount = savedCleanupCount
        soundManager.enable = soundEnable
    }

    // removed at Ver.1.2
    //    func shouldApproveNewMedal() -> Bool {
    //        guard let medal = cleanupMedal else { return false }
    //
    //        var result = false
    //        if approvedMedalLevel != medal.level {
    //            result = true
    //        }
    //        return result
    //    }

    // removed at Ver.1.2
    //    func approvedNewMedal() {
    //        guard let medal = cleanupMedal else { return }
    //        approvedMedalLevel = medal.level
    //    }

    /// Set the stage cleaned and move to the next stage
    func setCleaned() {
        // cleanup count ++
        setCleanupCount(cleanupCount + 1)
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
        // changed showing it once at Ver.1.2
        if cleanupCount >= AppConstant.appReviewCount
            && lastAppReviewCleanupCount == 0 {
            lastAppReviewCleanupCount = cleanupCount
            isShowing = true
        }
        // removed at Ver.1.2
        //    if cleanupCount % AppConstant.appReviewInterval == 0
        //        && lastAppReviewCleanupCount != cleanupCount {
        //        lastAppReviewCleanupCount = cleanupCount
        //        isShowing = true
        //    }
        return isShowing
    }
}
