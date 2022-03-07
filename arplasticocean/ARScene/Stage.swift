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

    func setEntity(entity: Entity) {
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

    var modelFileName: String {
        fishAssetConstant.modelFile
    }

    init(constant: FishGroupConstant) {
        self.fishGroupConstant = constant
        fishRouteConstant = SceneConstant.fishRoutes[constant.fishRouteIndex]
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
                            property: fishPropertyConstant,
                            angleOffset: angle,
                            positionDiff: fishGroupConstant.fishDiffMax)
            fishes.append( fish )
            let angleDiff = Float.random(in: fishGroupConstant.fishAngleGap.min
                                         ... fishGroupConstant.fishAngleGap.max)
            if fishGroupConstant.fishVelocity >= 0.0 { // + direction (Y axis) rotation
                angle += angleDiff
            } else { // - direction (Y axis) rotation
                angle -= angleDiff
            }
        }
    }

    func setEntities(_ entities: [Entity?]) {
        assert(entities.count == fishes.count)
        for index in 0 ..< entities.count {
            fishes[index].setEntity(entities[index])
            // set initial target position
            let result = calcFishPosition(fishIndex: index, deltaTime: 0.0)
            fishes[index].setInitialPosition(position: result.position, angle: result.angle)
        }
    }

    func startAnimation() {
        fishes.forEach { $0.startAnimation() }
    }

    func recover() {
        fishes.forEach { $0.recover() }
    }

    //    #if DEBUG
    //    func setTargetEntities(_ entities: [ModelEntity]) {
    //        assert(entities.count == fishes.count)
    //        for index in 0 ..< entities.count {
    //            fishes[index].setTargetEntity(entities[index])
    //            // set initial position
    //            fishes[index].updateTargetEntity()
    //        }
    //    }
    //    #endif

    //    func addPhysics() {
    //        fishes.forEach { $0.addPhysics() }
    //    }

    func collisions(with refuse: Refuse) -> [Int]? {
        var fishIndexes: [Int] = []

        for fishIndex in 0 ..< fishes.count {
            if fishes[fishIndex].isColliding(with: refuse) {
                fishIndexes.append(fishIndex)
            }
        }

        return fishIndexes.isEmpty ? nil : fishIndexes
    }

    func update(deltaTime: Double) {
        for index in 0 ..< fishes.count {
            // update each target positions
            let result = calcFishPosition(fishIndex: index, deltaTime: deltaTime)
            fishes[index].targetPosition = result.position
            fishes[index].fishAngle = result.angle
            fishes[index].update(deltaTime: Float(deltaTime)) // deltaTime: Float(deltaTime))
        }

        //    #if DEBUG
        //    if devConfiguration.showingFishTargets {
        //        for index in 0 ..< fishes.count {
        //            fishes[index].updateTargetEntity()
        //        }
        //    }
        //    #endif
    }

