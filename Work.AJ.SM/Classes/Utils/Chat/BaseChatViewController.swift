//
//  BaseChatViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/24.
//

import UIKit
import NIMSDK
import NIMAVChat
import SVProgressHUD

class BaseChatViewController: UIViewController {

    // MARK: - 被叫号码
    var kCallee: String!
    // MARK: - 主叫号码
    var kCaller: String!
    // MARK: - 拨打 | 接听 标识
    var isCalled: Bool!
    // MARK: - 呼叫类型
    var kCallType: NIMNetCallType!
    // MARK: - 呼叫ID
    var kCallID: UInt64!
    // MARK: - 聊天室用户，一对一时，最多两个，被叫和主叫
    var chatRoomUsers: [String] = []
    private var manager: NIMNetCallManager?

    
    init(callee: String, caller: String, calltype: NIMNetCallType, callID: UInt64) {
        self.kCallee = callee
        self.kCaller = caller
        self.kCallType = calltype
        self.kCallID = callID
        let account = NIMSDK.shared().loginManager.currentAccount()
        if account == caller {
            isCalled = false
        }else{
            isCalled = true
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = R.color.backgroundColor()
    }
    
    
    func startCall() {
        
    }
    
    func hangUp() {
        logger.info(" =====> 挂断")
        NIMAVChatSDK.shared().netCallManager.hangup(kCallID)
        self.dismiss(animated: true) {}
    }
    
    func response2Call(_ accept: Bool) {
        let option = setupNetCallOption()
        NIMAVChatSDK.shared().netCallManager.response(kCallID, accept: accept, option: option) {[weak self] error, callID in
            guard let self = self else { return }
            if accept {
                if (error != nil) {
                    logger.info(" =====> 接受")

                }else{
                    self.showErrorMessageAndDismiss("连接失败")
                }
            }else{
                self.showErrorMessageAndDismiss("")
            }
        }
        
        
    }
    
    // MARK: - Private
    private func showErrorMessageAndDismiss(_ msg: String){
        if msg.isEmpty{
            self.dismiss(animated: true, completion: nil)
        }else{
            SVProgressHUD.showError(withStatus: msg)
            SVProgressHUD.dismiss(withDelay: 1) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    private func setupNetCallOption() -> NIMNetCallOption {
        let option = NIMNetCallOption.init()
        option.autoRotateRemoteVideo = false
        option.preferredVideoEncoder = .default
        option.preferredVideoDecoder = .default
        option.videoMaxEncodeBitrate = 0
        option.autoDeactivateAudioSession = true
        option.audioDenoise = true
        option.voiceDetect = true
        option.preferHDAudio = true
        option.scene = .default
        let param = NIMNetCallVideoCaptureParam.init()
        param.preferredVideoQuality = .qualityDefault
        param.videoCrop = .cropNoCrop
        param.startWithBackCamera = false
        option.videoCaptureParam = param
        return option
    }

}

extension BaseChatViewController: NIMNetCallManagerDelegate {
    func onControl(_ callID: UInt64, from user: String, type control: NIMNetCallControlType) {
        //多端登录时，自己会收到自己发出的控制指令，这里忽略
        if user == NIMSDK.shared().loginManager.currentAccount() {
            return
        }
        
        if callID != kCallID {
            return
        }
        
        switch control {
            
        case .feedabck:
            break
        case .busyLine:
            break
        case .startRecord:
            break
        case .stopRecord:
            break
        case .openAudio:
            break
        case .closeAudio:
            break
        case .openVideo:
            break
        case .closeVideo:
            break
        case .toVideo:
            break
        case .agreeToVideo:
            break
        case .rejectToVideo:
            break
        case .toAudio:
            break
        case .noCamera:
            break
        case .background:
            break
        @unknown default:
            break
        }
    }
    
    func onResponsed(byOther callID: UInt64, accepted: Bool) {
        
    }
    
    func onResponse(_ callID: UInt64, from callee: String, accepted: Bool) {
        
    }
    
    func onCallDisconnected(_ callID: UInt64, withError error: Error?) {
        
    }
    
    func onCallEstablished(_ callID: UInt64) {
        
    }
}
