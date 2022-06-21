//
//  AppDelegate.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initUI()
        initService()
        registerNotification(application, launchOptions)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // MARK: - 声网退出登录
        GDataManager.shared.logoutAgoraRtm()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // MARK: - 声网登录
        GDataManager.shared.loginAgoraRtm()
    }
}

