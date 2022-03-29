//
//  AudioChatViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/25.
//

import UIKit

class AudioChatViewController: BaseChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isCalled {
            startCall()
        }
    }
    
    override func initData() {
        contentView.delegate = self
        contentView.isCalled = isCalled
    }
    
    
    // MARK: - init
    init(startCall callee: String) {
        super.init(startCall: callee, callType: .audio)
    }
    
    init(responseCall caller: String, callID: UInt64) {
        super.init(responseCall: caller, callID: callID, callType: .audio)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AudioChatViewController: BaseChatViewDelegate {
    func refuseAudioCall() {
        response2Call(false)
    }
    
    func responseAudioCall() {
        response2Call(true)
    }
    
    func hangupAudioCall() {
        hangUp()
    }
}