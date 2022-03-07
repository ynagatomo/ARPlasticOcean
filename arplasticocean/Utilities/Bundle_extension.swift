//
//  Bundle_extension.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/07.
//

import Foundation

extension Bundle {
    var appName: String {
        return (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    }

    var appVersion: String {
        return (object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }

    var buildNumber: String {
        return (object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0"
    }

    var buildNumberValue: Int {
        #if DEBUG
        if DevConstant.build100 {
            return 100
        } else {
            return Int((object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0") ?? 0
        }
        #else
            return Int((object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0") ?? 0
        #endif
    }
}
