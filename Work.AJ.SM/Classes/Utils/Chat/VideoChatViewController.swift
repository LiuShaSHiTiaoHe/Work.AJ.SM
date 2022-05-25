//
//  VedioChatViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/25.
//

import UIKit
import NIMSDK
import NIMAVChat
import SVProgressHUD
class VideoChatViewController: BaseChatViewController {
    
    var lockMac: String?
    
    override func initData() {
        super.initData()
        contentView.delegate = self
    }
    
    // MARK: - init
    init(startCall callee: String) {
        super.init(startCall: kNIMSDKPrefixString + callee, callType: .video)
        if !callee.aj_isMobileNumber {
            lockMac = callee
        }
    }
    
    init(responseCall caller: String, callID: UInt64) {
        super.init(responseCall: caller, callID: callID, callType: .video)
        if caller.hasPrefix(kNIMSDKPrefixString) || caller.hasPrefix(kNIMSDKPrefixString.lowercased()){
            let callerNumberString = caller.jk.sub(from: kNIMSDKPrefixString.count)
            if !callerNumberString.aj_isMobileNumber {
                lockMac = callerNumberString
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if lockMac == nil {
            contentView.hideOpenDoorView()
        }
    }
    
    // MARK: - Delegate
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

}

// MARK: - OpenDoor
extension VideoChatViewController {
    @objc
    func openDoor() {
        // MARK: - 通话是app和门口机之间的
        if let lockMac = lockMac {
            HomeRepository.shared.openDoorViaPush(lockMac) { errorMsg in
                if !errorMsg.isEmpty {
                    SVProgressHUD.showError(withStatus: errorMsg)
                }else{
                    SVProgressHUD.showSuccess(withStatus: "开门成功")
                }
            }
        }
    }
}

extension VideoChatViewController: BaseChatViewDelegate {
    func refuseAudioCall() {
        response2Call(false)
    }
    
    func responseAudioCall() {
        response2Call(true)
        if lockMac == nil {
            contentView.hideOpenDoorView()
        }
    }
    
    func hangupAudioCall() {
        hangUp()
    }
    
    func openDoorInCall() {
        openDoor()
    }
}
