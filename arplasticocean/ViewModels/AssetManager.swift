//
//  AssetManager.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/27.
//

import Foundation
import RealityKit

class AssetManager {
    private var loadedStageName: String = ""
    private var loadedStageEntity: Entity?

    func loadStageEntity(name: String) -> Entity? {
        if name != loadedStageName {
            if let entity = try? Entity.load(named: name) {
                loadedStageName = name
                loadedStageEntity = entity
            } else {
                loadedStageName = ""
                loadedStageEntity = nil
            }
        }
        return loadedStageEntity
    }
}
