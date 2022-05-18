//
//  BaseTabBarViewController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import ESTabBarController_swift
import Haptica
import NIMAVChat

class BaseTabBarViewController: ESTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }

    func initData() {
        NIMAVChatSDK.shared().netCallManager.add(self)
        NIMSDK.shared().loginManager.add(self)
//        let _ = BLEAdvertisingManager.shared
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

// MARK: - 云信通话
extension BaseTabBarViewController: NIMNetCallManagerDelegate {
    func onReceive(_ callID: UInt64, from caller: String, type: NIMNetCallMediaType, message extendMessage: String?) {
        logger.info("收到通话请求。。。")
        if ud.allowVisitorCall {
            if type == .audio {
                let vc = AudioChatViewController.init(responseCall: caller, callID: callID)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            } else {
                let vc = VideoChatViewController.init(responseCall: caller, callID: callID)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension BaseTabBarViewController: NIMLoginManagerDelegate {
    func onKicked() {
        SVProgressHUD.showInfo(withStatus: "账号在其他终端登录")
        SVProgressHUD.dismiss(withDelay: 2) {
            GDataManager.shared.showLoginView()
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
