//
//  BaseTabBarViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import ESTabBarController_swift
import Haptica

import AgoraRtmKit
import AgoraRtcKit

class BaseTabBarViewController: ESTabBarController, UITabBarControllerDelegate {

//    private lazy var appleCallKit = CallCenter(delegate: self)
//    var prepareToVideoChat: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    func initData() {
//        loginAgoraRtm()
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
        if let account = ud.userMobile {
            HomeRepository.shared.agoraRTMToken { token in
                kit.login(account: account, token: token, fail:  { (error) in
                    logger.error("AgoraRtm ====> \(error.localizedDescription)")
                    SVProgressHUD.showError(withStatus: "error.localizedDescription")
                })
            }
      
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
//            let vc = BaseVideoChatViewController()
//            appleCallKit.showIncomingCall(of: invitation.caller)
        }
    }
    
    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        
    }
}

