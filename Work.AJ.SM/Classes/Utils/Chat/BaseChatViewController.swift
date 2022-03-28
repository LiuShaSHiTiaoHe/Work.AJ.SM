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

class BaseChatViewController: BaseViewController {

    // MARK: - 被叫号码
    var kCallee: String!
    // MARK: - 主叫号码
    var kCaller: String!
    // MARK: - 拨打 | 接听 标识
    var isCalled: Bool!
    // MARK: - 呼叫类型
    var kCallType: NIMNetCallMediaType!
    // MARK: - 呼叫ID
    var kCallID: UInt64!
    // MARK: - 聊天室用户，一对一时，最多两个，被叫和主叫
    var chatRoomUsers: [String] = []
    private var manager: NIMNetCallManager?

    init(startCall callee: String, callType: NIMNetCallMediaType) {
        self.kCaller = NIMSDK.shared().loginManager.currentAccount()
        self.kCallee = callee
        self.isCalled = false
        self.kCallType = callType
        self.kCallID = 0
        super.init(nibName: nil, bundle: nil)
    }
    
    init(responseCall caller: String, callID: UInt64, callType: NIMNetCallMediaType) {
        self.kCallID = callID
        self.kCallType = callType
        self.kCallee = NIMSDK.shared().loginManager.currentAccount()
        self.kCaller = caller
        self.isCalled = true
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NIMAVChatSDK.shared().netCallManager.add(self)
    }
    
    
    
    func startCall() {
        let callees = [kCallee!]
        let option = setupNetCallOption()
        option.extendMessage = "音视频请求扩展信息"
        option.apnsContent = kCallType == .audio ? "网络通话":"视频聊天"
        option.apnsSound = "video_chat_tip_receiver.aac"
        option.videoCaptureParam?.startWithCameraOn = kCallType == .video
        
        NIMAVChatSDK.shared().netCallManager.start(callees, type: kCallType, option: option) { [weak self] error, callID in
            guard let self = self else {
                NIMAVChatSDK.shared().netCallManager.hangup(callID)
                return
            }
            if error != nil {
                self.showErrorMessageAndDismiss("连接失败")
            }
            self.kCallID = callID
            self.chatRoomUsers.removeAll()
            //十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
            DispatchQueue.main.asyncAfter(deadline: .now()+10) {
                self.onControl(callID, from: self.kCallee, type: .feedabck)
            }
        }
    }
    
    func hangUp() {
        logger.info("BaseChatViewController =====> 挂断")
        NIMAVChatSDK.shared().netCallManager.hangup(kCallID)
        self.dismiss(animated: true) {}
    }
    
    func response2Call(_ accept: Bool) {
        let option = accept ? setupNetCallOption() : nil
        option?.videoCaptureParam?.startWithCameraOn = kCallType == .video
        NIMAVChatSDK.shared().netCallManager.response(kCallID, accept: accept, option: option) {[weak self] error, callID in
            guard let self = self else { return }
            if accept {
                if (error == nil) {
                    logger.info("BaseChatViewController =====> 接受")
                }else{
                    self.showErrorMessageAndDismiss("连接失败")
                }
            }else{
                self.showErrorMessageAndDismiss("")
            }
        }
    }

}

extension BaseChatViewController: NIMNetCallManagerDelegate {
    func onControl(_ callID: UInt64, from user: String, type control: NIMNetCallControlType) {
        logger.info("BaseChatViewController ================> onControl")
        //多端登录时，自己会收到自己发出的控制指令，这里忽略
        if user == NIMSDK.shared().loginManager.currentAccount() { return }
        if callID != kCallID { return }
        
        switch control {
        case .feedabck:
            logger.info("收到呼叫请求的反馈，通常用于被叫告诉主叫可以播放回铃音了")
            break
        case .busyLine:
            logger.info("占线")
            NIMAVChatSDK.shared().netCallManager.hangup(callID)
            showErrorMessageAndDismiss("对方正在通话")
            break
        case .startRecord:
            logger.info("开始录制")
            break
        case .stopRecord:
            logger.info("结束录制")
            break
        case .openAudio:
            logger.info("开启了音频")
            break
        case .closeAudio:
            logger.info("关闭了音频")
            break
        case .openVideo:
            logger.info("开启了视频")
            break
        case .closeVideo:
            logger.info("关闭了视频")
            break
        case .toVideo:
            logger.info("切换到视频模式")
            break
        case .agreeToVideo:
            logger.info("同意切换到视频模式，用于切到视频模式需要对方同意的场景")
            break
        case .rejectToVideo:
            logger.info("拒绝切换到视频模式，用于切到视频模式需要对方同意的场景")
            break
        case .toAudio:
            logger.info("切换到音频模式")
            break
        case .noCamera:
            logger.info("没有可用摄像头")
            break
        case .background:
            logger.info("应用切换到了后台")
            break
        @unknown default:
            break
        }
    }
    
    func onResponsed(byOther callID: UInt64, accepted: Bool) {
        showErrorMessageAndDismiss("已在其他端处理")
    }
    
    func onResponse(_ callID: UInt64, from callee: String, accepted: Bool) {
        logger.info("BaseChatViewController ================> onResponse")
        if kCallID == callID {
            if accepted {
                chatRoomUsers.append(callee)
            }else{
                showErrorMessageAndDismiss("对方拒绝接听")
            }
        }
    }
    
    func onCallDisconnected(_ callID: UInt64, withError error: Error?) {
        logger.info("BaseChatViewController ================> onCallDisconnected")
        if kCallID == callID {
            showErrorMessageAndDismiss("已断开")
        }
    }
    
    func onCallEstablished(_ callID: UInt64) {
        logger.info("BaseChatViewController ================> onCallEstablished")
        if kCallID == callID {
            let result = NIMAVChatSDK.shared().netCallManager.setSpeaker(true)
            if result {
                logger.info("麦克风开启成功")
            }
        }
    }
    
    func onHangup(_ callID: UInt64, by user: String) {
        logger.info("BaseChatViewController ================> onHangup")
        if kCallID == callID {
            showErrorMessageAndDismiss("对方已挂断")
        }
    }
    
    func onRemoteImageReady(_ image: CGImage) {
        logger.info("BaseChatViewController ================> onRemoteImageReady")
    }
    
}

// MARK: - Private func
extension BaseChatViewController {
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
//        option.videoMaxEncodeBitrate = 0
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
