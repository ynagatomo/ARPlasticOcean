//
//  ARScene.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

import Foundation
import UIKit
import RealityKit
import Combine

// swiftlint:disable file_length
// swiftlint:disable type_body_length
class ARScene {
    private(set) var isCleaned = false
    enum State {
        case collecting // collecting refuses
        case cleaned    // cleaned
    }
    private(set) var state: State = .collecting
    private let stageIndex: Int
    private let assetManager: AssetManager
    private let soundManager: SoundManager
    private let cleanedImageView: UIImageView?
    private var arView: ARView!
    private var anchor: AnchorEntity!
    // private var cameraEntity: PerspectiveCamera?
    private var movingCamera: MovingCamera?
    private var stageEntity: Entity!
    private var renderLoopSubscription: Cancellable?
    private var animationPlaybackControllers: [AnimationPlaybackController] = []

    private var stage: Stage!
    private var boat: Boat!
    private var fishGroups: [FishGroup] = []
    private var refuses: [Refuse] = []
    private var soundIDCollecting: SoundManager.SoundID = 0
    private var soundIDCollected: SoundManager.SoundID = 0

    private var showingCleanedView: Bool = false
    private var showingCleanedViewTime: Float = 0.0

    init(stageIndex: Int, assetManager: AssetManager, soundManager: SoundManager,
         cleanedImageView: UIImageView?) {
        self.stageIndex = stageIndex
        self.assetManager = assetManager
        self.cleanedImageView = cleanedImageView
        self.soundManager = soundManager
    }

    func prepare(arView: ARView, anchor: AnchorEntity, camera: MovingCamera?) {
        self.arView = arView
        self.anchor = anchor
        // self.cameraEntity = cameraEntity
        self.movingCamera = camera
        prepareStage()
        prepareBoat()
        prepareFishes()
        prepareRefuses()
    }

    func startSession() {
        // start handling AR RunLoop
        renderLoopSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            DispatchQueue.main.async {
                self.updateScene(deltaTime: event.deltaTime)
            }
        }

        // start fish animation
        fishGroups.forEach { $0.startAnimation() }

