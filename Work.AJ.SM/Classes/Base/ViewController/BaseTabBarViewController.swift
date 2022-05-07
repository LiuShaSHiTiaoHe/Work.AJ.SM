//
//  BaseTabBarViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import ESTabBarController_swift
import Haptica
import SVProgressHUD

import AgoraRtmKit
import AgoraRtcKit

class BaseTabBarViewController: ESTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    func initData() {
        loginAgoraRtm()
    }
    
    func initUI() {
        setupTabBar()
        
        let v1 = BaseNavigationController.init(rootViewController: HomeViewController())
        let v2 = BaseNavigationController.init(rootViewController: ServiceViewController())
        let v3 = BaseNavigationController.init(rootViewController: NeighbourhoodViewController())
        let v4 = BaseNavigationController.init(rootViewController: MineViewController())
        v1.tabBarItem = ESTabBarItem.init(BouncesTabBarContentView(), title: "首页", image: R.image.tab_icon_home_normal(), selectedImage: R.image.tab_icon_home_selected())
        v2.tabBarItem = ESTabBarItem.init(BouncesTabBarContentView(), title: "服务", image: R.image.tab_icon_service_normal(), selectedImage: R.image.tab_icon_service_selected())
        v3.tabBarItem = ESTabBarItem.init(BouncesTabBarContentView(), title: "邻里圈", image: R.image.tab_icon_neighbourhood_normal(), selectedImage: R.image.tab_icon_neighbourhood_selected())
        v4.tabBarItem = ESTabBarItem.init(BouncesTabBarContentView(), title: "我的", image: R.image.tab_icon_mine_normal(), selectedImage: R.image.tab_icon_mine_selected())
        self.viewControllers = [v1, v4]
    }

    private func setupTabBar(){
        self.tabBar.isTranslucent = false
        self.delegate = self
        self.tabBar.barTintColor = R.color.backgroundColor()
        if #available(iOS 15, *) {
            let bar = UITabBarAppearance.init()
            bar.backgroundColor = R.color.backgroundColor()
            self.tabBar.scrollEdgeAppearance = bar
            self.tabBar.standardAppearance = bar
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Haptic.impact(.medium).generate()
    }
    
    private func loginAgoraRtm(){
        let rtm = AgoraRtm.shared()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/rtm.log"
        rtm.setLogPath(path)
        rtm.inviterDelegate = self
                
        // rtm login
        guard let kit = AgoraRtm.shared().kit else {
            SVProgressHUD.showError(withStatus: "AgoraRtmKit nil")
            return
        }
        
        if let userID = ud.userID {
            // MARK: - Agora Device Account 默认加41前缀，跟门口机设备区分
            let account = userID.ajAgoraAccount()
            kit.login(account: account, token: nil, fail:  { (error) in
                logger.error("AgoraRtm ====> \(error.localizedDescription)")
                SVProgressHUD.showError(withStatus: "error.localizedDescription")
            })
            // MARK: - Agora Remove Token
//            HomeRepository.shared.agoraRTMToken { token in
//                if token.isEmpty {
//                    logger.error("AgoraRtm ====> RTM token 获取失败")
//                }else{
//                    kit.login(account: account, token: token, fail:  { (error) in
//                        logger.error("AgoraRtm ====> \(error.localizedDescription)")
//                        SVProgressHUD.showError(withStatus: "error.localizedDescription")
//                    })
//                }
//            }
        }
    }
}

extension BaseTabBarViewController {
    func observeOpenDoorStyle() {
        let _ = ud.observe(\.openDoorStyle) { update in
            if update.newValue == 1 {
                UIApplication.shared.applicationSupportsShakeToEdit = true
                self.becomeFirstResponder()
            }
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            if ud.openDoorStyle == 1 {
                Haptic.impact(.heavy).generate()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            if ud.openDoorStyle == 1 {
                BLEAdvertisingManager.shared.openDoor()
            }
        }
    }
}


extension BaseTabBarViewController: AgoraRtmInvitertDelegate {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation) {
        if AgoraRtm.shared().status == .online {
            let vc = CallingViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.isOutgoing = false
            vc.localNumber = invitation.callee
            vc.remoteNumber = invitation.caller
            vc.channel = invitation.caller
            if let content = invitation.content {
                vc.lockMac = content
            }
            self.present(vc, animated: true)
        }
    }
    
    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        if let vc = self.presentedViewController as? BaseVideoChatViewController {
            vc.leaveChannel()
            vc.dismiss(animated: true, completion: nil)
        }
    }
}

extension BaseTabBarViewController: CallingViewControllerDelegate {
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
            case .toVideoChat(let channel , let remote, let lockMac):
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
}

extension BaseTabBarViewController: BaseVideoChatVCDelegate {
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt) {
        vc.dismiss(animated: true) {
            SVProgressHUD.showInfo(withStatus: "挂断-\(uid)")
        }
    }
}

