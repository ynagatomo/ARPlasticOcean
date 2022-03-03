//
//  SoundManager.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/03.
//

import Foundation
import AVFoundation

class SoundManager {
    typealias SoundID = Int
    static let MedalSoundID = 0
    private var players: [AVAudioPlayer?] = []

    init() {
        // register default sounds
        // 1) Medal Sound
        if let player = try? AVAudioPlayer(
            contentsOf: Bundle.main.url(forResource: AppConstant.soundMedalName,
                                        withExtension: AppConstant.soundMedalExt)!) {
            player.prepareToPlay() // load into the buffer
            players.append(player)
        } else {
            players.append(nil)
        }
    }

    func register(name: String, extension: String) -> SoundID {
        return 0
    }

    func play(soundID: SoundID, enable: Bool) {
        assert(soundID < players.count)
        guard enable else { return }

        if let player = players[soundID] {
            player.pause()  // keep the buffer
            player.currentTime = 0.0
            player.play()
        }
    }

    func stop(soundID: SoundID) {
        assert(soundID < players.count)
        if let player = players[soundID] {
            player.pause() // keep the buffer
        }
    }
}
