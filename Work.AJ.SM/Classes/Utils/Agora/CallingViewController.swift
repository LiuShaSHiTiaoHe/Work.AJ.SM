//
//  CallingViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/26.
//

import UIKit
import AgoraRtmKit
import AudioToolbox
import AVFoundation
import SwiftyJSON

protocol CallingViewControllerDelegate: NSObjectProtocol {
    func callingVC(_ vc: CallingViewController, didHangup reason: HangupReason)
}

class CallingViewController: BaseViewController {
    enum Operation {
        case on, off
    }
    
    weak var delegate: CallingViewControllerDelegate?
    var data: ToVideoChatModel?
    var isOutgoing: Bool = true
    // MARK: - 确定已经拨打出视频后，对方不在线，再去监听对方在线状态的变化
    private var isCallingOnReadingRemoteOnlineStatus: Bool = false
    
    private var ringStatus: Operation = .off {
        didSet {
            guard oldValue != ringStatus else {
                return
            }
            
            switch ringStatus {
            case .on:  startPlayRing()
            case .off: stopPlayRing()
            }
        }
    }
    
    private var animationStatus: Operation = .off {
        didSet {
            guard oldValue != animationStatus else {
                return
            }
            
            switch animationStatus {
            case .on:  startAnimating()
            case .off: stopAnimationg()
            }
        }
    }
    
    private var timer: Timer?
    private var soundId = SystemSoundID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationStatus = .on
        ringStatus = .on
        if isOutgoing {
            outGoingCallManage()
        }
    }
    
    override func initData() {
        try? AVAudioSession.sharedInstance().setMode(.videoChat)
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.allowBluetooth, .allowBluetoothA2DP])
        contentView.hangupButton.addTarget(self, action: #selector(doHungUpPressed(_:)), for: .touchUpInside)
        contentView.acceptButton.addTarget(self, action: #selector(acceptPressed(_:)), for: .touchUpInside)
        contentView.declineButton.addTarget(self, action: #selector(declinePressed(_:)), for: .touchUpInside)
    }
    
    func outGoingCallManage() {
        guard let data = data else {
            self.close(.normally("初始化数据错误"))
            return
        }

        guard let kit = AgoraRtm.shared().kit else {
            self.close(.normally("RTM初始化失败"))
            return
        }
        
        if let invitationData = buildInvitationContent(withVideoCallData: data) {
            let remoteNumber = invitationData.0
            let invitationContent = invitationData.1
            // MARK: - rtm query online status
           kit.queryPeerOnline(remoteNumber, success: {[weak self] (onlineStatus) in
               guard let self = self else { return }
               switch onlineStatus {
               case .online:
                   self.sendInvitation(remoteNumber, invitationContent, data)
               case .offline:
//                   self.resendInvitation(after: 15.0, remoteNumber, invitationContent, data)
//                   kit.send(AgoraRtmMessage.init(text: "Call"), toPeer: remoteNumber)
                   self.checkRemoteStatus(for: 5, remoteNumber, data)
               case .unreachable:
                   self.close(.remoteReject(remoteNumber))
               @unknown default:
                   fatalError("queryPeerOnline")
               }
           }) { [weak self] (error) in
               guard let self = self else { return }
               self.close(.error(error))
           }
        } else {
            self.close(.normally("初始化呼叫邀请数据失败"))
        }
    }
    
    func buildInvitationContent(withVideoCallData data: ToVideoChatModel) -> (String, String)? {
        let localName = HomeRepository.shared.getCurrentHouseName()
        let remoteType = data.remoteType
        let lockMac = data.lockMac
        let remoteNumber = data.remoteNumber
        if let invitationContent = ["remoteType": remoteType, "remoteName": localName, "lockMac": lockMac].toJSON(),
           invitationContent.isNotEmpty, remoteNumber.isNotEmpty {
            return (remoteNumber, invitationContent)
        }
        return nil
    }
    
    func sendInvitation(_ remoteNumber: String, _ invitationContent: String, _ videoChatData: ToVideoChatModel) {
        logger.info("sendInvitation")
        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }
        inviter.sendInvitation(peer: remoteNumber, extraContent: invitationContent, accepted: { [weak self] in
            guard let self = self else { return }
            if let _ = UInt(remoteNumber){
                self.close(.toVideoChat(videoChatData))
            }else{
                self.close(.normally("remoteNumber数据错误"))
            }
        }, refused: { [weak self] in
            guard let self = self else { return }
            self.close(.remoteReject(remoteNumber))
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.close(.error(error))
        }
    }
    
    func resendInvitation(after seconds: Double, _ remoteNumber: String, _ invitation: String, _ videoChatData: ToVideoChatModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            guard let `self` = self else { return }
            logger.info("resendInvitation")
            self.sendInvitation(remoteNumber, invitation, videoChatData)
        }
    }
    // MARK: - RTM开始不支持离线消息，订阅对方状态只是一次性的，Android推送如果直接打开app无法收到呼叫邀请。只能轮询查看对方是否在线。
    func checkRemoteStatus(for times: Int, _ remoteNumber: String, _ data: ToVideoChatModel) {
        logger.info("checkRemoteStatus")
        isCallingOnReadingRemoteOnlineStatus = true
        for t in 1...times {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(t*5)) { [weak self] in
                guard let `self` = self else { return }
                guard let kit = AgoraRtm.shared().kit else {
                    return
                }
                guard self.isCallingOnReadingRemoteOnlineStatus else { return }
                kit.queryPeerOnline(remoteNumber, success: {[weak self] (onlineStatus) in
                    guard let self = self else { return }
                    switch onlineStatus {
                    case .online:
                        self.isCallingOnReadingRemoteOnlineStatus = false
                        if let invitationData = self.buildInvitationContent(withVideoCallData: data) {
                            let remoteNumber = invitationData.0
                            let invitationContent = invitationData.1
                            self.sendInvitation(remoteNumber, invitationContent, data)
                        }
                    default:
                        break
                    }
                })
            }
        }
    }
    
    @objc
    func doHungUpPressed(_ sender: UIButton) {
        close(.normally(data?.remoteNumber ?? ""))
    }
    
    @objc
    func acceptPressed(_ sender: UIButton) {
        if let data = data {
            guard let inviter = AgoraRtm.shared().inviter else {
                fatalError("rtm inviter nil")
            }
            inviter.accpetLastIncomingInvitation()
            close(.toVideoChat(data))
        }else{
            close(.normally("channel或remoteNumber数据错误"))
        }
    }
    
    @objc
    func declinePressed(_ sender: UIButton) {
        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }
        inviter.refuseLastIncomingInvitation()
        close(.normally(data?.remoteNumber ?? ""))
    }
    
    func close(_ reason: HangupReason) {
        animationStatus = .off
        ringStatus = .off
        delegate?.callingVC(self, didHangup: reason)
    }
    
    // MARK: - UI
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.hangupButton.isHidden = !isOutgoing
        contentView.declineButton.isHidden = isOutgoing
        contentView.acceptButton.isHidden = isOutgoing
        contentView.numberLabel.text = data?.remoteName
    }
    
    lazy var contentView: AgoraCallingView = {
        let view = AgoraCallingView()
        return view
    }()
    
}



