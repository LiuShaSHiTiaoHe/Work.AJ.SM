//
//  AppDelegate.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Defaults.username = "15295776453"
        
        initUI()
        initService()
        return true
    }

   

}

