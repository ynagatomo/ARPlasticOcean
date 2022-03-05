//
//  Stage.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/27.
//

import Foundation
import RealityKit

// swiftlint:disable file_length

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

class FishGroup {
    let fishGroupConstant: FishGroupConstant
    let fishRouteConstant: FishRouteConstant
    var fishAssetConstant: FishAssetConstant!
    var fishes: [Fish] = []
    let bottomY: Float   // sea bottom position on Y axis [m]

    var modelFileName: String {
        fishAssetConstant.modelFile
    }

    init(constant: FishGroupConstant, bottomY: Float) {
        self.fishGroupConstant = constant
        fishRouteConstant = SceneConstant.fishRoutes[constant.fishRouteIndex]
        self.bottomY = bottomY
    }

    func prepare() {
        // choose one fish-property-constant index
        let fishPropertyConstantIndex = chooseFish()
        assert(fishPropertyConstantIndex < SceneConstant.fishProperties.count)
        let fishPropertyConstant = SceneConstant.fishProperties[fishPropertyConstantIndex]
        let fishAssetIndex = fishPropertyConstant.assetIndex
        fishAssetConstant = AssetConstant.fishAssets[fishAssetIndex]

        // create Fish objects
        var angle: Float = 0.0
        for _ in 0 ..< fishGroupConstant.fishNumber {
            let fish = Fish(constant: fishAssetConstant,
                            angleOffset: angle,
                            positionDiff: fishGroupConstant.fishDiffMax)
            fishes.append( fish )
            angle += Float.random(in: fishGroupConstant.fishAngleGap.min
                                  ... fishGroupConstant.fishAngleGap.max)
        }
    }

    func setEntities(_ entities: [Entity?]) {
        assert(entities.count == fishes.count)
        for index in 0 ..< entities.count {
            fishes[index].setEntity(entities[index])
            // set initial position (set position before adding physics in dynamic mode)
//            let position = calcFishPosition(fishIndex: index, deltaTime: 0.0)
//            let position = fishRouteConstant.fishInitPosition
//            entities[index]?.position = position
            // set initial target position
            let targetPosition = calcFishPosition(fishIndex: index, deltaTime: 0.0)
//            fishes[index].targetPosition = targetPosition
            fishes[index].setInitialPosition(targetPosition: targetPosition, bottomY: bottomY)
        }
    }

    #if DEBUG
    func setTargetEntities(_ entities: [ModelEntity]) {
        assert(entities.count == fishes.count)
        for index in 0 ..< entities.count {
            fishes[index].setTargetEntity(entities[index])
            // set initial position
            fishes[index].updateTargetEntity()
//            let position = calcFishPosition(fishIndex: index, deltaTime: 0.0)
//            entities[index].position = position
        }
    }
    #endif

    func addPhysics() {
        fishes.forEach { $0.addPhysics() }
    }

    func update(deltaTime: Double) {
        for index in 0 ..< fishes.count {
            // update each target positions
            let targetPosition = calcFishPosition(fishIndex: index, deltaTime: deltaTime)
            fishes[index].targetPosition = targetPosition
            fishes[index].update()
        }

        #if DEBUG
        if devConfiguration.showingFishTargets {
            for index in 0 ..< fishes.count {
//                let position = calcFishPosition(fishIndex: index, deltaTime: deltaTime)
//                fishes[index].targetEntity?.position = position
                fishes[index].updateTargetEntity()
            }
        }
        #endif
    }

