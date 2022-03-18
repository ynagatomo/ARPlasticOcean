//
//  SceneConstant.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/26.
//

import Foundation

// swiftlint:disable file_length

// swiftlint:disable type_body_length
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
                             trapCapacity: 2),
        // #1 : Bonito (Katsuo)
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.bonito.rawValue,
                             selectProbability: 1.0,
                             trapCapacity: 2),
        // #2 : Ocellatus (Madaratobiei)
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.ocellatus.rawValue,
                             selectProbability: 0.5,
                             trapCapacity: 3),
        // #3 : Turtle
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.turtle.rawValue,
                             selectProbability: 0.5,
                             trapCapacity: 3),
        // #4 : Dolphin
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.dolphin.rawValue,
                             selectProbability: 1.0,
                             trapCapacity: 3),
        // #5 : Mackerel (Saba)
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.mackerel.rawValue,
                             selectProbability: 1.0,
                             trapCapacity: 2),
        // #6 : Salmon
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.salmon.rawValue,
                             selectProbability: 1.0,
                             trapCapacity: 2),
        // #7 : Narwhal (Ikkaku)
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.narwhal.rawValue,
                             selectProbability: 0.5,
                             trapCapacity: 3),
        // #8 : Beluga
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.beluga.rawValue,
                             selectProbability: 0.5,
                             trapCapacity: 3),
        // #9 : Gray Whale
        FishPropertyConstant(assetIndex:
                             AssetConstant.FishAssetIndex.graywhale.rawValue,
                             selectProbability: 1.0,
                             trapCapacity: 3)
    ]

    static let fishRoutes: [FishRouteConstant] = [
        // #0 : route for small fish
        FishRouteConstant(radiusX: 0.9, radiusZ: 0.6, radiusY: 0.3,
                          origin: SIMD3<Float>([0.3, 0.0, 0.0]),
                          offsetTheta: 0.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 1.0
                         ),
        // #1 : route for middle fish
        FishRouteConstant(radiusX: 1.0, radiusZ: 1.0, radiusY: 0.3,
                          origin: SIMD3<Float>([0.3, 0.0, 0.0]),
                          offsetTheta: Float.pi / 2.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 1.0
                         ),
        // #2 : route for large fish
        FishRouteConstant(radiusX: 2.0, radiusZ: 1.0, radiusY: 0.3,
                          origin: SIMD3<Float>([0.0, 0.0, 1.0]),
                          offsetTheta: 0.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 1.0
                         ),
        // #3 : route for large fish (no rotation)
        FishRouteConstant(radiusX: 2.0, radiusZ: 1.0, radiusY: 0.3,
                          origin: SIMD3<Float>([0.0, 0.0, 1.0]),
                          offsetTheta: 0.0,
                          cycleRateY: 2.0,
                          cycleDivRateXZ: 2.0,
                          cycleMulRateXZ: 0.0
                         )
    ]

    static let stageConstants: [StageConstant] = [
        // #1 Daytime Stage
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
                      waveGeometryShader: "highWaveGeometryModifier",
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [0],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 40.0,
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [1],   // #1: Bonito (katsuo)
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [2, 3, 4],
                            fishNumber: 2,              // number of fish
                            fishRouteIndex: 2,          // #2: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // #2 Evening Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,       // Wave
                      secondSoundIndex: AssetConstant.MusicAssetIndex.aomuke.rawValue,    // Aomuke
                      stageAssetIndex: AssetConstant.StageAssetIndex.evening.rawValue,    // Evening
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
                      waveGeometryShader: "highWaveGeometryModifier",
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [0],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 40.0,
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [1],   // #1: Bonito
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [4, 2, 3],   // choose one
                            fishNumber: 2,              // number of fish
                            fishRouteIndex: 2,          // #2: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // #3 Night Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,         // Wave
                      secondSoundIndex: AssetConstant.MusicAssetIndex.hidamari.rawValue,    // Hidamari
                      stageAssetIndex: AssetConstant.StageAssetIndex.night.rawValue,        // Night
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
                      waveGeometryShader: nil,  // no wave animation
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [0],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 40.0,
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [1],   // #1: Bonito
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [3, 4, 2],
                            fishNumber: 2,              // number of fish
                            fishRouteIndex: 2,          // #3: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // #4: Room Stage
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
                      waveGeometryShader: "highWaveGeometryModifier",
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [0],   // #0: Umeiromodoki
                            fishNumber: 6,   // number of fish
                            fishRouteIndex: 0,          // #0: route for small fish
                            fishVelocity: -Float.pi * 2.0 / 40.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [1],   // #1: Bonito
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [4, 3, 2],   // chose one
                            fishNumber: 2,              // number of fish
                            fishRouteIndex: 2,          // #3: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // #5 Daytime North Pole Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,
                      secondSoundIndex: AssetConstant.MusicAssetIndex.inthewater.rawValue, // Paradise in the water
                      stageAssetIndex: AssetConstant.StageAssetIndex.daytimenpole.rawValue,
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
                      waveGeometryShader: nil,
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [5],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 40.0,
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [6],   // #1: Bonito (katsuo)
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [7, 8, 9],
                            fishNumber: 1,              // number of fish
                            fishRouteIndex: 2,          // #2: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // #6 Night North Pole Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,
                      secondSoundIndex: AssetConstant.MusicAssetIndex.uminomori.rawValue, // Umi no mori
                      stageAssetIndex: AssetConstant.StageAssetIndex.nightnpole.rawValue,
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
                      waveGeometryShader: nil,
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [5],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 40.0,
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [6],   // #1: Bonito (katsuo)
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [7, 8, 9],
                            fishNumber: 1,              // number of fish
                            fishRouteIndex: 2,          // #2: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ]),
        // #7 Room North Pole Stage
        StageConstant(firstSoundIndex: AssetConstant.MusicAssetIndex.wave.rawValue,
                      secondSoundIndex: AssetConstant.MusicAssetIndex.miyako.rawValue, // Ushinawareta Miyako
                      stageAssetIndex: AssetConstant.StageAssetIndex.roomnpole.rawValue,
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
                      waveGeometryShader: nil,
                      refuseNumbers: [20, 25],
                      fishGroups: [
                        FishGroupConstant(
                            fishPropertyIndexes: [5],
                            fishNumber: 6,
                            fishRouteIndex: 0,
                            fishVelocity: Float.pi * 2.0 / 40.0,
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [6],   // #1: Bonito (katsuo)
                            fishNumber: 3,              // number of fish
                            fishRouteIndex: 1,          // #1: route for midle fish
                            fishVelocity: Float.pi * 2.0 / 20.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        ),
                        FishGroupConstant(
                            fishPropertyIndexes: [7, 8, 9],
                            fishNumber: 1,              // number of fish
                            fishRouteIndex: 2,          // #2: route for large fish
                            fishVelocity: Float.pi * 1.0 / 50.0,  // [radian/sec]
                            fishAngleGap: (min: Float.pi / 8.0,
                                           max: Float.pi / 6.0), // [radian]
                            fishDiffMax: 0.1 // [m]
                        )
                      ])
    ]

    static var stageCount: Int { stageConstants.count }
}
