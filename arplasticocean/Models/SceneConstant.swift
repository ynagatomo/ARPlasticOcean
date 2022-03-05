//
//  SceneConstant.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/26.
//

import Foundation

// swiftlint:disable file_length

struct AssetConstant {
    enum StageAssetIndex: Int {
        case room = 0, daytime, night
    }
    static let stageAssets: [StageAssetConstant] = [
        // Room Stage
        StageAssetConstant(name: "Room",
                   modelFile: "stage1.usdz",
                   modelTexture: "daytimeTexture",
                   topLevelModelEntityName: "StageSurface",
                   surfaceEntityName: "StageSurface",
                   domeShowing: false,
                   domeEntityName: "StageDome",
                   baseShowing: false,
                   baseEntityName: "StageBase",
                   textureName: "daytimeTexture",
                   radius: 1.5,
                   surface: 0.2,
                   offset: 0.75,
                   edge: 6.0,
                   thickness: 0.1,
                   additionalCollisions: [
                    StageCollisionConstant(shapeType: .sphere(radius: 0.36), // for a Rock
                    position: SIMD3<Float>([0.0, -(1.5 - 0.75), 0.0]))], // 1.5: radius, 0.75: offset
                   physicsMass: 1.0,
                   physicsFriction: 0.1,
                   physicsRestitution: 0.1),
        // Daytime Stage
        StageAssetConstant(name: "Daytime",
                   modelFile: "stage1.usdz",
                   modelTexture: "daytimeTexture",
                   topLevelModelEntityName: "StageSurface",
                   surfaceEntityName: "StageSurface",
                   domeShowing: true,
                   domeEntityName: "StageDome",
                   baseShowing: true,
                   baseEntityName: "StageBase",
                   textureName: "daytimeTexture",
                   radius: 1.5,
                   surface: 0.2,
                   offset: 0.75,
                   edge: 6.0,
                   thickness: 0.1,
                   additionalCollisions: [
                    StageCollisionConstant(shapeType: .sphere(radius: 0.36), // for a Rock
                    position: SIMD3<Float>([0.0, -(1.5 - 0.75), 0.0]))], // 1.5: radius, 0.75: offset
                   physicsMass: 1.0,
                   physicsFriction: 0.1,
                   physicsRestitution: 0.1)
    ]