        // start playing sounds
        soundManager.play(soundID: soundIDCollecting)
    }

    func stopSession() {
        // stop handling AR RunLoop
        renderLoopSubscription?.cancel()

        // stop playing sounds
        soundManager.stopAll()
    }

    func tapped(_ tappedEntity: Entity) {
        // Respond to the only tap to the Refuse Entities.
        if tappedEntity.findEntity(named: "Refuse") != nil {
            if let refuse = refuses.first(where: { refuse in
                var result = false
                if let model = refuse.oneModelEntity {
                    result = model.id == tappedEntity.id // ModelEntity is tappable.
                }
                return result
            }) {
                refuse.collected()
            } else {
                assertionFailure("Could no be found the tapped refuse.")
            }

            let transform = Transform(scale: SIMD3<Float>([1.0, 1.0, 1.0]),
                     rotation: simd_quatf(),
                     translation: SIMD3<Float>([
                        Float.random(in: -SceneConstant.gazeXZ ... SceneConstant.gazeXZ),
                        SceneConstant.collectingYPosition,
                        Float.random(in: -SceneConstant.gazeXZ ... SceneConstant.gazeXZ)]))
            animationPlaybackControllers.append(tappedEntity.move(to: transform,
                              relativeTo: stageEntity, duration: 1))
            soundManager.play(soundID: SoundManager.collectSoundID)
        }
    }

    // MARK: - Update Scenes

    private func updateScene(deltaTime: Double) {   // deltaTime [sec] (about 0.016)
        // move fish
        fishGroups.forEach { fishGroup in
            fishGroup.update(deltaTime: deltaTime)
        }

        // play the rolling animations of refuses
        refuses.forEach { refuse in
            refuse.update(deltaTime: deltaTime)
        }

        // handle collision between fish and refuses
        handleCollision()

        // check the completion of collecting animations and change the physics mode
        if !animationPlaybackControllers.isEmpty {
            // When completed, change the physics mode to dynamic.
            animationPlaybackControllers.forEach { animationController in
                if animationController.isComplete {
                    // change the physics mode: static -> dynamic
                    if let entity = animationController.entity {
                        if let model = entity as? ModelEntity {
                            model.physicsBody?.mode = .dynamic
                        }
                    }
                    // collected the refuse
                    stage.collectedRefuse()

                    // [Note] made below a comment at Ver.1.2, to fix a bug
                    //    // check the completion of stage clean
                    //    let freeRefuseNumber = Refuse.freeNumber(refuses: refuses)
                    //    assert(freeRefuseNumber >= 0)
                    //    if freeRefuseNumber == 0 {
                    //        stage.cleaned()
                    //        setCleaned()
                    //        showingCleanedView = true
                    //        cleanedImageView?.isHidden = false
                    //        startCleanedSound()
                    //    }
                }
            }

            // [Note] added at Ver.1.2
            // When all move-animations complete,
            // check the completion of the stage clean
            if animationPlaybackControllers.first(where: {
                !$0.isComplete
            }) == nil {
                let freeRefuseNumber = Refuse.freeNumber(refuses: refuses)
                assert(freeRefuseNumber >= 0)
                if freeRefuseNumber == 0 {
                    stage.cleaned()
                    setCleaned()
                    showingCleanedView = true
                    cleanedImageView?.isHidden = false
                    startCleanedSound()
                }
            }

            // remove completed controllers
            animationPlaybackControllers.removeAll(where: {
                $0.isComplete
            })
        }

        if showingCleanedView {
            showingCleanedViewTime += Float(deltaTime)
            if showingCleanedViewTime > AppConstant.showingCleanedMessageTime {
                showingCleanedView = false
                cleanedImageView?.isHidden = true
                startCleanedMusic()

                hideTrappedRefuses()
                recoverFish()
            }
        }

        #if DEBUG
        if devConfiguration.usingMovingCamera {
            if let movingCamera = movingCamera {
                movingCamera.update(deltaTime: deltaTime)
            }
        }
        #endif
    }

    private func setCleaned() {
        isCleaned = true
        state = .cleaned
    }

    private func recoverFish() {
        fishGroups.forEach { $0.recover() }
    }

    private func hideTrappedRefuses() {
        refuses.forEach { refuse in
            if refuse.state == .trapped {
                refuse.disappear()
            }
        }
    }

    private func startCleanedSound() {
        soundManager.stop(soundID: soundIDCollecting)   // stop stage music
        soundManager.play(soundID: SoundManager.cleanedSound)   // play default sound
    }

    private func startCleanedMusic() {
        soundManager.play(soundID: soundIDCollected)    // play stage music
    }

    private func prepareStage() {
        // instantiate the stage object
        let stageAssetIndex = SceneConstant.stageConstants[stageIndex].stageAssetIndex
        stage = Stage(constant: AssetConstant.stageAssets[stageAssetIndex])
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
            materialSetting: materialSetting ) {

            // adjust position and scale
            entity.position = SceneConstant.origin  // scene origin
            entity.scale = SceneConstant.scale      // scene scale
            // set the entity
            stage.setEntity(entity: entity)
            // add CollisionComponent and PhysicsBodyComponent
            stage.addPhysics()
            // setup shader
            if #available(iOS 15.0, *) {
                if let geoShaderName = SceneConstant.stageConstants[stageIndex].waveGeometryShader {
                    stage.prepareShader(surfaceEntityName: stage.constant.surfaceEntityName,
                                        geometryShaderName: geoShaderName)
                }
            }
            // place it in the AR world
            anchor.addChild(entity)
            stageEntity = entity
        }
        // prepare stage sounds
        prepareStageSounds()
    }

    private func prepareStageSounds() {
        let firstIndex = SceneConstant.stageConstants[stageIndex].firstSoundIndex
        let name1 = AssetConstant.musicAssets[firstIndex].soundFile
        let ext1 = AssetConstant.musicAssets[firstIndex].soundFileExt

        let secondIndex = SceneConstant.stageConstants[stageIndex].secondSoundIndex
        let name2 = AssetConstant.musicAssets[secondIndex].soundFile
        let ext2 = AssetConstant.musicAssets[secondIndex].soundFileExt

        // sounds that Sound Manager already has will be reused. (infinite loop)
        soundIDCollecting = soundManager.register(name: name1, ext: ext1, loop: -1)
        soundIDCollected = soundManager.register(name: name2, ext: ext2, loop: -1)
    }

    private func prepareBoat() {
        let boatAssetIndex = SceneConstant.stageConstants[stageIndex].boatAssetIndex
        let stageAssetIndex = SceneConstant.stageConstants[stageIndex].stageAssetIndex
        // instantiate the boat object
        let surfaceY = AssetConstant.stageAssets[stageAssetIndex].offset
                       - AssetConstant.stageAssets[stageAssetIndex].surface
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

    // MARK: - Prepare Fish

    private func prepareFishes() {
        // create fish-group objects
        SceneConstant.stageConstants[stageIndex].fishGroups.forEach { constant in
            let fishGroup = FishGroup(constant: constant)
            fishGroups.append(fishGroup)

            // prepare
            fishGroup.prepare()
            // set fish entities
            var entities: [Entity?] = []
            for _ in 0 ..< constant.fishNumber {
                entities.append(assetManager.loadAndCloneEntity(name: fishGroup.modelFileName))
            }
            fishGroup.setEntities(entities) // set entities and assign initial position

            // place them in the AR world (add as a stage's child)
            entities.forEach { entity in
                if let entity = entity {
                    stageEntity.addChild(entity)
                }
            }
        }
    }

    // MARK: - Prepare Refuse

    private func prepareRefuses() {
        // choose refuse for the stage
        let refuseAssetConstants: [RefuseAssetConstant] = selectRefuses()
        // create refuse objects
        for index in 0 ..< refuseAssetConstants.count {
            let refuseAssetConstant = refuseAssetConstants[index]

            // load and clone their entities
            if let entity = assetManager.loadAndCloneEntity(
                name: refuseAssetConstant.modelFile) {

                //  choose the route and calc the initial position on the route
                let posAndRouteIndex = calcRefuseInitialPosition(index: index)
                //  calc the moving rate, up and down
                let movingRate = 4.0 + Float.random(in: -2.0...2.0)
                // instantiate the refuse objects with initial position and angular velocity
                let refuse = Refuse(constant: refuseAssetConstant,
                                    entity: entity,
                                    position: posAndRouteIndex.position,
                                    velocity: SceneConstant.refuseRoutes[
                                        posAndRouteIndex.routeIndex].angularVelocity,
                                    movingPosYRange: SceneConstant.refuseRoutes[
                                        posAndRouteIndex.routeIndex].movingPosYRange,
                                    movingRate: movingRate)

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
        // choose the one axis, X or Z
        var axisX: Float = 0.0
        var axisZ: Float = 0.0
        if Bool.random() {
            axisX = 1.0
        } else {
            axisZ = 1.0
        }
        return simd_quatf(angle: 2.0 * Float.pi * Float.random(in: 0 ..< 1.0),
                   axis: SIMD3<Float>([ axisX, 0.0, axisZ ]))
    }

    private func selectRefuses() -> [RefuseAssetConstant] {
        #if DEBUG
        if devConfiguration.singleRefuse {
            return [AssetConstant.refuseAssets[0]]
        }
        #endif

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

    // MARK: - Collision

    struct Collision {
        let fishGroupIndex: Int
        let fishIndex: Int
        let refuseIndex: Int
    }

    func handleCollision() {
        // detect collisions
        if let collisions = detectCollision() {
            collisions.forEach { collision in
                // The collided refuses will be trapped by the fish.
                refuses[collision.refuseIndex].trapped()
                let refuseEntity = refuses[collision.refuseIndex].entity
                let refuseModelEntity = refuses[collision.refuseIndex].oneModelEntity
                refuseEntity.position = .zero
                refuseEntity.setParent(fishGroups[collision.fishGroupIndex].fishes[collision.fishIndex].entity)
                refuseModelEntity?.collision = nil      // not respond to taps any more
                refuseModelEntity?.physicsBody = nil
                refuseModelEntity?.physicsMotion = nil
                // The fish trapped the refuse.
                fishGroups[collision.fishGroupIndex].fishes[collision.fishIndex].trapped()
            }
            // handle fish state
            collisions.forEach { collision in
                let fish = fishGroups[collision.fishGroupIndex].fishes[collision.fishIndex]
                if fish.state == .weak {
                    // The fish was just weakened by this collision because weak fish can not collide.
                    let stageAssetIndex = SceneConstant.stageConstants[stageIndex].stageAssetIndex
                    let transform = Transform(scale: SIMD3<Float>([1.0, 1.0, 1.0]),
                                              rotation: simd_quatf(angle: fish.constant.weakAngleX,
                                                                   axis: SIMD3<Float>([1.0, 0.0, 0.0])),
                                              translation: SIMD3<Float>([
                            fish.entity?.position.x ?? 0.0,
                            -(AssetConstant.stageAssets[stageAssetIndex].radius    // sea bottom
                              - AssetConstant.stageAssets[stageAssetIndex].offset)
                              + fish.constant.volume.y, // ignoring the fish rotation
                            fish.entity?.position.z ?? 0.0]))
                    fish.entity?.move(to: transform, relativeTo: nil, duration: 10.0) // 10 sec
                }
            }
        }
    }

    /// Detect the collision between fish and refuses
    ///
    /// - Returns: nil: no collision, [Collision]: collisions
    ///
    /// When the number of free refuses is 0 or 1, nil will be returned, because the last refuse
    /// is not trapped by fish. It is for user to collect it to clean the stage.
    private func detectCollision() -> [Collision]? {
        guard Refuse.freeNumber(refuses: refuses) > 1 else { return nil }

        var collisions: [Collision] = []

        for fishGroupIndex in 0 ..< fishGroups.count {
            let fishGroup = fishGroups[fishGroupIndex]

            for refuseIndex in 0 ..< refuses.count {
                let refuse = refuses[refuseIndex]

                if refuse.state == .free {
                    if let collidingFishIndexes = fishGroup.collisions(with: refuse) {
                        collidingFishIndexes.forEach { fishIndex in
                            collisions.append(Collision(fishGroupIndex: fishGroupIndex,
                                                       fishIndex: fishIndex,
                                                       refuseIndex: refuseIndex))
                        }
                    }
                }
            }
        }

        return collisions.isEmpty ? nil : collisions
    }
}
