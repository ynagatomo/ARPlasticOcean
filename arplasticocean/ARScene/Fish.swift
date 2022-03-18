//
//  Fish.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/18.
//

import RealityKit

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
            // debugLog("DEBUG: found fish ModelEntity.")
            modelEntity = model
        }
    }

    func startAnimation() {
        guard let entity = entity else { return }

        if let animation = entity.availableAnimations.first {
            entity.playAnimation(animation.repeat())
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

    #if DEBUG
    static func verify(names: [String]) -> Bool {
        for name in names {
            if let entity = try? Entity.load(named: name),
               let theEntity = entity.findEntity(named: AssetConstant.fishModelName) {
                if theEntity as? ModelEntity == nil || entity.availableAnimations.isEmpty {
                    debugLog("DEBUG: Fish Verify: failed with \(name).")
                    return false
                }
            } else {
                debugLog("DEBUG: Fish Verify: failed with \(name). Could not load the Entity or ModelEntity.")
                return false
            }

        }
        return true  // all test were passed.
    }
    #endif
}
