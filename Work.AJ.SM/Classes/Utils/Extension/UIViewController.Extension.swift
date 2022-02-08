//
//  UIViewController.Extension.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/8.
//

import UIKit

extension UIViewController {
    class func currentViewController(base: UIViewController? = KeyWindow.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
