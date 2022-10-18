//
//  AppDelegate.Service.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/8.
//

import Foundation
import Moya
import SwiftyUserDefaults
import ObjectMapper
import SwiftyJSON
import SVProgressHUD
import IQKeyboardManagerSwift
import UIKit

extension AppDelegate {

    func initUI() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        setupRootViewController()
        window?.makeKeyAndVisible()
    }

    func initService() {
        logger.info("\(FileManager.jk.DocumnetsDirectory())")
        GDataManager.shared.setupKeyChain()
        GDataManager.shared.setupDataBase()
        GDataManager.shared.pushSetAlias()
        setupLibs()
    }

    func setupRootViewController() {
        if !ud.onboardStatus {
            window?.rootViewController = OnBoardViewController()
        } else {
            if GDataManager.shared.loginState() {
                let mainTabBarVc = BaseTabBarViewController()
                window?.rootViewController = mainTabBarVc
            } else {
                presentLogin()
            }
        }
    }

    func presentLogin() {
        let navi = BaseNavigationController.init(rootViewController: LoginViewController())
        window?.rootViewController = navi
    }

    func resetRootViewController() {
        let mainTabBarVc = BaseTabBarViewController()
        window?.rootViewController = mainTabBarVc
    }

    private func setupLibs() {
        SVProgressHUD.appearance().defaultStyle = .dark
        SVProgressHUD.appearance().maximumDismissTimeInterval = 2
        SVProgressHUD.appearance().minimumSize = CGSize.init(width: 100, height: 100)
        SVProgressHUD.appearance().imageViewSize = CGSize(width: 30, height: 30)
        SVProgressHUD.setRingRadius(30)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }


}
