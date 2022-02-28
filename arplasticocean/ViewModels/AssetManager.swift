//
//  AssetManager.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/27.
//

import Foundation
import RealityKit

/// Manage assets
///
/// * Stage Asset: stored one entity at once. overwritten by new one.
/// * Boat Asset: stored one entity at once. overwritten by new one.
/// * Fish Assets: stored multiple entities. added new ones. never deleted.
/// * Refuse Assets: stored multiple entities. added new ones. never deleted.
class AssetManager {
    private var loadedStageName: String = ""    // load one entity at once
    private var loadedStageEntity: Entity?
    private var loadedBoatName: String = ""     // load one entity at once
    private var loadedBoatEntity: Entity?
    private var loadedNames: [String] = []      // load any entities permanently
    private var loadedEntities: [Entity] = []

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

    func loadBoatEntity(name: String) -> Entity? {
        if name != loadedBoatName {
            if let entity = try? Entity.load(named: name) {
                loadedBoatName = name
                loadedBoatEntity = entity
            } else {
                loadedBoatName = ""
                loadedBoatEntity = nil
            }
        }
        return loadedBoatEntity
    }

    func loadEntity(name: String) -> Entity? {
        var resultEntity: Entity?
        if !loadedNames.contains(name) {
            if let entity = try? Entity.load(named: name) {
                loadedNames.append(name)
                loadedEntities.append(entity)
                resultEntity = entity
            }
        } else {
            let index = loadedNames.firstIndex(of: name)!
            resultEntity = loadedEntities[index]
        }
        return resultEntity
    }
}
