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

    // App Review URL
    static let reviewURLstring = NSLocalizedString("https://apps.apple.com/app/id1614059602?action=write-review",
                                       comment: "App Review URL.")

    // Twitter App Account URL (not localized)
    static let twitterURLstring = "https://twitter.com/ARPlasticOcean"

    // App Review
    static let appReviewInterval = 27 // cleanup count interval

    static let cleanedMessageImageName: String = "cleaned" // image file name in bundle
    static let showingCleanedMessageTime: Float = 5.0 // [sec]
}
