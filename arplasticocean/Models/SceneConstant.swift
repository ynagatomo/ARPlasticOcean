//
//  SceneConstant.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/26.
//

import Foundation

struct AssetConstant {
    enum StageAssetIndex: Int {
        case daytime = 0, night, room
    }
    static let stageAssets: [StageAssetConstant] = [
        StageAssetConstant(name: "Daytime",
                   modelFile: "stage1.usdz",
                   topLevelModelEntityName: "StageSurface",
                   radius: 1.5,
                   surface: 0.2,
                   offset: 0.75,
                   edge: 6.0,
                   thickness: 0.1,
                   additionalCollisions: [StageCollisionConstant(shapeType: .sphere(radius: 0.36), // for a Rock
                               position: SIMD3<Float>([0.0, -(1.5 - 0.75), 0.0]))], // 1.5: radius, 0.75: offset
                   physicsMass: 1.0,
                   physicsFriction: 0.1,
                   physicsRestitution: 0.1)

    ]

    enum FishAssetIndex: Int {
        case umeiromodoki = 0
    }
    static let fishAssets: [FishAssetConstant] = [
        FishAssetConstant(name: "Umeiromodoki", modelFile: "umeiromodoki.usdz",
                  volume: SIMD3<Float>([0.2, 0.04, 0.03]))
    ]

    enum RefuseAssetIndex: Int {
        case bag = 0, bottle, net, debris1, debris2
    }
    static let refuseAssets: [RefuseAssetConstant] = [
        RefuseAssetConstant(name: "bag", modelFile: "bag.usdz", volumeRadius: 0.075),
        RefuseAssetConstant(name: "bottle", modelFile: "bottle.usdz", volumeRadius: 0.075),
        RefuseAssetConstant(name: "net", modelFile: "net.usdz", volumeRadius: 0.075),
        RefuseAssetConstant(name: "debris1", modelFile: "debris1.usdz", volumeRadius: 0.075),
        RefuseAssetConstant(name: "debris2", modelFile: "debris2.usdz", volumeRadius: 0.075)
    ]

    enum BoatAssetIndex: Int {
        case standard = 0
    }
    static let boatAssets: [BoatAssetConstant] = [
        BoatAssetConstant(name: "Utsuro", modelFile: "utsuro.usdz",
                          volume: SIMD3<Float>([0.0, 0.0, 0.0]),        // TODO: set appropriate value
                          gageVolume: SIMD3<Float>([0.0, 0.0, 0.0]),    // TODO: set collision shape
                          gagePosition: SIMD3<Float>([0.0, 0.0, 0.0]))  // TODO: set collision position
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
    static let refuseRestMargine: Int = 5
    static let refuseVolumeRadius: Float = 0.075 // [m]

    static let stageConstants: [StageConstant] = [
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,
                      secondSoundIndex: AssetConstant.MusicAssetIndex.nukumori.rawValue,
                      stageAssetIndex: AssetConstant.StageAssetIndex.daytime.rawValue,
                      fishProperties: [
                        FishPropertyConstant(assetIndex: AssetConstant.FishAssetIndex.umeiromodoki.rawValue,
                                     selectionType: .each, number: 6,
                                     probability: 1.0, threshold: 2)
                      ],
                      refuseProperties: [
                        RefusePropertyConstant(assetIndex: AssetConstant.RefuseAssetIndex.bag.rawValue, rate: 0.2),
                        RefusePropertyConstant(assetIndex: AssetConstant.RefuseAssetIndex.bottle.rawValue, rate: 0.2),
                        RefusePropertyConstant(assetIndex: AssetConstant.RefuseAssetIndex.net.rawValue, rate: 0.2),
                        RefusePropertyConstant(assetIndex: AssetConstant.RefuseAssetIndex.debris1.rawValue, rate: 0.2),
                        RefusePropertyConstant(assetIndex: AssetConstant.RefuseAssetIndex.debris2.rawValue, rate: 0.2)
                      ],
                      boatAssetIndex: 0,
                      fishNumber: 0)
    ]

    static var stageCount: Int { stageConstants.count }
}

struct StageAssetConstant {
    let name: String
    let modelFile: String   // USDZ fine name with ext.
    let topLevelModelEntityName: String     // top level Model Entity name
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
}

struct RefuseAssetConstant {
    let name: String
    let modelFile: String   // USDZ file name with ext.
    let volumeRadius: Float // radius [m]
}

struct BoatAssetConstant {
    let name: String
    let modelFile: String   // USDZ file name with ext.
    let volume: SIMD3<Float>    // (width, hight, depth) (x, y, z)
    let gageVolume: SIMD3<Float>    // (width, height, depth) (x, y, z)
    let gagePosition: SIMD3<Float>  // (x, y, z)
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
    let fishProperties: [FishPropertyConstant]
    let refuseProperties: [RefusePropertyConstant]
    let boatAssetIndex: Int

    let fishNumber: Int
}

struct FishPropertyConstant {
    enum SelectionType {
        case each, choice
    }
    let assetIndex: Int
    let selectionType: SelectionType
    let number: Int
    let probability: Float  // [0...1]
    let threshold: Int
}

struct RefusePropertyConstant {
    let assetIndex: Int
    let rate: Float
}
