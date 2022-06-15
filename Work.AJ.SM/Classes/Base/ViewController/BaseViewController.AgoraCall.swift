//
//  BaseViewController.AgoraCall.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/6.
//

extension BaseViewController: CallingViewControllerDelegate, BaseVideoChatVCDelegate {
    func startAgoraCall(_ remoteNumber: String, _ lockMac: String, _ remoteName: String, _ remoteType: VideoCallRemoteType) {
        let vc = CallingViewController()
        vc.modalPresentationStyle = .fullScreen
        if let userID = ud.userID {
            let account = userID.ajAgoraAccount()
            let data = ToVideoChatModel.init(localNumber: account,
                    channel: remoteNumber,
                    remoteNumber: remoteNumber,
                    lockMac: lockMac,
                    remoteName: remoteName,
                    remoteType: remoteType.rawValue)
            vc.data = data
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func callingVC(_ vc: CallingViewController, didHungup reason: HungupReason) {
        vc.dismiss(animated: reason.rawValue == 1 ? false : true) { [weak self] in
            guard let self = self else { return }
            switch reason {
            case .error:
                SVProgressHUD.showError(withStatus: "\(reason.description)")
            case .remoteReject(let remote):
                SVProgressHUD.showError(withStatus: "\(reason.description)" + ": \(remote)")
            case .normally(_):
                guard let inviter = AgoraRtm.shared().inviter else {
                    fatalError("rtm inviter nil")
                }
                let errorHandle: ErrorCompletion = { (error: AGEError) in
                    SVProgressHUD.showError(withStatus: "\(error.localizedDescription)")
                }
                switch inviter.status {
                case .outgoing:
                    inviter.cancelLastOutgoingInvitation(fail: errorHandle)
                default:
                    break
                }
            case .toVideoChat(let info):
                if !info.isEmpty() {
                    let vc = BaseVideoChatViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.delegate = self
                    vc.channel = info.channel
                    vc.remoteUid = UInt(info.remoteNumber)
                    vc.lockMac = info.lockMac
                    vc.remoteType = info.remoteType
                    vc.remoteName = info.remoteName
                    vc.localUid = UInt(info.localNumber)//UInt(AgoraRtm.shared().account!)!
                    self.present(vc, animated: true)
                }
                break
            }
        }
    }
    
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt) {
        vc.dismiss(animated: true) {
            SVProgressHUD.showInfo(withStatus: "挂断-\(uid)")
        }
    }
}



