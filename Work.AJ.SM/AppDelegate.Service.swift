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

extension AppDelegate {
    
    func initUI() {
        window = UIWindow(frame: UIScreen.main.bounds)
        setupRootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func initService() {
        NetWorkManager.shared.initNetWork()
        setupDataBase()
        setuplibs()
    }
    
    func setupRootViewController() {
        let mainTabBarVc = BaseTabBarViewController()
        self.window?.rootViewController = mainTabBarVc
    }
    
   
    private func setupDataBase() {
        if let username = Defaults.username {
            RealmTools.configRealm(userID: username)
        }
    }
    
    private func setuplibs(){
        SVProgressHUD.appearance().defaultStyle = .dark
        SVProgressHUD.appearance().maximumDismissTimeInterval = 2
        SVProgressHUD.appearance().minimumSize = CGSize.init(width: 100, height: 100)
        SVProgressHUD.appearance().imageViewSize = CGSize(width: 60, height: 60)
        SVProgressHUD.setRingRadius(30)
        SVProgressHUD.setDefaultAnimationType(.native)
        
        IQKeyboardManager.shared.enable = true
    }

    
}