    enum FishAssetIndex: Int {
        case umeiromodoki = 0
    }
    static let fishAssets: [FishAssetConstant] = [
        FishAssetConstant(name: "Umeiromodoki",
                          modelFile: "umeiromodoki.usdz",
                          volume: SIMD3<Float>([0.2, 0.04, 0.03]),
                          modelEntityName: "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1)
    ]

    enum RefuseAssetIndex: Int {
        case bag = 0, bottle, net, debris1, debris2
    }
    static let refuseAssets: [RefuseAssetConstant] = [
        RefuseAssetConstant(name: "bag",
                            modelFile: "bag.usdz",
                            modelEntityName: "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "bottle",
                            modelFile: "bottle.usdz",
                            modelEntityName: "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "net",
                            modelFile: "net.usdz",
                            modelEntityName: "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "debris1",
                            modelFile: "debris1.usdz",
                            modelEntityName: "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "debris2",
                            modelFile: "debris2.usdz",
                            modelEntityName: "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1)
    ]

    enum BoatAssetIndex: Int {
        case standard = 0
    }
    static let boatAssets: [BoatAssetConstant] = [
        BoatAssetConstant(name: "Utsuro", modelFile: "boat1.usdz",
                          topLevelModelEntityName: "Pole",
                          volume: SIMD3<Float>([0.6, 1.0, 0.6]),
                          thickness: 0.04,
                          position: SIMD3<Float>([0.0, 0.2, 0.0]),
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1)
    ]

    enum MusicAssetIndex: Int {
        case wave = 0, nukumori, hidamari, needbetter
    }
    static let musicAssets: [SoundAssetConstant] = [
        SoundAssetConstant(name: "Wave",
                    soundFile: "wave1",
                    soundFileExt: "m4a",
                    duration: 39),
        SoundAssetConstant(name: "Nukumori",
                    soundFile: "nukumori",
                    soundFileExt: "m4a",
                    duration: 2 * 60 + 40), // 2:40
        SoundAssetConstant(name: "Hidamari",
                    soundFile: "hidamari",
                    soundFileExt: "m4a",
                    duration: 2 * 60 + 3), // 2:03
        SoundAssetConstant(name: "Need-better",
                    soundFile: "needbetter",
                    soundFileExt: "m4a",
                    duration: 63) // 1:03
    ]

    enum SoundEffectAssetIndex: Int {
        case cleanup = 0, medal, collect
    }
    static let soundEffectAssets: [SoundAssetConstant] = [
        SoundAssetConstant(name: "Cleanup",
                    soundFile: "cleanup1",
                    soundFileExt: "mp3",
                    duration: 3),
        SoundAssetConstant(name: "Medal",
                    soundFile: "medal1",
                    soundFileExt: "mp3",
                    duration: 2),
        SoundAssetConstant(name: "Collect",
                    soundFile: "collect1",
                    soundFileExt: "mp3",
                    duration: 1)
    ]
}

struct SceneConstant {
    static let origin = SIMD3<Float>([0.0, 0.0, -0.75])
    static let scale = SIMD3<Float>([1.0, 1.0, 1.0])
    static let refuseNumberMultiplier: Float = 2.0
    // static let refuseRestMargine: Int = 5
    static let refuseVolumeRadius: Float = 0.075 // [m]
    static let gazeXZ: Float = 0.15 // [m] position range +/-
    static let collectingYPosition: Float = 1.6 // [m]

    // The refuse routes are common among the all stages.
    static let refuseRoutes: [RefuseRouteConstant] = [
        RefuseRouteConstant(origin: SIMD3<Float>([0.0, -0.225, 0.0]), // Route 1
                            radius: 1.0,
                            angularVelocity: 2.0 * Float.pi / 40.0, // [rad/sec]
                            initPosYRange: 0.15,
                            initPosXZRange: 0.2,
                            movingPosYRange: 0.15),
        RefuseRouteConstant(origin: SIMD3<Float>([0.0, 0.225, 0.0]), // Route 2
                            radius: 1.2,
                            angularVelocity: -2.0 * Float.pi / 50.0, // [rad/sec]
                            initPosYRange: 0.15,
                            initPosXZRange: 0.2,
                            movingPosYRange: 0.15)
    ]

    static let fishProperties: [FishPropertyConstant] = [
        // #0 : Umeiromodoki
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.umeiromodoki.rawValue,
                             selectProbability: 1.0,
                             trapCapacity: 2,
                             damageThreshold: 4)
    ]

    static let fishRoutes: [FishRouteConstant] = [
        // #0 : route for small fish
        FishRouteConstant(radiusX: 0.9, radiusZ: 0.6, radiusY: 0.3,
                          origin: SIMD3<Float>([0.3, 0.0, 0.0]),
                          offsetTheta: 0.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 1.0,
                         fishInitPosition: SIMD3<Float>([
                                // Y: (bottom + collision box/2) + (fish hight/2 + margin)
                                0.0, (-0.75 + 0.05) + (0.08 / 2.0 + 0.01), 0.0
                         ])),
        // #1 : route for middle fish
        FishRouteConstant(radiusX: 1.0, radiusZ: 1.0, radiusY: 0.3,
                          origin: SIMD3<Float>([0.3, 0.0, 0.0]),
                          offsetTheta: Float.pi / 2.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 1.0,
                          fishInitPosition: SIMD3<Float>([
                                // Y: (bottom + collision box/2) + (fish hight/2 + margin)
                                0.0, (-0.75 + 0.05) + (0.08 / 2.0 + 0.01), 0.0
                          ])),
        // #2 : route for large fish
        FishRouteConstant(radiusX: 2.0, radiusZ: 1.0, radiusY: 0.3,
                          origin: SIMD3<Float>([0.0, 0.0, 1.0]),
                          offsetTheta: 0.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 1.0,
                          fishInitPosition: SIMD3<Float>([
                                -2.0, // out of Dome
                                 // Y: bottom / 2.0
                                 -0.75 / 2.0,
                                 -2.0   // out of Dome
                          ])),
        // #3 : route for large fish (no rotation)
        FishRouteConstant(radiusX: 2.0, radiusZ: 1.0, radiusY: 0.3,
                          origin: SIMD3<Float>([0.0, 0.0, 1.0]),
                          offsetTheta: 0.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 0.0,
                          fishInitPosition: SIMD3<Float>([
                                -2.0, // out of Dome
                                 // Y: bottom / 2.0
                                 -0.75 / 2.0,
                                 -2.0   // out of Dome
                          ]))
    ]

    static let stageConstants: [StageConstant] = [
        // Room Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,
                      secondSoundIndex: AssetConstant.MusicAssetIndex.needbetter.rawValue,
                      stageAssetIndex: AssetConstant.StageAssetIndex.room.rawValue,
                      refuseProperties: [
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.bag.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.bottle.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.net.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.debris1.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.debris2.rawValue)
                      ],
                      boatAssetIndex: 0,
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [0],   // #0: Umeiromodoki
                            fishNumber: 6,              // number of fish
                            fishRouteIndex: 0,          // #0: route for small fish
                            fishVelocity: Float.pi * -1.5 / 10.0,  // [radian/sec]
                            routeRotationVelocity: Float.pi * 2.0 / 10.0, // [radian/sec]
                            routeRotationOffset: 0.0,    // [radian]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [0],   // #0: Umeiromodoki
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 10.0,  // [radian/sec]
                            routeRotationVelocity: Float.pi * 2.0 / 14.0, // [radian/sec]
                            routeRotationOffset: 0.0,    // [radian]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [0],   // #0: Umeiromodoki
                            fishNumber: 1,              // number of fish
                            fishRouteIndex: 2,          // #2: route for large fish
                            fishVelocity: Float.pi * 1.0 / 10.0,  // [radian/sec]
                            routeRotationVelocity: Float.pi * 2.0 / 20.0, // [radian/sec]
                            routeRotationOffset: 0.0,    // [radian]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // Daytime Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,
                      secondSoundIndex: AssetConstant.MusicAssetIndex.nukumori.rawValue,
                      stageAssetIndex: AssetConstant.StageAssetIndex.daytime.rawValue,
                      refuseProperties: [
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.bag.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.bottle.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.net.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.debris1.rawValue),
                        RefusePropertyConstant(assetIndex:
                                    AssetConstant.RefuseAssetIndex.debris2.rawValue)
                      ],
                      boatAssetIndex: 0,
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [0],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 10.0,
                            routeRotationVelocity: Float.pi * 2.0 / 10.0, // [radian/sec]
                            routeRotationOffset: 0.0,    // [radian]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [0],   // #0: Umeiromodoki
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 10.0,  // [radian/sec]
                            routeRotationVelocity: Float.pi * 2.0 / 14.0, // [radian/sec]
                            routeRotationOffset: 0.0,    // [radian]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [0],   // #0: Umeiromodoki
                            fishNumber: 1,              // number of fish
                            fishRouteIndex: 3,          // #3: route for large fish
                            fishVelocity: Float.pi * 1.0 / 10.0,  // [radian/sec]
                            routeRotationVelocity: Float.pi * 2.0 / 20.0, // [radian/sec]
                            routeRotationOffset: 0.0,    // [radian]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ])
    ]

    static var stageCount: Int { stageConstants.count }
}

