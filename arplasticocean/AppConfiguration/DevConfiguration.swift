//
//  DevConfiguration.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/03.
//

#if DEBUG
import Foundation

struct DevConstant {
    static let showingARDebugOptions = false
    static let singleRefuse = false
    static let build100 = false
    static let movingCamera = false
}

class DevConfiguration {
    var showingARDebugOptions = DevConstant.showingARDebugOptions
    var singleRefuse = DevConstant.singleRefuse
    var usingMovingCamera = DevConstant.movingCamera
}
#endif
