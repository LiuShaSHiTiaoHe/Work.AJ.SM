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
        hangupButton.addTarget(self, action: #selector(doHungUpPressed(_:)), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptPressed(_:)), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(declinePressed(_:)), for: .touchUpInside)
    }
    
    
    func startCall() {
        guard let kit = AgoraRtm.shared().kit else {
            fatalError("rtm kit nil")
        }
        
        guard let localNumber = localNumber else {
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
    
    override func initUI() {
        view.backgroundColor = .systemBlue
        view.addSubview(headImageView)
        view.addSubview(numberLabel)
        view.addSubview(declineButton)
        view.addSubview(acceptButton)
        view.addSubview(hangupButton)
        
        hangupButton.isHidden = !isOutgoing
        declineButton.isHidden = isOutgoing
        acceptButton.isHidden = isOutgoing
        
        headImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kTitleAndStateHeight + 50)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImageView.snp.bottom).offset(kMargin)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        declineButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-100)
            make.right.equalTo(view.snp.centerX).offset(-50)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(declineButton)
            make.left.equalTo(view.snp.centerX).offset(50)
        }
        
        hangupButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(declineButton)
            make.centerX.equalToSuperview()
        }
        
    }
    
    lazy var headImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.defaultavatar()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = k16Font
        view.textColor = R.color.themeColor()
        return view
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_refuse_image(), for: .normal)
        return button
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_response_image(), for: .normal)
        return button
    }()
    
    lazy var hangupButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(R.image.chat_hangup_image(), for: .normal)
        return button
    }()
    
    private let aureolaView = AureolaView(color: UIColor(red: 173.0 / 255.0,
                                                         green: 211.0 / 255.0,
                                                         blue: 252.0 / 255.0, alpha: 1))
}



private extension CallingViewController {
    @objc func animation() {
        aureolaView.startLayerAnimation(aboveView: headImageView,
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
        aureolaView.removeAnimation()
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
