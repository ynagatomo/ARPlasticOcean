//
//  Stage.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/27.
//

import Foundation
import RealityKit

class Stage {
    enum State {
        case collecting // collecting refuses
        case cleaned    // cleaned
    }
    private(set) var state: State = .collecting

    let constant: StageAssetConstant
    private(set) var entity: Entity?
    private(set) var topLevelModelEntity: ModelEntity?
    private(set) var collectedRefuseNumber: Int = 0 // number of collected refuses

    init(constant: StageAssetConstant) {
        self.constant = constant
    }

    func setEntity(entity: Entity) { // TODO: merge into init()
        self.entity = entity
    }

    // A refuse was collected.
    func collectedRefuse() {
        collectedRefuseNumber += 1
    }

    // The stage was cleaned.
    func cleaned() {
        assert(state == .collecting)
        state = .cleaned
        debugPrint("DEBUG: The stage just cleaned!!!!!!!!!!!!1!")
    }

    // swiftlint:disable function_body_length
    func addPhysics() {
        guard let entity = entity else { return }

        // find the `Surface` Model Entity
        if let theEntity = entity.findEntity(named: constant.topLevelModelEntityName) {
            debugLog("DEBUG: found top-level-model-entity.")
            if let modelEntity = theEntity as? ModelEntity {
                debugLog("DEBUG: casted the Entity to a ModelEntity safely.")
                topLevelModelEntity = modelEntity

                // Basically, stage ModelEntity does not have physics.
                // Because it is not reused with the AssetManager.
                guard modelEntity.collision == nil else {
                    assert(modelEntity.physicsBody != nil)
                    // This ModelEntity already has CollisionComponent and PhysicsBodyComponent.
                    debugLog("DEBUG: This stage Entity already has CollisionComponent and PhysicsBodyComponent.")
                    return
                }

                // calculate the offset based on the `Surface` Object position
                let yHeight = constant.radius - constant.surface
                let yCenterPos = (constant.offset - constant.surface) - yHeight / 2.0
                let boxes: [(size: SIMD3<Float>, offset: SIMD3<Float>)] = [
                    // top (y+) collision box
                    (size: SIMD3<Float>([constant.edge, constant.thickness, constant.edge]),
                     offset: SIMD3<Float>([0.0, constant.offset - constant.surface, 0.0])),
                    // bottom (y-) collision box
                    (size: SIMD3<Float>([constant.edge, constant.thickness, constant.edge]),
                     offset: SIMD3<Float>([0.0, -(constant.radius - constant.offset), 0.0])),
                    // right (x+) collision box
                    (size: SIMD3<Float>([constant.thickness, yHeight, constant.edge]),
                     offset: SIMD3<Float>([constant.edge / 2.0, yCenterPos, 0.0])),
                    // left (x-) collision box
                    (size: SIMD3<Float>([constant.thickness, yHeight, constant.edge]),
                     offset: SIMD3<Float>([-constant.edge / 2.0, yCenterPos, 0.0])),
                    // far (z-) collision box
                    (size: SIMD3<Float>([constant.edge, yHeight, constant.thickness]),
                     offset: SIMD3<Float>([0.0, yCenterPos, constant.edge / 2.0])),
                    // near (z+) collision box
                    (size: SIMD3<Float>([constant.edge, yHeight, constant.thickness]),
                     offset: SIMD3<Float>([0.0, yCenterPos, -constant.edge / 2.0]))
                ]

                var shapes: [ShapeResource] = []
                boxes.forEach { box in
                    shapes.append(ShapeResource
                                    .generateBox(size: box.size)
                                    .offsetBy(translation: box.offset)
                    )
                }

                // additional collision shapes
                constant.additionalCollisions.forEach { collisionConstant in
                    switch collisionConstant.shapeType {
                    case .box(width: let width, height: let height, depth: let depth):
                        shapes.append(ShapeResource
                                        .generateBox(width: width, height: height, depth: depth)
                                        .offsetBy(translation: collisionConstant.position)
                        )
                    case .sphere(radius: let radius):
                        shapes.append(ShapeResource
                                        .generateSphere(radius: radius)
                                        .offsetBy(translation: collisionConstant.position)
                        )
                    }
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
}

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
}

class Fish {
    enum State {
        case fine
        case weak
        case recovery
    }
    private(set) var state: State = .fine

    let constant: FishAssetConstant
    let entity: Entity
    private(set) var topLevelModelEntity: ModelEntity?

    init(constant: FishAssetConstant, entity: Entity) {
        self.constant = constant
        self.entity = entity
    }

    func addPhysics() {
    }
}

class Refuse {
    enum State {
        case free
        case trapped
        case disappear
    }
    private(set) var state: State = .free

    let constant: RefuseAssetConstant
    let entity: Entity
    private(set) var oneModelEntity: ModelEntity?

    var angle: Float = 0 // [radian] difference from the initial angular
    let angularVelocity: Float  // [radian/sec]
    let initialPosition: SIMD3<Float>
    let movingPosYRange: Float  // [m]
    let movingRate: Float   // [1.0...] rate of moving up and down

    static func freeNumber(refuses: [Refuse]) -> Int {
        return refuses.filter({ $0.state == .free }).count
    }

    init(constant: RefuseAssetConstant, entity: Entity,
         position: SIMD3<Float>, velocity: Float,
         movingPosYRange: Float, movingRate: Float) {
        self.constant = constant
        self.entity = entity
        self.initialPosition = position
        self.angularVelocity = velocity
        self.movingPosYRange = movingPosYRange
        self.movingRate = movingRate
    }

    func addPhysics() {
        // find the Model Entity
        if let theEntity = entity.findEntity(named: constant.modelEntityName) {
            debugLog("DEBUG: Refuse: found a model-entity.")
            if let modelEntity = theEntity as? ModelEntity {
                debugLog("DEBUG: casted the Entity to a ModelEntity safely.")
                oneModelEntity = modelEntity

                // Don't add physics if the model-entity already has them.
                // The model-entity can have physics because the entity is reused with the AssetManager.
                // However, in the almost cases, it does not have one because it was cloned newly.
                guard modelEntity.collision == nil else {
                    assert(modelEntity.physicsBody != nil)
                    // This ModelEntity already has CollisionComponent and PhysicsBodyComponent.
                    debugLog("DEBUG: This boat Entity already has CollisionComponent and PhysicsBodyComponent.")
                    return
                }

                let shape = ShapeResource.generateSphere(radius: constant.volumeRadius)
                modelEntity.collision = CollisionComponent(shapes: [shape])
                modelEntity.physicsBody = PhysicsBodyComponent(shapes: [shape],
                                                               mass: constant.physicsMass,
                                            material: PhysicsMaterialResource.generate(
                                                friction: constant.physicsFriction,
                                                restitution: constant.physicsRestitution))
                modelEntity.physicsBody?.mode = .static
            }
        }
    }
}
