//
//  AppDelegateNotification.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/4/2.
//

import UIKit

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func registerNotification(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        GDataManager.shared.setupPush(launchOptions)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        logger.info(userInfo)
    }

    //处理静默推送通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.info(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.info("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        logger.info("APNs token retrieved: \(deviceToken)")
        GDataManager.shared.registerDeviceToken(deviceToken)
    }
    
    //处理提醒通知
    // Receive displayed notifications for iOS 10 devices. in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        let userInfo = notification.request.content.userInfo
        logger.info(userInfo)
        completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      
        let userInfo = response.notification.request.content.userInfo
        logger.info(userInfo)
        completionHandler()
    }
}
