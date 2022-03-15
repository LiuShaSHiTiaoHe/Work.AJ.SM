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
        logger.info("\(FileManager.jk.DocumnetsDirectory())")
        logger.info("Main Scale == > \(kScale), Width Scale ==> \(kWidthScale), Height Scale ==> \(kHeightScale)")
        initUI()
        initService()
        return true
    }

   

}