private extension CallingViewController {
    @objc func animation() {
        contentView.aureolaView.startLayerAnimation(aboveView: contentView.headImageView,
                                        layerWidth: 2)
    }
    
    func startAnimating() {
        let timer = Timer(timeInterval: 0.3,
                          target: self,
                          selector: #selector(animation),
                          userInfo: nil,
                          repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    func stopAnimationg() {
        timer?.invalidate()
        timer = nil
        contentView.aureolaView.removeAnimation()
    }
    
    func startPlayRing() {
        let path = Bundle.main.path(forResource: "ring", ofType: "mp3")
        let url = URL.init(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        
        AudioServicesAddSystemSoundCompletion(soundId,
                                              CFRunLoopGetMain(),
                                              nil, { (soundId, context) in
                                                AudioServicesPlaySystemSound(soundId)
        }, nil)
        
        AudioServicesPlaySystemSound(soundId)
    }
    
    func stopPlayRing() {
        AudioServicesDisposeSystemSoundID(soundId)
        AudioServicesRemoveSystemSoundCompletion(soundId)
    }
}

//extension CallingViewController: AgoraRtmDelegate {
//
////    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
////        logger.info("messageReceived =====> \(message.text)")
////        if isCallingOnReadingRemoteOnlineStatus, let data = data {
////            let remoteNumber = data.remoteNumber
////            if remoteNumber == peerId {
////                logger.info("")
////            }
////        }
////    }
//
//    func rtmKit(_ kit: AgoraRtmKit, peersOnlineStatusChanged onlineStatus: [AgoraRtmPeerOnlineStatus]) {
//        logger.info("peersOnlineStatusChanged =====> ")
//        if isCallingOnReadingRemoteOnlineStatus, let data = data {
//            let remoteNumber = data.remoteNumber
//            if let status = onlineStatus.first(where: { rtmPeer in
//                rtmPeer.peerId == remoteNumber && rtmPeer.isOnline
//            }), status.isOnline {
//                isCallingOnReadingRemoteOnlineStatus = false
//                if let invitationData = buildInvitationContent(withVideoCallData: data) {
//
//                    let remoteNumber = invitationData.0
//                    let invitationContent = invitationData.1
//                    sendInvitation(remoteNumber, invitationContent, data)
//                }
//            }
//        }
//    }
//}
