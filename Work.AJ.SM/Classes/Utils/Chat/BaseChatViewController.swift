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
import JKSwiftExtension

class BaseChatViewController: BaseViewController {

    var name: String?
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ChatRingManager.shared.stopRing()
    }
    
    override func initData() {
        NIMAVChatSDK.shared().netCallManager.add(self)
        contentView.isVideoCall = kCallType == .video
        contentView.isCalled = isCalled
        if let name = name, !name.isEmpty {
            updateContactName(name)
        }else{
            updateContactName((isCalled ? kCaller: kCallee))
        }
        if !isCalled {
            ChatRingManager.shared.calling()
            startCall()
        }else{
            ChatRingManager.shared.onCalledRing()
        }
    }
        
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - UI
    lazy var contentView: BaseChatView = {
        let view = BaseChatView()
        return view
    }()
    
    func updateContactName(_ name: String) {
        contentView.nameLabel.text = name
    }
    
    func updateTips(_ tips: String) {
        contentView.tipsLabel.text = tips
    }
    
    // MARK: - function
    func startCall() {
        let callees = [kCallee!]
        let option = setupNetCallOption()
        option.extendMessage = "音视频请求扩展信息"
        option.apnsContent = kCallType == .audio ? "网络通话":"视频聊天"
        option.apnsSound = "video_chat_tip_receiver.aac"
        option.videoCaptureParam?.startWithCameraOn = kCallType == .video
        updateTips("呼叫中...")
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
        logger.info("挂断")
        NIMAVChatSDK.shared().netCallManager.hangup(kCallID)
        updateTips("挂断中...")
        self.showErrorMessageAndDismiss("挂断中...")
    }
    
    func response2Call(_ accept: Bool) {
        let option = accept ? setupNetCallOption() : nil
        option?.videoCaptureParam?.startWithCameraOn = kCallType == .video
        NIMAVChatSDK.shared().netCallManager.response(kCallID, accept: accept, option: option) {[weak self] error, callID in
            guard let self = self else { return }
            if accept {
                if (error == nil) {
                    logger.info("接受")
                    self.updateTips("连接中...")
                }else{
                    self.updateTips("连接失败")
                    self.showErrorMessageAndDismiss("连接失败")
                }
            }else{
                self.showErrorMessageAndDismiss("")
            }
        }
    }

}

extension BaseChatViewController: NIMNetCallManagerDelegate {

    func onSessionTimeDuration(_ timeDuration: UInt64) {
        let seconds = Int(timeDuration/1000)
        let timeString = Date.jk.getFormatPlayTime(seconds: seconds, type: .second)
        updateTips(timeString)
    }
    
    func onResponsed(byOther callID: UInt64, accepted: Bool) {
        showErrorMessageAndDismiss("已在其他端处理")
    }
    
    func onResponse(_ callID: UInt64, from callee: String, accepted: Bool) {
        logger.info("onResponse")
        if kCallID == callID {
            if accepted {
                chatRoomUsers.append(callee)
                updateTips("对方已接受,连接中...")
                ChatRingManager.shared.onCalledRing()
            }else{
                showErrorMessageAndDismiss("对方拒绝接听")
                ChatRingManager.shared.hangup()
            }
        }
    }
    
    func onCallDisconnected(_ callID: UInt64, withError error: Error?) {
        logger.info("onCallDisconnected")
        ChatRingManager.shared.stopRing()
        if kCallID == callID {
            updateTips("通话已断开")
            showErrorMessageAndDismiss("已断开")
        }
    }
    
    func onCallEstablished(_ callID: UInt64) {
        logger.info("onCallEstablished")
        ChatRingManager.shared.stopRing()
        if kCallID == callID {
            let result = NIMAVChatSDK.shared().netCallManager.setSpeaker(true)
            if result {
                logger.info("麦克风开启成功")
            }
        }
    }
    
    func onHangup(_ callID: UInt64, by user: String) {
        logger.info("onHangup")
        if kCallID == callID {
            updateTips("对方已挂断")
            showErrorMessageAndDismiss("对方已挂断")
            ChatRingManager.shared.stopRing()
        }
    }
    
    func onRemoteImageReady(_ image: CGImage) {
        logger.info("onRemoteImageReady")
    }
    
    func onControl(_ callID: UInt64, from user: String, type control: NIMNetCallControlType) {
        logger.info("onControl")
        //多端登录时，自己会收到自己发出的控制指令，这里忽略
        if user == NIMSDK.shared().loginManager.currentAccount() { return }
        if callID != kCallID { return }
        
        switch control {
        case .feedabck:
            logger.info("收到呼叫请求的反馈，通常用于被叫告诉主叫可以播放回铃音了")
            ChatRingManager.shared.connecting()
            break
        case .busyLine:
            logger.info("占线")
            NIMAVChatSDK.shared().netCallManager.hangup(callID)
            showErrorMessageAndDismiss("对方正在通话")
            ChatRingManager.shared.busyRing()
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

