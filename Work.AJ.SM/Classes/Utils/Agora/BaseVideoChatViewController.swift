//
//  BaseVideoChatViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/26.
//

import UIKit
import AgoraRtcKit
import SnapKit
import SVProgressHUD

protocol BaseVideoChatVCDelegate: NSObjectProtocol {
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt)
}

class BaseVideoChatViewController: BaseViewController {

    private var localUid: UInt?
    private var remoteUid: UInt?

    var data: ToVideoChatModel? {
        didSet {
            if let data = data {
                localUid = UInt(data.localNumber)
                remoteUid = UInt(data.remoteNumber)
            }
        }
    }

    weak var delegate: BaseVideoChatVCDelegate?
    private var agoraKit: AgoraRtcEngineKit!

    private var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                contentView.micButton.isSelected = false
            }
            contentView.micButton.isHidden = !isStartCalling
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else { return }
        initializeAgoraEngine()
        setupVideo()
        // MARK: - hide local video view
        if let remoteUid = remoteUid, remoteUid.jk.uintToInt.jk.intToString.hasPrefix("41"), data.remoteType == .MobileApp {
            contentView.localVideo.isHidden = false
            agoraKit.enableLocalVideo(true)
            setupLocalVideo()
            contentView.openDoorButton.isHidden = true
        } else {
            contentView.openDoorButton.isHidden = false
            contentView.localVideo.isHidden = true
            agoraKit.enableLocalVideo(false)
        }
        joinChannel()
    }
    
    // MARK: - Functions
    override func initData() {
        contentView.hangupButton.addTarget(self, action: #selector(didClickHangUpButton(_ :)), for: .touchUpInside)
        contentView.micButton.addTarget(self, action: #selector(didClickMuteButton(_ :)), for: .touchUpInside)
        contentView.openDoorButton.addTarget(self, action: #selector(didClickOpenDoorButton), for: .touchUpInside)
    }
    
    
    // MARK: - init AgoraRtcEngineKit
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: kAgoraAppID, delegate: self)
    }
    
    func setupVideo() {
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative))
    }
    
    func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = contentView.localVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel() {
        guard let channel = data?.channel else {
            fatalError("rtc channel id nil")
        }
        guard let uid = localUid else {
            fatalError("rtc uid nil")
        }
        
        agoraKit.setEnableSpeakerphone(true)
        agoraKit.setAudioSessionOperationRestriction(.all)
        agoraKit.setAudioProfile(.speechStandard, scenario: .communication)
        // MARK: - Agora Remove Token
        self.agoraKit.joinChannel(byToken: nil,
                             channelId: channel,
                             info: nil,
                             uid: uid) {(channel, uid, elapsed) -> Void in
            logger.info("did join channer \(channel)")
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
        isStartCalling = false
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @objc
    func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
    }
    
    @objc
    func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @objc
    func didClickOpenDoorButton() {
        guard let lockMac = data?.lockMac else { return }
        if lockMac.isEmpty {
            SVProgressHUD.showError(withStatus: "开门数据错误")
        }else{
            HomeRepository.shared.openDoorViaPush(lockMac) { errorMsg in
                if !errorMsg.isEmpty {
                    SVProgressHUD.showError(withStatus: errorMsg)
                }else{
                    SVProgressHUD.showSuccess(withStatus: "开门成功")
                }
            }
        }
    }
    
    @objc
    func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.switchCamera()
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var contentView: AgoraVideoChatView = {
        let view = AgoraVideoChatView()
        return view
    }()
}

extension BaseVideoChatViewController: AgoraRtcEngineDelegate{
    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = contentView.remoteVideo
        videoCanvas.renderMode = .hidden
        videoCanvas.mirrorMode = .disabled
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    // FIXME: - uid 跟remote ID 不一样？
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        logger.info("didOfflineOfUid: \(uid)")
        leaveChannel()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid: UInt) {

    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        logger.info("did occur warning, code: \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        logger.info("did occur error, code: \(errorCode.rawValue)")
        SVProgressHUD.showError(withStatus: "呼叫错误 - \(errorCode.rawValue)")
        SVProgressHUD.dismiss(withDelay: 2) {
            if errorCode.rawValue != 18 {
                self.leaveChannel()
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {
        logger.info("did occur AgoraConnectionChangedReason, code: \(reason.rawValue)")
    }
}
