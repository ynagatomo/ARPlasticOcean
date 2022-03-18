//
//  AssetConstantTypes.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/18.
//

import Foundation

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
    let collisionRadius: Float  // radius of collision sphere [m]
    let modelEntityName: String // root ModelEntity name
    let physicsMass: Float          // mass [kg]
    let physicsFriction: Float      // [0, infinity)
    let physicsRestitution: Float   // [0, 1]
    let weakAngleX: Float    // rotation angle (x axis) in weak state [radian]
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

    // shader
    let waveGeometryShader: String?

    // characters
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
}

struct FishGroupConstant {
    let fishPropertyIndexes: [Int]  // will be selected one kind of fish
    let fishNumber: Int             // number of fish
    let fishRouteIndex: Int         // route index
    let fishVelocity: Float         // velocity and direction [radian/sec]
    let fishAngleGap: (min: Float, max: Float)  // [radian] gap range on the route
    let fishDiffMax: Float  // [m] fish position difference max (x, y, z)
}

struct FishPropertyConstant {
    let assetIndex: Int
    let selectProbability: Float  // [0...1]
    let trapCapacity: Int           // [0...]
}

struct RefusePropertyConstant {
    let assetIndex: Int
}
