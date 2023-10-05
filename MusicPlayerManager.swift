//
//  MusicPlayerManager.swift
//  spotify_io_GSK
//
//  Created by kevin on 04/10/2023.
//

import Foundation
import AVKit

class MusicPlayerManager {
    static let shared = MusicPlayerManager()
    
    public var audioPlayer: AVPlayer?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    
    
    //
    
    
    var isPlaying: Bool {
        return audioPlayer?.rate != 0 && audioPlayer?.error == nil
    }
    
    func playMusic(with music: Music?) {
        if let musicURL = URL(string: music?.preview ?? "") {
            let playerItem = AVPlayerItem(url: musicURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            
            audioPlayer?.play()
        }
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        audioPlayer?.seek(to: cmTime)
    }
    
    
    
}
