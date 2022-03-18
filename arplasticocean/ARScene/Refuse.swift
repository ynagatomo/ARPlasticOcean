//
//  Refuse.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/18.
//

import RealityKit

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
            // debugLog("DEBUG: Refuse: found a model-entity.")
            if let modelEntity = theEntity as? ModelEntity {
                // debugLog("DEBUG: casted the Entity to a ModelEntity safely.")
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

    #if DEBUG
    static func verify(names: [String]) -> Bool {
        var result = false
        for name in names {
            if let entity = try? Entity.load(named: name),
               let theEntity = entity.findEntity(named: AssetConstant.refuseModelName) {
                if theEntity as? ModelEntity != nil {
                    result = true // all conditions are ok.
                }
            }
        }
        return result
    }
    #endif
}
