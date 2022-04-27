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

protocol CallingViewControllerDelegate: NSObjectProtocol {
    func callingVC(_ vc: CallingViewController, didHungup reason: HungupReason)
}

class CallingViewController: BaseViewController {
    enum Operation {
        case on, off
    }
    
    weak var delegate: CallingViewControllerDelegate?
    var localNumber: String?
    var remoteNumber: String?
    var channel: String?
    var isOutgoing: Bool = true
    
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
            startCall()
        }
    }
    
    
    override func initData() {
        try? AVAudioSession.sharedInstance().setMode(.videoChat)
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.allowBluetooth, .allowBluetoothA2DP])
        contentView.hangupButton.addTarget(self, action: #selector(doHungUpPressed(_:)), for: .touchUpInside)
        contentView.acceptButton.addTarget(self, action: #selector(acceptPressed(_:)), for: .touchUpInside)
        contentView.declineButton.addTarget(self, action: #selector(declinePressed(_:)), for: .touchUpInside)
    }
    
    
    func startCall() {
        guard let kit = AgoraRtm.shared().kit else {
            fatalError("rtm kit nil")
        }
        
        guard let _ = localNumber else {
            fatalError("localNumber nil")
        }
        guard let remoteNumber = remoteNumber else {
            fatalError("remoteNumber nil")
        }

        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }
                
        // rtm query online status
        kit.queryPeerOnline(remoteNumber, success: {[weak self] (onlineStatus) in
            guard let self = self else { return }
            switch onlineStatus {
            case .online:      sendInvitation(remote: remoteNumber)
            case .offline:     self.close(.remoteReject(remoteNumber))
            case .unreachable: self.close(.remoteReject(remoteNumber))
            @unknown default:  fatalError("queryPeerOnline")
            }
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.close(.error(error))
        }
        
        // rtm send invitation
        func sendInvitation(remote: String) {
            let channel = "iOSTestChannel"
            inviter.sendInvitation(peer: remoteNumber, extraContent: channel, accepted: { [weak self] in
                guard let self = self else { return }
                if let remote = UInt(remoteNumber){
                    self.close(.toVideoChat(channel, remote))
                }else{
                    self.close(.normaly("channel或remoteNumber数据错误"))
                }
            }, refused: { [weak self] in
                guard let self = self else { return }
                self.close(.remoteReject(remoteNumber))
            }) { [weak self] (error) in
                guard let self = self else { return }
                self.close(.error(error))
            }
        }
    }
    
    @objc
    func doHungUpPressed(_ sender: UIButton) {
        close(.normaly(remoteNumber!))
    }
    
    @objc
    func acceptPressed(_ sender: UIButton) {
        if let channel = channel, let remoteNumber = remoteNumber, let remote = UInt(remoteNumber) {
            guard let inviter = AgoraRtm.shared().inviter else {
                fatalError("rtm inviter nil")
            }
            inviter.accpetLastIncomingInvitation()
            close(.toVideoChat(channel, remote))
        }else{
            close(.normaly("channel或remoteNumber数据错误"))
        }
    }
    
    @objc
    func declinePressed(_ sender: UIButton) {
        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }
        inviter.refuseLastIncomingInvitation()
        close(.normaly(remoteNumber!))
    }
    
    func close(_ reason: HungupReason) {
        animationStatus = .off
        ringStatus = .off
        delegate?.callingVC(self, didHungup: reason)
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
