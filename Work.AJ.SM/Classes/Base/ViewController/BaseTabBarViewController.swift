//
//  BaseTabBarViewController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import ESTabBarController_swift
import Haptica
import SVProgressHUD
import SwiftyJSON
import AgoraRtmKit
import AgoraRtcKit

class BaseTabBarViewController: ESTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }

    func initData() {
        let rtm = AgoraRtm.shared()
        rtm.inviterDelegate = self
        if rtm.status == .offline {
            GDataManager.shared.loginAgoraRtm()
        }
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
        viewControllers = [v1, v4]
    }

    private func setupTabBar() {
        tabBar.isTranslucent = false
        delegate = self
        tabBar.barTintColor = R.color.bg()
        if #available(iOS 15, *) {
            let bar = UITabBarAppearance.init()
            bar.backgroundColor = R.color.bg()
            tabBar.scrollEdgeAppearance = bar
            tabBar.standardAppearance = bar
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Haptic.impact(.medium).generate()
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


extension BaseTabBarViewController: AgoraRtmInviterDelegate {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation) {
        if AgoraRtm.shared().status == .online {
            let vc = CallingViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.isOutgoing = false
            var data = ToVideoChatModel()
            data.localNumber = invitation.callee
            data.localType = .MobileApp
            data.localName = HomeRepository.shared.getCurrentHouseName()
            // MARK: - 被叫时 加入自己的channel
            data.channel = invitation.callee
            data.remoteNumber = invitation.caller
            // MARK: - content 放入两个参数，用','隔开:门口机的mac地址和名称
            /*
             "remoteType": "1"  mobile 1 device(门口机)2
             "remoteName": ""
             "lockMac": ""
             */
            if let content = invitation.content, !content.isEmpty {
                let jsonData = JSON(parseJSON: content)
                logger.info("RTM Invitation Content ===> \(jsonData)")
                data.lockMac = jsonData["lockMac"].stringValue
                data.remoteType = VideoCallRemoteType.init(rawValue: jsonData["remoteType"].stringValue) ?? .AndroidDevice
                data.remoteName = jsonData["remoteName"].stringValue
                vc.data = data
                present(vc, animated: true)
            } else {
                SVProgressHUD.showError(withStatus: "视频通话邀请参数不全")
            }
        }
    }
    
    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        if let vc = presentedViewController as? CallingViewController {
            vc.close(.normally("对方取消通话"))
        }
    }
}

extension BaseTabBarViewController: CallingViewControllerDelegate {
    func callingVC(_ vc: CallingViewController, didHangup reason: HangupReason) {
        vc.dismiss(animated: reason.rawValue == 1 ? false : true) { [weak self] in
            guard let self = self else { return }
            switch reason {
            case .error:
                SVProgressHUD.showError(withStatus: "\(reason.description)")
            case .remoteReject(let remote):
                SVProgressHUD.showError(withStatus: "对方拒绝接听")
            case .normally(let message):
                logger.info("no normally close \(message)")
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
}

extension BaseTabBarViewController: BaseVideoChatVCDelegate {
    func videoChat(_ vc: BaseVideoChatViewController, didEndChatWith uid: UInt) {
        vc.dismiss(animated: true) {
            logger.info("\(uid)挂断")
            SVProgressHUD.showInfo(withStatus: "通话结束")
        }
    }
}

