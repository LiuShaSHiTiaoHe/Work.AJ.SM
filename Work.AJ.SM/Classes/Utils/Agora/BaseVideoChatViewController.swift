//
//  BaseVideoChatViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/26.
//

import UIKit
import AgoraRtcKit

protocol BaseVideoChatVCDelegate: NSObjectProtocol {
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt)
}

class BaseVideoChatViewController: BaseViewController {

    var localUid: UInt?
    var remoteUid: UInt?
    var channel: String?
    weak var delegate: BaseVideoChatVCDelegate?
    private var agoraKit: AgoraRtcEngineKit!

    private var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
            cameraButton.isHidden = !isStartCalling
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initData() {
        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo()
        joinChannel()
    }
    
    // MARK: - init AgoraRtcEngineKit
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: kAgoraAppID, delegate: self)
    }
    
    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        agoraKit.enableVideo()
        
        // Set video configuration
        // Please go to this page for detailed explanation
        // https://docs.agora.io/cn/Voice/API%20Reference/java/classio_1_1agora_1_1rtc_1_1_rtc_engine.html#af5f4de754e2c1f493096641c5c5c1d8f
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative))
    }
    
    func setupLocalVideo() {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel() {
        // Set audio route to speaker
        // For videocalling, we don't suggest letting sdk handel audio routing
//        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        guard let channel = channel else {
            fatalError("rtc channel id nil")
        }
        
        guard let uid = localUid else {
            fatalError("rtc uid nil")
        }
        
        // Sets the audio session's operational restriction.
        agoraKit.setAudioSessionOperationRestriction(.all)
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.        
        HomeRepository.shared.agoraRTCToken {[weak self] token in
            guard let self = self else { return }
            self.agoraKit.joinChannel(byToken: token,
                                 channelId: channel,
                                 info: nil,
                                 uid: uid) { [unowned self] (channel, uid, elapsed) -> Void in
                // Did join channel
//                self.isLocalVideoRender = true
//                self.logVC?.log(type: .info, content: "did join channel")
            }
        }
        
        isStartCalling = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func leaveChannel() {
        // leave channel and end chat
        agoraKit.leaveChannel(nil)
        
        guard let remoteUid = remoteUid else {
            fatalError("remoteUid nil")
        }
        
        delegate?.videoChat(self, didEndChatWith: remoteUid)
        
//        isRemoteVideoRender = false
//        isLocalVideoRender = false
        isStartCalling = false
        UIApplication.shared.isIdleTimerDisabled = false
//        self.logVC?.log(type: .info, content: "did leave channel")
    }
    
    @objc
    func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    @objc
    func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.switchCamera()
    }
    
    // MARK: - UI
    override func initUI() {
        
    }
    
    lazy var localVideo: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var remoteVideo: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var micButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
    lazy var hangupButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()

    lazy var cameraButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
}

extension BaseVideoChatViewController: AgoraRtcEngineDelegate{
    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
//        isRemoteVideoRender = true
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
//        isRemoteVideoRender = false
        
        guard let remoteUid = remoteUid else {
            fatalError("remoteUid nil")
        }
        print("didOfflineOfUid: \(uid)")
        if uid == remoteUid {
            leaveChannel()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid: UInt) {
//        isRemoteVideoRender = !muted
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        logger.info("did occur warning, code: \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        logger.info("did occur error, code: \(errorCode.rawValue)")
    }
}
