//
//  BaseNavigationController.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    private func initUI() {
        interactivePopGestureRecognizer?.delegate = self
        isNavigationBarHidden = true
        let navigationBarAppearance = UINavigationBar.appearance()
        let nBar = navigationBar
        nBar.isTranslucent = false

        if #available(iOS 15.0, *) {
            let barAppearance = UINavigationBarAppearance.init()
            barAppearance.backgroundColor = R.color.themecolor()
            barAppearance.shadowColor = .clear
            barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBarAppearance.scrollEdgeAppearance = barAppearance
            navigationBarAppearance.standardAppearance = barAppearance
            nBar.scrollEdgeAppearance = barAppearance
            nBar.standardAppearance = barAppearance
        } else {
            nBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            nBar.barTintColor = R.color.themecolor()
        }
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count == 1 {
            return false
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
}
