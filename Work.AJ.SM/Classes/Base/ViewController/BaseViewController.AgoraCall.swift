//
//  BaseViewController.AgoraCall.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/6.
//

extension BaseViewController: CallingViewControllerDelegate, BaseVideoChatVCDelegate {
    func startAgoraCall(with data: ToVideoChatModel) {
        let vc = CallingViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.data = data
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func callingVC(_ vc: CallingViewController, didHangup reason: HangupReason) {
        vc.dismiss(animated: reason.rawValue == 1 ? false : true) { [weak self] in
            guard let self = self else { return }
            switch reason {
            case .error:
                SVProgressHUD.showError(withStatus: "\(reason.description)")
            case .remoteReject(_):
                SVProgressHUD.showError(withStatus: "\(reason.description)")
            case .normally(let message):
                guard let inviter = AgoraRtm.shared().inviter else {
                    fatalError("rtm inviter nil")
                }
                SVProgressHUD.showInfo(withStatus: message)
            case .toVideoChat(let data):
                if !data.isEmpty() {
                    let vc = BaseVideoChatViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.delegate = self
                    vc.data = data
                    self.present(vc, animated: true)
                }
                break
            }
        }
    }
    
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt) {
        vc.dismiss(animated: true) {
            logger.info("\(uid)挂断")
            SVProgressHUD.showInfo(withStatus: "通话已结束")
        }
    }
}



