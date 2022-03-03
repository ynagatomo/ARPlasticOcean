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
    static let medalSoundID = 0
    static let collectSoundID = 1
    static let cleanedSound = 2
    var enable = true
    private var players: [AudioPlayer] = []

    struct AudioPlayer {
        let player: AVAudioPlayer?
        let fileName: String
        let extName: String
    }

    init() {
        // register default sounds
        // 1) Medal Sound
        let medalIndex = AssetConstant.SoundEffectAssetIndex.medal.rawValue
        let medalName = AssetConstant.soundEffectAssets[medalIndex].soundFile
        let medalExt = AssetConstant.soundEffectAssets[medalIndex].soundFileExt
        let medalPlayer = try? AVAudioPlayer(contentsOf: Bundle.main.url(
                forResource: medalName, withExtension: medalExt)!)
        medalPlayer?.prepareToPlay() // load into the buffer
        players.append(AudioPlayer(player: medalPlayer,
                                       fileName: medalName, extName: medalExt))
        // 2) Collect Sound
        let collectIndex = AssetConstant.SoundEffectAssetIndex.collect.rawValue
        let collectName = AssetConstant.soundEffectAssets[collectIndex].soundFile
        let collectExt = AssetConstant.soundEffectAssets[collectIndex].soundFileExt
        let collectPlayer = try? AVAudioPlayer(contentsOf: Bundle.main.url(
                forResource: collectName, withExtension: collectExt)!)
        collectPlayer?.prepareToPlay() // load into the buffer
        players.append(AudioPlayer(player: collectPlayer,
                                       fileName: collectName, extName: collectExt))
        // 3) Cleaned Sound
        let cleanedIndex = AssetConstant.SoundEffectAssetIndex.cleanup.rawValue
        let cleanedName = AssetConstant.soundEffectAssets[cleanedIndex].soundFile
        let cleanedExt = AssetConstant.soundEffectAssets[cleanedIndex].soundFileExt
        let cleanedPlayer = try? AVAudioPlayer(contentsOf: Bundle.main.url(
                forResource: cleanedName, withExtension: cleanedExt)!)
        cleanedPlayer?.prepareToPlay() // load into the buffer
        players.append(AudioPlayer(player: cleanedPlayer,
                                       fileName: cleanedName, extName: cleanedExt))
    }

    func register(name: String, ext: String, loop: Int) -> SoundID {
        // already exist?
        if let id = players.firstIndex(where: {
            $0.fileName == name && $0.extName == ext
        }) {
            return id
        }

        // add the new player
        let player = try? AVAudioPlayer(contentsOf: Bundle.main.url(
                                     forResource: name, withExtension: ext)!)
        player?.prepareToPlay() // load into the buffer
        player?.numberOfLoops = loop
        players.append(AudioPlayer(player: player, fileName: name, extName: ext))

        assert( players.count >= 1)
        return players.count - 1    // the last one
    }

    func play(soundID: SoundID) {
        assert(soundID < players.count)
        guard enable else { return }

        let audioPlayer = players[soundID]
        audioPlayer.player?.pause()  // keep the buffer
        audioPlayer.player?.currentTime = 0.0
        audioPlayer.player?.play()
    }

    func stop(soundID: SoundID) {
        assert(soundID < players.count)
        let audioPlayer = players[soundID]
        audioPlayer.player?.pause() // keep the buffer
    }

    func stopAll() {
        players.forEach { player in
            let audioPlayer = player
            audioPlayer.player?.pause() // keep the buffer
        }
    }
}