struct StageAssetConstant {
    let name: String
    let modelFile: String   // USDZ fine name with ext.
    let modelTexture: String    // texture image name in the USDZ file
    let topLevelModelEntityName: String     // top level Model Entity name
    let surfaceEntityName: String
    let domeShowing: Bool   // showing?
    let domeEntityName: String
    let baseShowing: Bool   // showing?
    let baseEntityName: String
    let textureName: String? // texture for dome, surface, and base
    // stage geometry
    let radius: Float   // radius of the Stage Dome [m]
    let surface: Float  // distance to the sea surface from the origin [m]
    let offset: Float   // offset to the center of the sea from the origin [m]
    let edge: Float     // length of the edge of the Stage Box [m]
    let thickness: Float    // thickness of the edge of the Stage Box [m]
    let additionalCollisions: [StageCollisionConstant] // additional collisions (box or sphere)
    let physicsMass: Float          // mass [kg]
    let physicsFriction: Float      // [0, infinity)
    let physicsRestitution: Float   // [0, 1]
}

struct StageCollisionConstant {
    enum ShapeType {
        case box(width: Float, height: Float, depth: Float) // [m], (x, y, z) in right-hand system
        case sphere(radius: Float) // [m]
    }
    let shapeType: ShapeType
    let position: SIMD3<Float>
}

