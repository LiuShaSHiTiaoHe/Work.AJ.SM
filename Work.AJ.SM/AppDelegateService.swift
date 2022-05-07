//
//  AppDelegate.Service.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/8.
//

import Foundation
import Moya
import SwiftyUserDefaults
import ObjectMapper
import SwiftyJSON
import SVProgressHUD
import IQKeyboardManagerSwift
import Siren

extension AppDelegate {
    
    func initUI() {
        window = UIWindow(frame: UIScreen.main.bounds)
        setupRootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func initService() {
        logger.info("\(FileManager.jk.DocumnetsDirectory())")
        GDataManager.shared.setupKeyChain()
        GDataManager.shared.setupDataBase()
        setuplibs()
    }
    
    func setupRootViewController() {
        if !ud.onboardStatus {
            self.window?.rootViewController = OnBoardViewController()
        }else{
            if GDataManager.shared.loginState() {
                let mainTabBarVc = BaseTabBarViewController()
                self.window?.rootViewController = mainTabBarVc
            }else{
                presentLogin()
            }
        }
    }
    
    func presentLogin() {
        let navi = BaseNavigationController.init(rootViewController: LoginViewController())
        self.window?.rootViewController = navi
    }
    
    func resetRootViewController() {
        let mainTabBarVc = BaseTabBarViewController()
        self.window?.rootViewController = mainTabBarVc
    }
    
    private func setuplibs(){
        SVProgressHUD.appearance().defaultStyle = .dark
        SVProgressHUD.appearance().maximumDismissTimeInterval = 2
        SVProgressHUD.appearance().minimumSize = CGSize.init(width: 100, height: 100)
        SVProgressHUD.appearance().imageViewSize = CGSize(width: 30, height: 30)
        SVProgressHUD.setRingRadius(30)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.clear)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GDataManager.shared.setupNIMSDK()
        GDataManager.shared.loginNIMSDK()
    }
    
    
}
