//
//  ChatRingManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/24.
//

import UIKit

class ChatRingManager {

    static let shared = ChatRingManager()
    private var player: AudioPlayer?

    // MARK: - 呼叫
    func calling() {
        playSound("video_connect_chat_tip_sender")
    }
    // MARK: - 正在连接中
    func connecting() {
        playSound("video_chat_tip_sender")
    }
    // MARK: - 对方挂断
    func hangup() {
        playSound("video_chat_tip_HangUp")
    }
    // MARK: - 无人接听
    func timeOutRing(){
        playSound("video_chat_tip_onTimer")
    }
    // MARK: - 对方忙线
    func busyRing(){
        playSound("video_chat_tip_OnCall")
    }
    // MARK: - 接到呼叫
    func onCalledRing(){
        playSound("video_chat_tip_receiver")
    }
    
    func stopRing() {
        if let player = player {
            player.stop()
        }
    }

    private func playSound(_ soundName: String){
        do {
            player = try AudioPlayer(fileName: soundName)
        } catch {
            print("Sound initialization failed")
        }
    }
    
    private init(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCompletion(_:)),
                                               name: .SoundDidFinishPlayingNotification,
                                               object: nil)
    }
    
    @objc
    private func handleCompletion(_ notification: Notification) {
        if let audioPlayer = notification.object as? AudioPlayer,
            let name = audioPlayer.name,
            let success = notification.userInfo?[AudioPlayer.SoundDidFinishPlayingSuccessfully] {
            print("AudioPlayer with name '\(name)' did finish playing with success: \(success)")
        }
   }
}
