//
//  AppConstant.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import Foundation

class AppConstant {
    // Support page URL
    static let supportURLstring = NSLocalizedString("https://www.atarayosd.com/apo/support.html",
                                             comment: "Support page URL.")
    //               String(localized: "https://www.atarayosd.com/apo/support.html", // iOS 15.0+
    //                      comment: "Support page URL.")

    // App Review URL
    // TODO: replace the app ID with AR Plastic Ocean app's one
    static let reviewURLstring = NSLocalizedString("https://apps.apple.com/app/id1564570252?action=write-review",
                                       comment: "App Review URL.")
    //               String(localized: "https://apps.apple.com/app/id1564570252?action=write-review", // iOS 15.0+
    //                                 comment: "App Review URL.")

    // Twitter App Account URL (not localized)
    static let twitterURLstring = "https://twitter.com/ARPlasticOcean"

    // App Review
    static let appReviewInterval = 27 // cleanup count interval

//    // Sound Effect: getting Medal
//    static let soundMedalName = "medal1"
//    static let soundMedalExt = "mp3"
//    // Sound Effect: finished cleanup
//    static let soundCleanupName = "cleanup1"
//    static let soundCleanupExt = "mp3"
//    // Sound Effect: collecting refuse
//    static let soundCollectingName = "collect1"
//    static let soundCollectingExt = "mp3"

    static let cleanedMessageImageName: String = "cleaned" // image file name in bundle
    static let showingCleanedMessageTime: Float = 5.0 // [sec]
}
