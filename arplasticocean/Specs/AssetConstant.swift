//
//  AssetConstant.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/18.
//

import Foundation

// swiftlint:disable type_body_length
struct AssetConstant {
    enum StageAssetIndex: Int {
        case room = 0, daytime, night, evening
        case daytimenpole, nightnpole, roomnpole
    }

    static let stageSurfaceModelName = "StageSurface"
    static let stageDomeModelName = "StageDome"
    static let stageBaseModelName = "StageBase"
    static let boatModelName = "Pole"
    static let fishModelName = "Bone"
    static let refuseModelName = "Refuse"

    static let stageAssets: [StageAssetConstant] = [
        // Room Stage
        StageAssetConstant(name: "Room",
                   modelFile: "stage1.usdz",
                   modelTexture: "daytimeTexture",
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: false,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: false,
                   baseEntityName: stageBaseModelName, // "StageBase",
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
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: true,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: true,
                   baseEntityName: stageBaseModelName, // "StageBase",
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
        // Night Stage
        StageAssetConstant(name: "Night",
                   modelFile: "stage1.usdz",
                   modelTexture: "daytimeTexture", // texture image in the USDZ file
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: true,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: true,
                   baseEntityName: stageBaseModelName, // "StageBase",
                   textureName: "nightTexture", // texture image used for this stage
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
        // Evening Stage
        StageAssetConstant(name: "Evening",
                   modelFile: "stage1.usdz",
                   modelTexture: "daytimeTexture", // texture image in the USDZ file
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: true,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: true,
                   baseEntityName: stageBaseModelName, // "StageBase",
                   textureName: "eveningTexture", // texture image used for this stage
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
        // Daytime N Pole Stage
        StageAssetConstant(name: "Daytime North Pole",
                   modelFile: "stage2.usdz",
                   modelTexture: "daytimeNPoleTexture", // texture image in the USDZ file
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: true,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: true,
                   baseEntityName: stageBaseModelName, // "StageBase",
                   textureName: "daytimeNPoleTexture", // texture image used for this stage
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
        // Night N Pole Stage
        StageAssetConstant(name: "Night North Pole",
                   modelFile: "stage2.usdz",
                   modelTexture: "daytimeNPoleTexture", // texture image in the USDZ file
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: true,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: true,
                   baseEntityName: stageBaseModelName, // "StageBase",
                   textureName: "nightNPoleTexture", // texture image used for this stage
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
        // Room N Pole Stage
        StageAssetConstant(name: "Room North Pole",
                   modelFile: "stage2.usdz",
                   modelTexture: "daytimeNPoleTexture", // texture image in the USDZ file
                   topLevelModelEntityName: stageSurfaceModelName, // "StageSurface",
                   surfaceEntityName: stageSurfaceModelName, // "StageSurface",
                   domeShowing: false,
                   domeEntityName: stageDomeModelName, // "StageDome",
                   baseShowing: false,
                   baseEntityName: stageBaseModelName, // "StageBase",
                   textureName: "daytimeNPoleTexture", // texture image used for this stage
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
        case umeiromodoki = 0, bonito, ocellatus, turtle, dolphin
        case mackerel, salmon, narwhal, beluga, graywhale
    }
    static let fishAssets: [FishAssetConstant] = [
        FishAssetConstant(name: "Umeiromodoki",
                          modelFile: "umeiromodoki.usdz",
                          volume: SIMD3<Float>([0.2, 0.04, 0.03]),
                          collisionRadius: 0.02,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: Float.pi / 2.0),
        FishAssetConstant(name: "Bonito",
                          modelFile: "bonito.usdz",
                          volume: SIMD3<Float>([0.3, 0.1, 0.06]),
                          collisionRadius: 0.05,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: Float.pi / 2.0),
        FishAssetConstant(name: "Ocellatus",
                          modelFile: "ocellatus.usdz",
                          volume: SIMD3<Float>([0.37, 0.06, 0.5]),
                          collisionRadius: 0.1,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: 0.0), // not rotate
        FishAssetConstant(name: "Turtle",
                          modelFile: "turtle.usdz",
                          volume: SIMD3<Float>([0.4, 0.128, 0.461]),
                          collisionRadius: 0.1,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: 0.0), // not rotate
        FishAssetConstant(name: "Dolphin",
                          modelFile: "dolphin.usdz",
                          volume: SIMD3<Float>([0.48, 0.151, 0.195]),
                          collisionRadius: 0.1,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: Float.pi / 2.0),
        FishAssetConstant(name: "Mackerel", // Saba
                          modelFile: "mackerel.usdz",
                          volume: SIMD3<Float>([0.241, 0.0593, 0.0457]),
                          collisionRadius: 0.025,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: Float.pi / 2.0),
        FishAssetConstant(name: "Salmon",
                          modelFile: "salmon.usdz",
                          volume: SIMD3<Float>([0.357, 0.0766, 0.091]),
                          collisionRadius: 0.05,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: Float.pi / 2.0),
        FishAssetConstant(name: "Narwhal", // Ikkaku
                          modelFile: "narwhal.usdz",
                          volume: SIMD3<Float>([0.58, 0.129, 0.195]),
                          collisionRadius: 0.06,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: 0.0),
        FishAssetConstant(name: "Beluga",
                          modelFile: "beluga.usdz",
                          volume: SIMD3<Float>([0.457, 0.15, 0.195]),
                          collisionRadius: 0.1,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: 0.0),
        FishAssetConstant(name: "Gray Whale",
                          modelFile: "graywhale.usdz",
                          volume: SIMD3<Float>([0.747, 0.175, 0.185]),
                          collisionRadius: 0.1,
                          modelEntityName: fishModelName, // "Bone",
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1,
                          weakAngleX: 0.0)
    ]

    enum RefuseAssetIndex: Int {
        case bag = 0, bottle, net, debris1, debris2, dolphin
    }
    static let refuseAssets: [RefuseAssetConstant] = [
        RefuseAssetConstant(name: "bag",
                            modelFile: "bag.usdz",
                            modelEntityName: refuseModelName, // "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "bottle",
                            modelFile: "bottle.usdz",
                            modelEntityName: refuseModelName, // "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "net",
                            modelFile: "net.usdz",
                            modelEntityName: refuseModelName, // "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "debris1",
                            modelFile: "debris1.usdz",
                            modelEntityName: refuseModelName, // "Refuse",
                            volumeRadius: 0.075,
                            physicsMass: 1.0,
                            physicsFriction: 0.1,
                            physicsRestitution: 0.1),
        RefuseAssetConstant(name: "debris2",
                            modelFile: "debris2.usdz",
                            modelEntityName: refuseModelName, // "Refuse",
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
                          topLevelModelEntityName: boatModelName, // "Pole",
                          volume: SIMD3<Float>([0.6, 1.0, 0.6]),
                          thickness: 0.04,
                          position: SIMD3<Float>([0.0, 0.2, 0.0]),
                          physicsMass: 1.0,
                          physicsFriction: 0.1,
                          physicsRestitution: 0.1)
    ]

    enum MusicAssetIndex: Int {
        case wave = 0, nukumori, hidamari, needbetter, aomuke
        case inthewater, uminomori, miyako
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
                    duration: 63), // 1:03
        SoundAssetConstant(name: "Aomuke",
                    soundFile: "aomuke",
                    soundFileExt: "m4a",
                    duration: 2 * 60 + 6), // 2:06
        SoundAssetConstant(name: "In the water",
                    soundFile: "inthewater",
                    soundFileExt: "m4a",
                    duration: 2 * 60 + 29), // 2:29
        SoundAssetConstant(name: "Umi no mori",
                    soundFile: "uminomori",
                    soundFileExt: "m4a",
                    duration: 1 * 60 + 48), // 1:48
        SoundAssetConstant(name: "Ushinawareta miyako",
                    soundFile: "ushinawareta",
                    soundFileExt: "m4a",
                    duration: 1 * 60 + 23) // 1:23
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
