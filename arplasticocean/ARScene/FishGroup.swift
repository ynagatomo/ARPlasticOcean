//
//  FishGroup.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/18.
//

import RealityKit

class FishGroup {
    let fishGroupConstant: FishGroupConstant
    let fishRouteConstant: FishRouteConstant
    var fishAssetConstant: FishAssetConstant!
    var fishes: [Fish] = []

    var modelFileName: String {
        fishAssetConstant.modelFile
    }

    init(constant: FishGroupConstant) {
        self.fishGroupConstant = constant
        fishRouteConstant = SceneConstant.fishRoutes[constant.fishRouteIndex]
    }

    func prepare() {
        // choose one fish-property-constant index
        let fishPropertyConstantIndex = chooseFish()
        assert(fishPropertyConstantIndex < SceneConstant.fishProperties.count)
        let fishPropertyConstant = SceneConstant.fishProperties[fishPropertyConstantIndex]
        let fishAssetIndex = fishPropertyConstant.assetIndex
        fishAssetConstant = AssetConstant.fishAssets[fishAssetIndex]

        // create Fish objects
        var angle: Float = 0.0
        for _ in 0 ..< fishGroupConstant.fishNumber {
            let fish = Fish(constant: fishAssetConstant,
                            property: fishPropertyConstant,
                            angleOffset: angle,
                            positionDiff: fishGroupConstant.fishDiffMax)
            fishes.append( fish )
            let angleDiff = Float.random(in: fishGroupConstant.fishAngleGap.min
                                         ... fishGroupConstant.fishAngleGap.max)
            if fishGroupConstant.fishVelocity >= 0.0 { // + direction (Y axis) rotation
                angle += angleDiff
            } else { // - direction (Y axis) rotation
                angle -= angleDiff
            }
        }
    }

    func setEntities(_ entities: [Entity?]) {
        assert(entities.count == fishes.count)
        for index in 0 ..< entities.count {
            fishes[index].setEntity(entities[index])
            // set initial target position
            let result = calcFishPosition(fishIndex: index, deltaTime: 0.0)
            fishes[index].setInitialPosition(position: result.position, angle: result.angle)
        }
    }

    func startAnimation() {
        fishes.forEach { $0.startAnimation() }
    }

    func recover() {
        fishes.forEach { $0.recover() }
    }

    func collisions(with refuse: Refuse) -> [Int]? {
        var fishIndexes: [Int] = []

        for fishIndex in 0 ..< fishes.count {
            if fishes[fishIndex].isColliding(with: refuse) {
                fishIndexes.append(fishIndex)
            }
        }

        return fishIndexes.isEmpty ? nil : fishIndexes
    }

    func update(deltaTime: Double) {
        for index in 0 ..< fishes.count {
            // update each target positions
            let result = calcFishPosition(fishIndex: index, deltaTime: deltaTime)
            fishes[index].targetPosition = result.position
            fishes[index].fishAngle = result.angle
            fishes[index].update(deltaTime: Float(deltaTime)) // deltaTime: Float(deltaTime))
        }
    }

    private func calcFishPosition(fishIndex: Int, deltaTime: Double)
    -> (position: SIMD3<Float>, angle: Float) {
        let time = fishes[fishIndex].time + Float(deltaTime)
        fishes[fishIndex].time = time
        let angleOffset = fishes[fishIndex].angleOffset

        // on an ellipse
        let angle = fishGroupConstant.fishVelocity * time + angleOffset
        let (position: posXZ, angle: fishAngle) = calcPositionOnEllipse(radiusX: fishRouteConstant.radiusX,
                                           radiusZ: fishRouteConstant.radiusZ,
                                           inAngle: angle)
        // sin
        let angle2 = fishGroupConstant.fishVelocity * time / fishRouteConstant.cycleRateY
                    + angleOffset
        let yPos = fishRouteConstant.radiusY * sinf(angle2)
                    + fishRouteConstant.origin.y

        // rotate on the X-Z plane
        let angle3 = angle * fishRouteConstant.cycleMulRateXZ
                           / fishRouteConstant.cycleDivRateXZ
        let xPos2 = posXZ.x * cosf(-angle3) - posXZ.z * sinf(-angle3)
        let zPos2 = posXZ.x * sinf(-angle3) + posXZ.z * cosf(-angle3)
        let resultAngle = fishAngle + angle3

        // shift position (x, y, z) slightly
        let position = SIMD3<Float>([xPos2, yPos, zPos2]) + fishes[fishIndex].positionDiff
        return (position: position, angle: resultAngle)
    }

    private func calcPositionOnEllipse(radiusX: Float, radiusZ: Float, inAngle: Float)
    -> (position: (x: Float, z: Float), angle: Float) {
        var angle = inAngle
        // normalize the angle to (-2PI,2PI) (not include -2PI, 2PI)
        if inAngle >= Float.pi * 2.0 || inAngle <= -Float.pi * 2.0 {
            angle = inAngle.truncatingRemainder(dividingBy: Float.pi * 2.0)
        }
        assert(angle > -Float.pi * 2.0 && angle < Float.pi * 2.0) // not equal to -2PI or 2PI

        let positionX = radiusX * cosf(angle)
        let positionZ = radiusZ * sinf(angle)

        // an inclination of tangent
        var resultAngle: Float = 0.0
        if abs(positionZ) > 0.0001 { // > 0.1 mm
            let inclination = -(radiusZ * radiusZ / radiusX / radiusX) * positionX / positionZ
            resultAngle = atanf(inclination)
        } else if positionZ >= 0.0 {
            resultAngle = -Float.pi / 2.0
        } else {
            resultAngle = Float.pi / 2.0
        }

        // +PI : modify the result to be continuous
        //       angle: 0 ... 2PI,  result: -(1/2)PI ... (3/4)PI
        if angle >= Float.pi {
            resultAngle += Float.pi
        } else if angle <= -Float.pi {
            resultAngle -= Float.pi
        }

        // +PI : modify to rotate PI for fish's up-side-down
        resultAngle += Float.pi

        // inverse y-position to fit the Z-axis
        return (position: (x: positionX, z: -positionZ), angle: resultAngle)
    }

    /// Choose one fish from the candidates
    /// - Returns: chosen index of FishPropertyConstant
    ///
    /// It is chosen based on the probability of each fish
    /// When all fish are not chosen, index 0 will be chosen by default.
    private func chooseFish() -> Int {
        var chosenIndex: Int = 0    // default chosen index = 0
        for index in fishGroupConstant.fishPropertyIndexes {
            assert(index < SceneConstant.fishProperties.count)
            let fishPropertyConstant = SceneConstant.fishProperties[index]
            if fishPropertyConstant.selectProbability > Float.random(in: 0 ..< 1.0) {
                chosenIndex = index
                break
            }
        }
        return chosenIndex
    }
}
