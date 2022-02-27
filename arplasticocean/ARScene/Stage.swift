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

    init(constant: StageAssetConstant) {
        self.constant = constant
    }

    func setEntity(entity: Entity) {
        self.entity = entity
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

class Fish {

}

class Refuse {

}
