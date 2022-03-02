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
        // TODO: check the Entity's name to confirm refuse entities or fish entities.
        // TODO: check the Entity's state to prevent duplicated tap responses.
        debugPrint("DEBUG: Entity \(tappedEntity.name) was tapped.")

        if let modelEntity = tappedEntity as? ModelEntity {
            let transform = Transform(scale: SIMD3<Float>([1.0, 1.0, 1.0]),
                                      rotation: simd_quatf(angle: 0.0, axis: SIMD3<Float>([0.0, 1.0, 0.0])),
                                      translation: SIMD3<Float>([Float.random(in: -0.3...0.3) ,
                                                                 1.75,
                                                                 Float.random(in: -0.3...0.3)]))
            animationPlaybackControllers.append(modelEntity.move(to: transform,
                              relativeTo: stageEntity,
                              duration: 1))
        }
    }

    private func updateScene(deltaTime: Double) {
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

    private func prepareRefuses() {
        // TODO: remove after testing
        let mesh = MeshResource.generateSphere(radius: 0.075)
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let collisionShape = ShapeResource.generateSphere(radius: 0.075)
        let entity = ModelEntity(mesh: mesh,
                                 materials: [material],
                                 collisionShape: collisionShape,
                                 mass: 1.0)
        entity.physicsBody?.mode = .static
        stageEntity.addChild(entity)

        let entity2 = ModelEntity(mesh: mesh,
                                 materials: [material],
                                 collisionShape: collisionShape,
                                 mass: 1.0)
        entity2.physicsBody?.mode = .static
        stageEntity.addChild(entity2)

        // choose refuse (number of each type)
        // instantiate the refuse objects
        // load and clone their entities
        // add a collision shape each refuse
        // set position
        // place them in the AR world (add as a stage's child)
    }
}
