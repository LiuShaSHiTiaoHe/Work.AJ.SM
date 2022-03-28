//
//  VedioChatViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/25.
//

import UIKit
import NIMSDK
import NIMAVChat
class VideoChatViewController: BaseChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initData() {
        contentView.delegate = self
        contentView.isCalled = isCalled
        if !isCalled {
            startCall()
        }
    }
    
    override func initUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - init
    init(startCall callee: String) {
        super.init(startCall: callee, callType: .video)
    }
    
    init(responseCall caller: String, callID: UInt64) {
        super.init(responseCall: caller, callID: callID, callType: .video)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onRemoteImageReady(_ image: CGImage) {
        let videoImage = UIImage.init(cgImage: image)
        contentView.videoImageView.image = videoImage
    }
    
    override func onControl(_ callID: UInt64, from user: String, type control: NIMNetCallControlType) {
        super.onControl(callID, from: user, type: control)
        switch control {
        case .closeVideo:
            logger.info("对方关闭了摄像头")
        case .openVideo:
            logger.info("对方开启了摄像头")
            break
        default:
            break
        }
    }
    
    // MARK: - UI
    lazy var contentView: VideoChatView = {
        let view = VideoChatView()
        return view
    }()
}

extension VideoChatViewController: VideoChatViewDelegate {
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
