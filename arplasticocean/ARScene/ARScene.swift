//
//  ARScene.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import Foundation
import RealityKit
import Combine

class ARScene {
    private(set) var isCleaned = false
    enum State {
        case collecting // collecting refuses
        case cleaned    // cleaned
    }
    private(set) var state: State = .collecting
    private let stageIndex: Int
    private let assetManager: AssetManager
    private var arView: ARView!
    private var anchor: AnchorEntity!
    private var stageEntity: Entity!
    private var renderLoopSubscription: Cancellable?
    private var animationPlaybackControllers: [AnimationPlaybackController] = []

    private var stage: Stage!
    private var boat: Boat!
    private var fishes: [Fish] = []
    private var refuses: [Refuse] = []

    init(stageIndex: Int, assetManager: AssetManager) {
        self.stageIndex = stageIndex
        self.assetManager = assetManager
    }

    func prepare(arView: ARView, anchor: AnchorEntity) {
        self.arView = arView
        self.anchor = anchor
        // load entities and place them in the AR world.
        prepareStage()
        // load entities and place them in the AR world.
        prepareBoat()
        // load entities and place them in the AR world.
        prepareFishes()
        // load entities and place them in the AR world.
        prepareRefuses()
    }

    func startSession() {
        renderLoopSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            DispatchQueue.main.async {
                self.updateScene(deltaTime: event.deltaTime)
            }
        }

