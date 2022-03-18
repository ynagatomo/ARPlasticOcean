//
//  Boat.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/18.
//

import RealityKit

class Boat {
    let constant: BoatAssetConstant
    var position: SIMD3<Float>
    private(set) var entity: Entity?
    private(set) var topLevelModelEntity: ModelEntity?

    init(constant: BoatAssetConstant, position: SIMD3<Float>) {
        self.constant = constant
        self.position = position
    }

    func setEntity(entity: Entity) {
        entity.position = position  // initial position
        self.entity = entity
    }

    // swiftlint:disable function_body_length
    func addPhysics() {
        guard let entity = entity else { return }

        // find the `Surface` Model Entity
        if let theEntity = entity.findEntity(named: constant.topLevelModelEntityName) {
            debugLog("DEBUG: BOAT: found top-level-model-entity.")
            if let modelEntity = theEntity as? ModelEntity {
                debugLog("DEBUG: casted the Entity to a ModelEntity safely.")
                topLevelModelEntity = modelEntity

                // Don't add physics if the model-entity already has them.
                // The model-entity can have physics because the entity is reused with the AssetManager.
                guard modelEntity.collision == nil else {
                    assert(modelEntity.physicsBody != nil)
                    // This ModelEntity already has CollisionComponent and PhysicsBodyComponent.
                    debugLog("DEBUG: This boat Entity already has CollisionComponent and PhysicsBodyComponent.")
                    return
                }

                // calculate the offset based on the `Boat` Object position
                let boxes: [(size: SIMD3<Float>, offset: SIMD3<Float>)] = [
                    // bottom (y+) collision box
                    (size: SIMD3<Float>([constant.volume.x, constant.thickness, constant.volume.z]),
                     offset: SIMD3<Float>([constant.position.x,
                                           constant.position.y + constant.volume.y,
                                           constant.position.z])),
                    // bottom (y-) collision box
                    (size: SIMD3<Float>([constant.volume.x, constant.thickness, constant.volume.z]),
                     offset: SIMD3<Float>([constant.position.x,
                                           constant.position.y, // - constant.thickness / 2.0,
                                           constant.position.z])),
                    // right (x+) collision box
                    (size: SIMD3<Float>([constant.thickness, constant.volume.y, constant.volume.z]),
                     offset: SIMD3<Float>([
                        constant.position.x + constant.volume.x / 2.0 + constant.thickness / 2.0,
                        constant.position.y + constant.volume.y / 2.0,
                        constant.position.z])),
                    // left (x-) collision box
                    (size: SIMD3<Float>([constant.thickness, constant.volume.y, constant.volume.z]),
                     offset: SIMD3<Float>([
                        constant.position.x - constant.volume.x / 2.0 - constant.thickness / 2.0,
                        constant.position.y + constant.volume.y / 2.0,
                        constant.position.z])),
                    // far (z+) collision box
                    (size: SIMD3<Float>([constant.volume.x, constant.volume.y, constant.thickness]),
                     offset: SIMD3<Float>([constant.position.x,
                        constant.position.y + constant.volume.y / 2.0,
                        constant.position.z + constant.volume.z / 2.0 + constant.thickness / 2.0])),
                    // near (z-) collision box
                    (size: SIMD3<Float>([constant.volume.x, constant.volume.y, constant.thickness]),
                     offset: SIMD3<Float>([constant.position.x,
                        constant.position.y + constant.volume.y / 2.0,
                        constant.position.z - constant.volume.z / 2.0 - constant.thickness / 2.0]))
                ]

                var shapes: [ShapeResource] = []
                boxes.forEach { box in
                    shapes.append(ShapeResource
                                    .generateBox(size: box.size)
                                    .offsetBy(translation: box.offset)
                    )
                }

                // add Collision Component and Physics Component
                modelEntity.collision = CollisionComponent(shapes: shapes)
                modelEntity.physicsBody = PhysicsBodyComponent(shapes: shapes, mass: constant.physicsMass,
                            material: PhysicsMaterialResource.generate(friction: constant.physicsFriction,
                                                                       restitution: constant.physicsRestitution),
                            mode: .static)
            }
        }
    }

    #if DEBUG
    static func verify(names: [String]) -> Bool {
        var result = false
        for name in names {
            if let entity = try? Entity.load(named: name),
               let theEntity = entity.findEntity(named: AssetConstant.boatModelName) {
                if theEntity as? ModelEntity != nil {
                    result = true // all conditions are ok.
                }
            }
        }
        return result
    }
    #endif
}
