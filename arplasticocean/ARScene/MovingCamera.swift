//
//  MovingCamera.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/11.
//

#if DEBUG
import Foundation
import RealityKit

class MovingCameraConstant {
    static let route1: [MovingCamera.Point] = [
        // init position: 1.0, 1.75, 0.0
        MovingCamera.Point(position: SIMD3<Float>([0.0, 2.0, 2.0]),
                           rotation: simd_quatf(angle: -Float.pi / 4.0,
                                                axis: [1.0, 0.0, 0.0]),
                           duration: 5.0),
        MovingCamera.Point(position: SIMD3<Float>([0.0, -0.3, 1.0]),
                           rotation: simd_quatf(angle: 0.0,
                                                axis: [1.0, 0.0, 0.0]),
                           duration: 2.0),
        MovingCamera.Point(position: SIMD3<Float>([0.0, -0.3, 1.0]),
                           rotation: simd_quatf(angle: -Float.pi / 4.0,
                                                axis: [0.0, 1.0, 0.0]),
                           duration: 4.0),
        MovingCamera.Point(position: SIMD3<Float>([0.0, -0.3, 1.0]),
                           rotation: simd_quatf(angle: Float.pi / 4.0,
                                                axis: [0.0, 1.0, 0.0]),
                           duration: 2.0),
        MovingCamera.Point(position: SIMD3<Float>([0.0, -0.3, 1.0]),
                           rotation: simd_quatf(angle: 0.0,
                                                axis: [0.0, 1.0, 0.0]),
                           duration: 5.0)
    ]
}

class MovingCamera {
    private let cameraEntity: PerspectiveCamera
    private var time: Float = 0.0
    private var pointAIndex = 0
    private var pointBIndex = 1
    private let points: [Point] = MovingCameraConstant.route1

    struct Point {
        let position: SIMD3<Float>
        let rotation: simd_quatf
        let duration: Float
    }

    init(camera: PerspectiveCamera) {
        cameraEntity = camera
    }

    func update(deltaTime: Double) {
        time += Float(deltaTime)   // [sec]

        if time > points[pointAIndex].duration {
            time -= points[pointAIndex].duration
            pointAIndex = pointBIndex
            pointBIndex += 1
            if pointBIndex >= points.count {
                pointBIndex = 0
            }
        }

        let (position, rotation) = lerp()
        cameraEntity.position = position + SceneConstant.origin
        cameraEntity.orientation = rotation
    }

    // Linear Interpolate from pointA to pointB
    private func lerp() -> (SIMD3<Float>, simd_quatf) {
        let rate = time / points[pointAIndex].duration
        assert(rate >= 0.0 && rate <= 1.0)

        let position = points[pointAIndex].position * (1.0 - rate)
                     + points[pointBIndex].position * rate
         let rotation = simd_slerp(points[pointAIndex].rotation,
                   points[pointBIndex].rotation,
                   rate)

        return (position, rotation)
    }
}
#endif