    private func calcFishPosition(fishIndex: Int, deltaTime: Double) -> SIMD3<Float> {
        let time = fishes[fishIndex].time + Float(deltaTime)
        fishes[fishIndex].time = time   // update
        let angleOffset = fishes[fishIndex].angleOffset

        // multiply -1 to adopt right-hand system
        let angle = -(fishGroupConstant.fishVelocity * time + angleOffset)
        // an ellipse shape
        let xPos = fishRouteConstant.radiusX * cosf(angle)
                    + fishRouteConstant.origin.x
        let zPos = fishRouteConstant.radiusZ * sinf(angle)
                    + fishRouteConstant.origin.z
        // sin
        let angle2 = fishGroupConstant.fishVelocity * time / fishRouteConstant.cycleRateY
                    + angleOffset
        let yPos = fishRouteConstant.radiusY * sinf(angle2)
                    + fishRouteConstant.origin.y

        // rotate on the X-Z plane
        let angle3 = angle * fishRouteConstant.cycleMulRateXZ
                           / fishRouteConstant.cycleDivRateXZ
        let xPos2 = xPos * cosf(angle3) - zPos * sinf(angle3)
        let zPos2 = xPos * sinf(angle3) + zPos * cosf(angle3)

        // shift positon (x, y, z) slightly
        let position = SIMD3<Float>([xPos2, yPos, zPos2]) + fishes[fishIndex].positionDiff
        return position
    }

    /// Choose one fish from the candidates
    /// - Returns: chosen index of FishPropertyConstant
    ///
    /// It is chosen based on the probability of each fish
    /// When all fish are not chosen, index 0 will be chosen by default.
    private func chooseFish() -> Int {
        var chosenIndex: Int = 0    // default chosen index = 0
        for index in fishGroupConstant.fishPropertyIndexes {
            assert(index < SceneConstant.fishProperties.count)
            let fishPropertyConstant = SceneConstant.fishProperties[index]
            if fishPropertyConstant.selectProbability > Float.random(in: 0 ..< 1.0) {
                chosenIndex = index
                break
            }
        }
        return chosenIndex
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
    var entity: Entity?
    private var modelEntity: ModelEntity? // top level ModelEntity
    var time: Float = 0.0   // [sec] accumulated time during swiming
    let angleOffset: Float   // [radian]
    let positionDiff: SIMD3<Float>  // [m] position difference (gap)
    var targetPosition = SIMD3<Float>.zero    // [m] target position
    #if DEBUG
    var targetEntity: ModelEntity?
    #endif

    init(constant: FishAssetConstant, angleOffset: Float, positionDiff: Float) {
        self.constant = constant
        self.angleOffset = angleOffset
        self.positionDiff = SIMD3<Float>([
            Float.random(in: -positionDiff ... positionDiff),
            Float.random(in: -positionDiff ... positionDiff),
            Float.random(in: -positionDiff ... positionDiff)
        ])
    }

    func setEntity(_ entity: Entity?) {
        // keep the Entity
        self.entity = entity
        // find the ModelEntity
        if let entity = entity,
           let theEntity = entity.findEntity(named: constant.modelEntityName),
           let model = theEntity as? ModelEntity {
            debugLog("DEBUG: found fish ModelEntity.")
            modelEntity = model
        }
    }

    func setInitialPosition(targetPosition: SIMD3<Float>, bottomY: Float) {
        self.targetPosition = targetPosition
        let position = SIMD3<Float>([
            targetPosition.x,
            bottomY + constant.volume.y / 2.0 + 0.01,  // 0.01 : margine
            targetPosition.z
        ])
        entity?.position = position
    }

    func update() {
    }

    #if DEBUG
    func setTargetEntity(_ entity: ModelEntity) {
        self.targetEntity = entity
    }
    #endif

    #if DEBUG
    func updateTargetEntity() {
        targetEntity?.position = targetPosition
    }
    #endif

    func addPhysics() {
//        // find the ModelEntity
//        if let theEntity = entity?.findEntity(named: constant.modelEntityName) {
//            debugLog("DEBUG: Fish: found a model-entity.")
//            if let modelEntity = theEntity as? ModelEntity {
//                debugLog("DEBUG: casted the Entity to a ModelEntity safely.")
        let shape = ShapeResource.generateBox(size: constant.volume)
        modelEntity?.collision = CollisionComponent(shapes: [shape])
        modelEntity?.physicsBody = PhysicsBodyComponent(shapes: [shape],
                                                       mass: constant.physicsMass,
                                    material: PhysicsMaterialResource.generate(
                                        friction: constant.physicsFriction,
                                        restitution: constant.physicsRestitution))
        modelEntity?.physicsBody?.mode = .dynamic
//            }
//        }
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