struct FishAssetConstant {
    let name: String
    let modelFile: String   // USDZ file name with ext.
    let volume: SIMD3<Float>    // (width, hight, depth) (x, y, z)
    let modelEntityName: String // root ModelEntity name
    let physicsMass: Float          // mass [kg]
    let physicsFriction: Float      // [0, infinity)
    let physicsRestitution: Float   // [0, 1]
}

struct RefuseAssetConstant {
    let name: String
    let modelFile: String   // USDZ file name with ext.
    let modelEntityName: String // one of the ModelEntity names
    let volumeRadius: Float // radius [m]
    let physicsMass: Float          // mass [kg]
    let physicsFriction: Float      // [0, infinity)
    let physicsRestitution: Float   // [0, 1]
}

struct BoatAssetConstant {
    let name: String
    let modelFile: String   // USDZ file name with ext.
    let topLevelModelEntityName: String     // top level Model Entity name
    let volume: SIMD3<Float>    // gage volume (width, hight, depth) (x, y, z)
    let thickness: Float        // gage collision shape thickness [m]
    let position: SIMD3<Float>  // gage origin (bottom position) (x, y, z)
    let physicsMass: Float          // mass [kg]
    let physicsFriction: Float      // [0, infinity)
    let physicsRestitution: Float   // [0, 1]
}

struct SoundAssetConstant {
    let name: String
    let soundFile: String
    let soundFileExt: String
    let duration: Int           // [sec]
}

struct StageConstant {
    // sound
    let firstSoundIndex: Int
    let secondSoundIndex: Int

    // assets
    let stageAssetIndex: Int
    let refuseProperties: [RefusePropertyConstant]
    let boatAssetIndex: Int

    let refuseNumbers: [Int]   // the number of refuses in each route
    let fishGroups: [FishGroupConstant]
}

struct RefuseRouteConstant {
    let origin: SIMD3<Float>
    let radius: Float   // [m]
    let angularVelocity: Float  // [rad/sec] on X-Z plane
    let initPosYRange: Float    // [m] +/- on Y axis
    let initPosXZRange: Float   // [m] +/- on X-Z plane
    let movingPosYRange: Float  // [m] +/- on Y axis
}

struct FishRouteConstant {
    let radiusX: Float  // [m] radius on X axis
    let radiusZ: Float  // [m] radius on Z axis
    let radiusY: Float  // [m] radius on Y axis
    let origin: SIMD3<Float>  // [m] origin
    let offsetTheta: Float  // [radian] [0...2PI] shift the phase
    let cycleRateY: Float   // cycle modifier for moving Y axis
    let cycleDivRateXZ: Float // cycle division modifier on XZ plane
    let cycleMulRateXZ: Float // cycle multiply modifier on XZ plane {0.0 or 1.0}
    let fishInitPosition: SIMD3<Float>  // fish init position for all fish
}

struct FishGroupConstant {
    let fishPropertyIndexes: [Int]  // will be selected one kind of fish
    let fishNumber: Int             // number of fish
    let fishRouteIndex: Int         // route index
    let fishVelocity: Float         // velocity and direction [radian/sec]
    let routeRotationVelocity: Float // velocity of route rotation [radian/sec]
    let routeRotationOffset: Float  // [radian]
    let fishAngleGap: (min: Float, max: Float)  // [radian] gap range on the route
    let fishDiffMax: Float  // [m] fish position difference max (x, y, z)
}

struct FishPropertyConstant {
//    enum SelectionType {
//        case each, choice
//    }
    let assetIndex: Int
//    let selectionType: SelectionType
//    let number: Int
    let selectProbability: Float  // [0...1]
    let trapCapacity: Int           // [0...]
    let damageThreshold: Int       // [0...]
}

struct RefusePropertyConstant {
    let assetIndex: Int
}