        // start playing entity's animations
        // start playing sounds
        // start handling gestures
        // start handling AR runloop
    }

    func stopSession() {
        renderLoopSubscription?.cancel()

        // stop handling AR runloop
        // stop handling gestures
        // stop playing sounds
        // stop playing entity's animations
    }

    func tapped(_ tappedEntity: Entity) {
        debugPrint("DEBUG: Entity \(tappedEntity.name) was tapped.")

        if tappedEntity.findEntity(named: "Refuse") != nil {
            let transform = Transform(scale: SIMD3<Float>([1.0, 1.0, 1.0]),
                     rotation: simd_quatf(),
                     translation: SIMD3<Float>([
                        Float.random(in: -SceneConstant.gazeXZ ... SceneConstant.gazeXZ) ,
                        SceneConstant.collectingYPosition,
                        Float.random(in: -SceneConstant.gazeXZ ... SceneConstant.gazeXZ)]))
            animationPlaybackControllers.append(tappedEntity.move(to: transform,
                              relativeTo: stageEntity, duration: 1))
        }
    }

    private func updateScene(deltaTime: Double) {   // deltaTime [sec] (about 0.016)
        // play the rolling animations of refuses
        refuses.forEach { refuse in
            // angular is reversed (+/-) because z axis upside down
            refuse.angle -= refuse.angularVelocity * Float(deltaTime)
            refuse.angle = Float.normalize(radian: refuse.angle)  // -2Pi...2Pi [radian]
            // rotate deltaAngular on the X-Z plane
            // TODO: modify to the simd operation
            let xInit = refuse.initialPosition.x
            let yInit = refuse.initialPosition.y
            let zInit = refuse.initialPosition.z
            let xNext = xInit * cosf(refuse.angle) - zInit * sinf(refuse.angle)
            let yNext = yInit + sinf(refuse.angle) * refuse.movingPosYRange
            let zNext = xInit * sinf(refuse.angle) + zInit * cosf(refuse.angle)
            refuse.entity.position = SIMD3<Float>([xNext, yNext, zNext])
        }

        // play the collecting animations
        if !animationPlaybackControllers.isEmpty {
            // When completed, change the physics mode to dynamic.
            animationPlaybackControllers.forEach { animationController in
                if animationController.isComplete {
                    if let entity = animationController.entity {
                        if let model = entity as? ModelEntity {
                            model.physicsBody?.mode = .dynamic
                        }
                    }
                }
            }

            // remove completed controllers
            animationPlaybackControllers.removeAll(where: {
                $0.isComplete
            })
        }
    }

    private func prepareStage() {
        // instantiate the stage object
        stage = Stage(constant: AssetConstant.stageAssets[stageIndex])
        // prepare the material settings
        let materialSetting = AssetManager.MaterialSetting(
            textureName: stage.constant.textureName,
            domeShowing: stage.constant.domeShowing,
            domeEntityName: stage.constant.domeEntityName,
            surfaceEntityName: stage.constant.surfaceEntityName,
            baseShowing: stage.constant.baseShowing,
            baseEntityName: stage.constant.baseEntityName)
        // load and clone the entity
        if let entity = assetManager.loadAndCloneStageEntity(
            name: stage.constant.modelFile,             // stage USDZ file name
            textureName: stage.constant.modelTexture,   // texture image name in the USDZ file
            materialSetting: materialSetting
        ) {
            // adjust position and scale
            entity.position = SceneConstant.origin  // scene origin
            entity.scale = SceneConstant.scale      // scene scale
            // set the entity
            stage.setEntity(entity: entity)
            // add CollisionComponent and PhysicsBodyComponent
            stage.addPhysics()
            // place it in the AR world
            anchor.addChild(entity)
            stageEntity = entity
        }
    }

    private func prepareBoat() {
        let boatAssetIndex = SceneConstant.stageConstants[stageIndex].boatAssetIndex
        // instantiate the boat object
        let surfaceY = AssetConstant.stageAssets[stageIndex].offset
                       - AssetConstant.stageAssets[stageIndex].surface
        boat = Boat(constant: AssetConstant.boatAssets[boatAssetIndex],
                    position: SIMD3<Float>([0.0, surfaceY, 0.0])) // initial boat position
        // load the entity
        if let entity = assetManager.loadBoatEntity(name: boat.constant.modelFile) {
            // set the entity (The initial position will be set.)
            boat.setEntity(entity: entity)
            // add CollisionComponent and PhysicsBodyComponent
            boat.addPhysics()
            // place it in the AR world
            stageEntity.addChild(entity)
        }
    }

    private func prepareFishes() {
        // choose fish (type and number)
        // instantiate the fish objects
        // load and clone their entities
        // add a collision shape each fish
        // set position
        // place them in the AR world (add as a stage's child)
    }

    // MARK: - Prepare Refuse

    private func prepareRefuses() {
//        let mesh = MeshResource.generateSphere(radius: 0.075)
//        let material = SimpleMaterial(color: .red, isMetallic: false)
//        let collisionShape = ShapeResource.generateSphere(radius: 0.075)
//        let entity = ModelEntity(mesh: mesh,
//                                 materials: [material],
//                                 collisionShape: collisionShape,
//                                 mass: 1.0)
//        entity.physicsBody?.mode = .static
//        stageEntity.addChild(entity)
//
//        let entity2 = ModelEntity(mesh: mesh,
//                                 materials: [material],
//                                 collisionShape: collisionShape,
//                                 mass: 1.0)
//        entity2.physicsBody?.mode = .static
//        stageEntity.addChild(entity2)

        // choose refuse for the stage
        let refuseAssetConstants: [RefuseAssetConstant] = selectRefuses()
        // create refuse objects
        for index in 0 ..< refuseAssetConstants.count {
            let refuseAssetConstant = refuseAssetConstants[index]

            // load and clone their entities
            if let entity = assetManager.loadAndCloneEntity(
                name: refuseAssetConstant.modelFile) {

                // instantiate the refuse objects with initial position and angular velocity
                let posAndRouteIndex = calcRefuseInitialPosition(index: index)
                let refuse = Refuse(constant: refuseAssetConstant,
                                    entity: entity,
                                    position: posAndRouteIndex.position,
                  velocity: SceneConstant.refuseRoutes[posAndRouteIndex.routeIndex].angularVelocity,
                  movingPosYRange: SceneConstant.refuseRoutes[posAndRouteIndex.routeIndex].movingPosYRange)

                // modify the Entity position and orientation
                let orientation = calcRefuseInitialOrientation()
                entity.orientation = orientation
                entity.position = posAndRouteIndex.position

                // add a collision shape each refuse
                refuse.addPhysics()

                // place them in the AR world (add as a stage's child)
                stageEntity.addChild(entity)
                refuses.append(refuse) // keep the Refuse object
            }
        }
    }

    private func calcRefuseInitialPosition(index: Int)
    -> (position: SIMD3<Float>, routeIndex: Int) {
        // which route?
        var routeIndex = -1
        var routeCapacity = 0
        for numberIndex in 0 ..< SceneConstant.stageConstants[stageIndex].refuseNumbers.count {
            routeCapacity += SceneConstant.stageConstants[stageIndex].refuseNumbers[numberIndex]
            if index < routeCapacity {
                routeIndex = numberIndex
                break
            }
        }
        assert(routeIndex != -1, "Failed to decide the route index.")
        assert(routeIndex < SceneConstant.refuseRoutes.count)

        let indexOntheRoute = index - routeCapacity // index on the each route
        let angularUnit = 2.0 * Float.pi // divide the 2Pi for each refuse equally
            / Float(SceneConstant.stageConstants[stageIndex].refuseNumbers[routeIndex])
        let angular = angularUnit * Float(indexOntheRoute)

        let eachX = SceneConstant.refuseRoutes[routeIndex].radius * cosf(angular)
        let eachZ = -SceneConstant.refuseRoutes[routeIndex].radius * sinf(angular)
        let diffX = Float.random(in: 0 ..< SceneConstant.refuseRoutes[routeIndex].initPosXZRange)
        let diffZ = Float.random(in: 0 ..< SceneConstant.refuseRoutes[routeIndex].initPosXZRange)
        let posX = SceneConstant.refuseRoutes[routeIndex].origin.x + eachX + diffX
        let posZ = SceneConstant.refuseRoutes[routeIndex].origin.z + eachZ + diffZ

        let diffY = Float.random(in: 0 ..< SceneConstant.refuseRoutes[routeIndex].initPosYRange)
        let posY = SceneConstant.refuseRoutes[routeIndex].origin.y + diffY

        return (position: SIMD3<Float>([posX, posY, posZ]), routeIndex: routeIndex)
    }

    private func calcRefuseInitialOrientation() -> simd_quatf {
        simd_quatf(angle: 2.0 * Float.pi * Float.random(in: 0 ..< 1.0),
                   axis: SIMD3<Float>([
                    Float.random(in: 0 ... 1.0),
                    Float.random(in: 0 ... 1.0),
                    Float.random(in: 0 ... 1.0)
                   ]))
    }

    private func selectRefuses() -> [RefuseAssetConstant] {
        // The number of refuses in the stage (adding number of each route)
        var refuseNumber = 0
        SceneConstant.stageConstants[stageIndex].refuseNumbers.forEach {
            refuseNumber += $0
        }
        // The indexes of the refuse assets in the stage
        let indexes: [Int] = SceneConstant.stageConstants[stageIndex].refuseProperties.map({
            $0.assetIndex
        })
        // Select refuse assets and collect their constant
        var assetConstants: [RefuseAssetConstant] = []
        for _ in 0 ..< refuseNumber {
            let refuseAssetIndex = indexes[ Int.random(in: 0 ..< indexes.count) ]
            assetConstants.append(AssetConstant.refuseAssets[refuseAssetIndex])
        }
        return assetConstants
    }
}
