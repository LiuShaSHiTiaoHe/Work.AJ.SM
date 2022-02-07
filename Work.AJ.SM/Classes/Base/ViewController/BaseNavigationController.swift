//
//  BaseNavigationController.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = self
        
        let navigationBarAppearence = UINavigationBar.appearance()
        let nBar = self.navigationBar
        nBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let barAppearance = UINavigationBarAppearance.init()
            barAppearance.backgroundColor = R.color.themeColor()
            barAppearance.shadowColor = .clear
            barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBarAppearence.scrollEdgeAppearance = barAppearance
            navigationBarAppearence.standardAppearance = barAppearance
            nBar.scrollEdgeAppearance = barAppearance
            nBar.standardAppearance = barAppearance
        } else {
            nBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            nBar.barTintColor = R.color.themeColor()
        }
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
