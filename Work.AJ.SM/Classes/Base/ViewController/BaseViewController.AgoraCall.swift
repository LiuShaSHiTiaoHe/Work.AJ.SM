//
//  BaseViewController.AgoraCall.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/6.
//

extension BaseViewController: CallingViewControllerDelegate, BaseVideoChatVCDelegate {
    func startAgoraCall(_ remote: String, _ lockMac: String) {
        let vc = CallingViewController()
        vc.modalPresentationStyle = .fullScreen
        if let localUser = HomeRepository.shared.getCurrentUser(), let localUserRID = localUser.rid {
            vc.remoteNumber = "1272"//remote
            vc.localNumber = localUserRID
            vc.channel = localUserRID
            vc.lockMac = "00606ebea4f4"//lockMac
            vc.delegate = self
            self.present(vc, animated: true)
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
            case .normaly(_):
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
            case .toVideoChat(let channel, let remote, let lockMac):
                let vc = BaseVideoChatViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                vc.channel = channel
                vc.remoteUid = remote
                vc.lockMac = lockMac
                vc.localUid = UInt(AgoraRtm.shared().account!)!
                self.present(vc, animated: true)
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



