//
//  Stage.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/27.
//

import Foundation
import RealityKit
import Metal

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

    @available(iOS 15, *)
    func prepareShader(surfaceEntityName: String, geometryShaderName: String) {
        if let theEntity = entity?.findEntity(named: surfaceEntityName),
           let modelEntity = theEntity as? ModelEntity {
            debugLog("DEBUG: surface entity \(surfaceEntityName) was found.")

            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Error: could not create the default metal device.")
            }
            let library = device.makeDefaultLibrary()!
            let geometryModifier = CustomMaterial.GeometryModifier(named: geometryShaderName,
                                                                   in: library)
            guard let customMaterials =
                    try? modelEntity.model?.materials.map({ material -> CustomMaterial in
                try CustomMaterial(from: material, geometryModifier: geometryModifier)
            }) else {
                debugLog("DEBUG: failed to create surface geometry modifier.")
                return
            }
            modelEntity.model?.materials = customMaterials
        }
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

    #if DEBUG
    static func verify(names: [String]) -> Bool {
        var result = false
        for name in names {
            if let entity = try? Entity.load(named: name),
               let theEntity = entity.findEntity(named: AssetConstant.stageSurfaceModelName),
               let surfaceModel = theEntity as? ModelEntity,
               let domeEntity = surfaceModel.findEntity(named: AssetConstant.stageDomeModelName),
               let baseEntity = surfaceModel.findEntity(named: AssetConstant.stageBaseModelName) {
                if domeEntity as? ModelEntity != nil && baseEntity as? ModelEntity != nil {
                    result = true // all conditions are ok.
                }
            }
        }
        return result
    }
    #endif
}