//    private func calcFishPosition(fishIndex: Int, deltaTime: Double) -> SIMD3<Float> {
//        let time = fishes[fishIndex].time + Float(deltaTime)
//        fishes[fishIndex].time = time   // update
//        let angleOffset = fishes[fishIndex].angleOffset
//
//        // multiply -1 to adopt right-hand system
//        let angle = -(fishGroupConstant.fishVelocity * time + angleOffset)
//        // an ellipse shape
//        let xPos = fishRouteConstant.radiusX * cosf(angle)
//                    + fishRouteConstant.origin.x
//        let zPos = fishRouteConstant.radiusZ * sinf(angle)
//                    + fishRouteConstant.origin.z
//        // sin
//        let angle2 = fishGroupConstant.fishVelocity * time / fishRouteConstant.cycleRateY
//                    + angleOffset
//        let yPos = fishRouteConstant.radiusY * sinf(angle2)
//                    + fishRouteConstant.origin.y
//
//        // rotate on the X-Z plane
//        let angle3 = angle * fishRouteConstant.cycleMulRateXZ
//                           / fishRouteConstant.cycleDivRateXZ
//        let xPos2 = xPos * cosf(angle3) - zPos * sinf(angle3)
//        let zPos2 = xPos * sinf(angle3) + zPos * cosf(angle3)
//
//        // shift positon (x, y, z) slightly
//        let position = SIMD3<Float>([xPos2, yPos, zPos2]) + fishes[fishIndex].positionDiff
//        return position
//    }

    private func calcFishPosition(fishIndex: Int, deltaTime: Double)
    -> (position: SIMD3<Float>, angle: Float) {
        let time = fishes[fishIndex].time + Float(deltaTime)
        fishes[fishIndex].time = time
        let angleOffset = fishes[fishIndex].angleOffset

        // on an ellipse
        let angle = fishGroupConstant.fishVelocity * time + angleOffset
        let (position: posXZ, angle: fishAngle) = calcPositionOnEllipse(radiusX: fishRouteConstant.radiusX,
                                           radiusZ: fishRouteConstant.radiusZ,
                                           inAngle: angle)
        // sin
        let angle2 = fishGroupConstant.fishVelocity * time / fishRouteConstant.cycleRateY
                    + angleOffset
        let yPos = fishRouteConstant.radiusY * sinf(angle2)
                    + fishRouteConstant.origin.y

        // rotate on the X-Z plane
        let angle3 = angle * fishRouteConstant.cycleMulRateXZ
                           / fishRouteConstant.cycleDivRateXZ
        let xPos2 = posXZ.x * cosf(-angle3) - posXZ.z * sinf(-angle3)
        let zPos2 = posXZ.x * sinf(-angle3) + posXZ.z * cosf(-angle3)
        let resultAngle = fishAngle + angle3

        // shift position (x, y, z) slightly
        let position = SIMD3<Float>([xPos2, yPos, zPos2]) + fishes[fishIndex].positionDiff
        return (position: position, angle: resultAngle)
    }

    private func calcPositionOnEllipse(radiusX: Float, radiusZ: Float, inAngle: Float)
    -> (position: (x: Float, z: Float), angle: Float) {
        var angle = inAngle
        // normalize the angle to (-2PI,2PI) (not include -2PI, 2PI)
        if inAngle >= Float.pi * 2.0 || inAngle <= -Float.pi * 2.0 {
            angle = inAngle.truncatingRemainder(dividingBy: Float.pi * 2.0)
        }
        assert(angle > -Float.pi * 2.0 && angle < Float.pi * 2.0) // not equal to -2PI or 2PI

        let positionX = radiusX * cosf(angle)
        let positionZ = radiusZ * sinf(angle)

        // an inclination of tangent
        var resultAngle: Float = 0.0
        if abs(positionZ) > 0.0001 { // > 0.1 mm
            let inclination = -(radiusZ * radiusZ / radiusX / radiusX) * positionX / positionZ
    //        print("angle = \(angle) k = \(inclination)")
            resultAngle = atanf(inclination)
        } else if positionZ >= 0.0 {
            resultAngle = -Float.pi / 2.0
        } else {
            resultAngle = Float.pi / 2.0
        }

        // +PI : modify the result to be continuous
        //       angle: 0 ... 2PI,  result: -(1/2)PI ... (3/4)PI
        if angle >= Float.pi {
            resultAngle += Float.pi
        } else if angle <= -Float.pi {
            resultAngle -= Float.pi
        }

        // +PI : modify to rotate PI for fish's up-side-down
        resultAngle += Float.pi

        // inverse y-position to fit the Z-axis
        return (position: (x: positionX, z: -positionZ), angle: resultAngle)
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
    let fishPropertyConstant: FishPropertyConstant
    var entity: Entity?
    private var modelEntity: ModelEntity? // top level ModelEntity
    var time: Float = 0.0   // [sec] accumulated time during swimming
    let angleOffset: Float   // [radian] diff of each fish on the same route
    let positionDiff: SIMD3<Float>  // [m] position difference (gap)
    var targetPosition = SIMD3<Float>.zero    // [m] target position
    var fishAngle: Float = 0.0
    var trapingRefuseNumber: Int = 0
    //    #if DEBUG
    //    var targetEntity: ModelEntity?
    //    #endif

    init(constant: FishAssetConstant, property: FishPropertyConstant,
         angleOffset: Float, positionDiff: Float) {
        self.constant = constant
        self.fishPropertyConstant = property
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

    func startAnimation() {
        guard let entity = entity else { return }

        if let animation = entity.availableAnimations.first {
            entity.playAnimation(animation.repeat(), transitionDuration: 0, startsPaused: false)
            //    entity.playAnimation(animation.repeat())  // iOS 15.0+
            //    entity.playAnimation(animation.repeat(),  // iOS 15.0+
            //                         transitionDuration: 0,
            //                         blendLayerOffset: 0,
            //                         separateAnimatedValue: false,
            //                         startsPaused: false,
            //                         clock: nil)
        }
    }

    func setInitialPosition(position: SIMD3<Float>, angle: Float) {
        self.targetPosition = position
        self.fishAngle = angle
        // set the position to Entity (not ModelEntity)
        entity?.position = position
        entity?.orientation = simd_quatf(angle: angle, axis: SIMD3<Float>([0.0, 1.0, 0.0]))
    }

    func update(deltaTime: Float) {
        guard state != .weak else { return }
        guard // let modelEntity = modelEntity,
              let entity = entity else { return }

        // set the target-position to Entity (not ModelEntity)
        entity.position = targetPosition
        entity.orientation = simd_quatf(angle: fishAngle, axis: SIMD3<Float>([0.0, 1.0, 0.0]))
    }

    func isColliding(with refuse: Refuse) -> Bool {
        guard state == .fine else { return false }
        guard let entity = entity else { return false }

        var result = false
        let diffX = entity.position.x - refuse.entity.position.x
        let diffY = entity.position.y - refuse.entity.position.y
        let diffZ = entity.position.z - refuse.entity.position.z

        let distance = diffX * diffX + diffY * diffY + diffZ * diffZ
        let threshold = constant.collisionRadius + refuse.constant.volumeRadius
        if distance < threshold * threshold {
            result = true
        }

        return result
    }

    func trapped() {
        trapingRefuseNumber += 1
        if trapingRefuseNumber >= fishPropertyConstant.trapCapacity {
            state = .weak
        }
    }

    func recover() {
        if state == .weak {
            state = .recovery
            if let entity = entity {
                entity.orientation = simd_quatf(angle: -constant.weakAngleX,
                                                axis: SIMD3<Float>([1.0, 0.0, 0.0]))
            }
        }
    }

    //    #if DEBUG
    //    func setTargetEntity(_ entity: ModelEntity) {
    //        self.targetEntity = entity
    //    }
    //    #endif
    //
    //    #if DEBUG
    //    func updateTargetEntity() {
    //        targetEntity?.position = targetPosition
    //    }
    //    #endif

//    func addPhysics() {
//        let shape = ShapeResource.generateBox(size: constant.volume)
//        modelEntity?.collision = CollisionComponent(shapes: [shape])
//        modelEntity?.physicsBody = PhysicsBodyComponent(shapes: [shape],
//                                                       mass: constant.physicsMass,
//                                    material: PhysicsMaterialResource.generate(
//                                        friction: constant.physicsFriction,
//                                        restitution: constant.physicsRestitution))
//        modelEntity?.physicsBody?.mode = .dynamic // .static
//        modelEntity?.physicsBody?.isRotationLocked = (x: true, y: false, z: true)
//        if let oldInertia = modelEntity?.physicsBody?.massProperties.inertia {
//            let newInertia = SIMD3<Float>([
//                oldInertia.x,
//                oldInertia.y * 100.0,
//                oldInertia.z
//            ])
//            modelEntity?.physicsBody?.massProperties.inertia = newInertia
//        }
//    }

//    func update(deltaTime: Float) {
//        guard state != .weak else { return }
//        guard let modelEntity = modelEntity,
//              let entity = entity else { return }
//
//        var showing = false
//
//        // need to add both of Entity and ModelEntity positions
//        let currentPos = entity.position + modelEntity.position
//        // remove
//        if currentPos.x >= 0.0 && currentPos.z >= 0.0 {
//            //            debugLog("DEBUG: currentPos = \(currentPos), angle = \(modelEntity.orientation.angle)")
//            showing = true
//        }
//
//        positions.append(currentPos)
//        if positions.count > 10 {
//            positions.remove(at: 0)
//        }
//        assert(positions.count <= 10)
//
//        let movingVect = targetPosition - currentPos
//        if movingVect == .zero { return }
//
//        let dumping = Float(0.5) * deltaTime / 0.017  // dumping rate
//        var forceY = Float(0.0)
//        if movingVect.y < 0.0 {
//            forceY = 9.8 - 0.05 * dumping  // movingVect.y * dumptimg // - 0.05
//        } else {
//            forceY = 9.8 + 0.05 * dumping // movingVect.y * dumptimg // + 0.05
//        }
//
//        // Add force
//
//        // let amp = Float(1.0)    // amplify rate
//        let forceX = movingVect.x // * amp
//        let forceZ = movingVect.z // * amp
//        let force = SIMD3<Float>([forceX, forceY, forceZ])
//        modelEntity.addForce(force,
//                             relativeTo: nil)
//
//        // Add torque
//
//        if positions.count == 10 {
//            let vect = currentPos - positions.first!
//            if vect.x != 0.0 || vect.z != 0.0 {
//                if !modelEntity.orientation.axis.y.isNaN {
//
//                    var currentAngle = modelEntity.orientation.angle
//                    if currentAngle < 0.0 {
//                        currentAngle += Float.pi * 2.0
//                    }
//                    assert(currentAngle >= 0.0 && currentAngle <= Float.pi * 2.0)
//                    let currentVect = SIMD3<Float>([
//                        cosf(-currentAngle),
//                        0.0,
//                        sinf(-currentAngle)
//                    ])
//                    let angle = calcAngle(currentVect, vect)
//                    let crossVect = crossVect(currentVect, vect)
//
//                    var torqueY = angle / 4.0 // 400.0
//                    if crossVect.y < 0.0 {
//                        torqueY *= -1.0
//                    }
//
//                    if angle > Float.pi / 2.0 || angle < -Float.pi / 2.0 {
//                        if previousAngle > Float.pi / 2.0 || previousAngle < -Float.pi / 2.0 {
//                            torqueY = previousTorque
//                        } else {
//                            previousTorque = torqueY
//                        }
//                    } else {
//                        previousTorque = torqueY
//                    }
//
//                    previousAngle = angle
//
//    //                    let torqueY = calcTorqueY(entityAngle: modelEntity.orientation.angle,
//    //                                vect: vect,
//    //                                              showing: showing)
//
//                    if showing {
//                        debugLog("DEBUG: torque = \(torqueY)")
//                    }
//
//                    modelEntity.addTorque(SIMD3<Float>([
//                            0.0, torqueY, 0.0
//                        ]), relativeTo: nil)
//                    //                    debugLog("DEBUG:    torque = \(torqueY)")
//                }
//            }
//            //            positions.removeAll()
//        }
//    }

//    private func calcAngle(_ vect1: SIMD3<Float>, _ vect2: SIMD3<Float>) -> Float {
//        let a1 = vect1.x
//        let a2 = vect1.z
//        let b1 = vect2.x
//        let b2 = vect2.z
//        let cosAngle = (a1 * b1 + a2 * b2) / sqrtf(a1 * a1 + a2 * a2) / sqrtf(b1 * b1 + b2 * b2)
//        let angle = acosf(cosAngle)
//        return angle
//    }

//    private func crossVect(_ vect1: SIMD3<Float>, _ vect2: SIMD3<Float>) -> SIMD3<Float> {
//        let a1 = vect1.x
//        let a2 = vect1.y
//        let a3 = vect1.z
//        let b1 = vect2.x
//        let b2 = vect2.y
//        let b3 = vect2.z
//        let vect = SIMD3<Float>([
//            a2 * b3 - a3 * b2,
//            a3 * b1 - a1 * b3,
//            a1 * b2 - a2 * b1
//        ])
//        return vect
//    }

//    private func calcTorqueY(entityAngle: Float, vect: SIMD3<Float>, showing: Bool)
//    -> Float {
//        guard !vect.x.isNaN && !vect.y.isNaN && !vect.z.isNaN else { return 0.0 }
//        assert(entityAngle <= Float.pi * 2.0 && entityAngle >= -Float.pi * 2.0)
//
//        // normalize 0...-2PI => 0...2PI
//        var currentAngle = entityAngle
//        if entityAngle < 0.0 { currentAngle += Float.pi * 2.0 }
//        assert(currentAngle >= 0.0 && currentAngle <= Float.pi * 2.0)
//
//        let len = sqrtf(vect.x * vect.x + vect.z * vect.z)
//        var targetAngle = acosf(vect.x / len)
//        assert(targetAngle >= 0.0 && targetAngle <= Float.pi)
//
//        if vect.z >= 0.0 {
//            targetAngle = Float.pi * 2.0 - targetAngle
//        }
//
//        // both of currentAngle and targetAngle were normalized
//        // between 0.0 and 2PI
//        var diffAngle = targetAngle - currentAngle
//        if diffAngle > Float.pi {
//            diffAngle = -(Float.pi * 2.0 - diffAngle)
//        } else if diffAngle < -Float.pi {
//            diffAngle = Float.pi * 2.0 + diffAngle
//        }
//
//        //        debugLog("DEBUG: diffAngle = \(diffAngle)")
//        assert(diffAngle >= -Float.pi && diffAngle <= Float.pi)
//        let torque = diffAngle / 100.0  // fix / 400.0
//        if showing {
//            debugLog("DEBUG:    diffAngle = \(diffAngle), torque = \(torque), vect = \(vect)")
//        }
//        return torque
//    }
}

class Refuse {
    enum State {
        case free
        case trapped
        case disappear
        case collected
    }
    private(set) var state: State = .free

    let constant: RefuseAssetConstant
    let entity: Entity
    private(set) var oneModelEntity: ModelEntity?

//    var angle: Float = 0 // [radian] difference from the initial angular
    var accumulatedTime: Float = 0.0
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

    func update(deltaTime: Double) {
        guard state == .free else { return }

        accumulatedTime += Float(deltaTime)
        // angular is reversed (+/-) because z axis upside down
        let angle = -angularVelocity * accumulatedTime
//        let angle = Float.normalize(radian: (-angularVelocity * accumulatedTime)) // -2PI...PI [rad]
//        angle -= angularVelocity * Float(deltaTime)
//        angle = Float.normalize(radian: angle)  // -2Pi...2Pi [radian]
        // rotate deltaAngular on the X-Z plane
        let xInit = initialPosition.x
        let zInit = initialPosition.z
        let xNext = xInit * cosf(angle) - zInit * sinf(angle)
        let zNext = xInit * sinf(angle) + zInit * cosf(angle)
        // move up and down on the Y-axis
        let yInit = initialPosition.y
        let yNext = yInit + sinf(angle * movingRate) * movingPosYRange
        entity.position = SIMD3<Float>([xNext, yNext, zNext])
    }

    func trapped() {
        assert(state == .free)
        state = .trapped
    }

    func disappear() {
        assert(state == .trapped)
        state = .disappear
        entity.isEnabled = false
    }

    func collected() {
        assert(state == .free)
        state = .collected
    }
}
